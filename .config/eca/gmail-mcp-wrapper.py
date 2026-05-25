#!/usr/bin/env python3
"""Gmail MCP wrapper: auto-refreshes tokens before starting the MCP server."""

import fcntl, json, sys, os, time, urllib.parse, urllib.request, http.server, socket, subprocess

CREDENTIALS_PATH = os.environ.get(
    "GMAIL_CREDENTIALS_PATH", os.path.expanduser("~/.gmail-mcp/credentials.json")
)
CREDENTIALS_PATH = os.path.realpath(CREDENTIALS_PATH)
OAUTH_KEYS_PATH = os.environ.get(
    "GMAIL_OAUTH_PATH", os.path.expanduser("~/.gmail-mcp/gcp-oauth.keys.json")
)
LOCK_PATH = CREDENTIALS_PATH + ".lock"
SCOPES = " ".join([
    "https://www.googleapis.com/auth/gmail.modify",
    "https://www.googleapis.com/auth/gmail.compose",
    "https://www.googleapis.com/auth/gmail.send",
    "https://www.googleapis.com/auth/gmail.settings.basic",
    "https://www.googleapis.com/auth/gmail.settings.sharing",
])


def log(msg):
    print(f"[gmail-mcp-wrapper] {msg}", file=sys.stderr)


def load_oauth_keys():
    with open(OAUTH_KEYS_PATH) as f:
        d = json.load(f)
    installed = d.get("installed", d.get("web", {}))
    return installed["client_id"], installed["client_secret"]


def load_credentials():
    if not os.path.exists(CREDENTIALS_PATH):
        return {}
    with open(CREDENTIALS_PATH) as f:
        return json.load(f)


def save_credentials(tokens):
    with open(CREDENTIALS_PATH, "w") as f:
        json.dump(tokens, f, indent=2)


def try_refresh(client_id, client_secret, refresh_token):
    """Refresh access token. Returns new tokens dict or None."""
    data = urllib.parse.urlencode({
        "client_id": client_id,
        "client_secret": client_secret,
        "refresh_token": refresh_token,
        "grant_type": "refresh_token",
    }).encode()
    req = urllib.request.Request("https://oauth2.googleapis.com/token", data=data)
    try:
        with urllib.request.urlopen(req) as resp:
            result = json.loads(resp.read())
    except urllib.error.HTTPError as e:
        body = json.loads(e.read())
        if body.get("error") == "invalid_grant":
            return None
        log(f"Token refresh error: {body}")
        return None
    result["expiry_date"] = int(time.time() * 1000) + result.get("expires_in", 3600) * 1000
    if "refresh_token" not in result or not result["refresh_token"]:
        result["refresh_token"] = refresh_token
    return result


def interactive_auth(client_id, client_secret):
    """Open browser for OAuth consent, wait for callback, return new tokens."""
    port = _free_port()
    redirect_uri = f"http://localhost:{port}"
    auth_url = (
        "https://accounts.google.com/o/oauth2/v2/auth"
        f"?access_type=offline&scope={urllib.parse.quote(SCOPES)}"
        f"&response_type=code&client_id={client_id}"
        f"&redirect_uri={redirect_uri}"
    )

    log("Opening browser for Gmail re-authentication...")
    log(f"If browser doesn't open, visit:\n{auth_url}")

    subprocess.Popen(["xdg-open", auth_url],
                     stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

    result = [None]

    class Handler(http.server.BaseHTTPRequestHandler):
        def do_GET(self):
            params = urllib.parse.parse_qs(urllib.parse.urlparse(self.path).query)
            if "code" not in params:
                self.send_response(400); self.end_headers()
                self.wfile.write(b"No code received."); return
            code = params["code"][0]
            data = urllib.parse.urlencode({
                "code": code, "client_id": client_id,
                "client_secret": client_secret,
                "redirect_uri": redirect_uri,
                "grant_type": "authorization_code",
            }).encode()
            try:
                with urllib.request.urlopen(
                    urllib.request.Request("https://oauth2.googleapis.com/token", data=data)
                ) as resp:
                    tokens = json.loads(resp.read())
                tokens["expiry_date"] = int(time.time() * 1000) + tokens.get("expires_in", 3600) * 1000
                result[0] = tokens
                self.send_response(200)
                self.send_header("Content-Type", "text/html"); self.end_headers()
                self.wfile.write(b"<h1>Authentication successful! You can close this tab.</h1>")
            except Exception as e:
                self.send_response(500); self.end_headers()
                self.wfile.write(f"Auth failed: {e}".encode())

        def log_message(self, *args): pass

    http.server.HTTPServer(("localhost", port), Handler).handle_request()
    return result[0]


def _free_port():
    s = socket.socket(); s.bind(("", 0)); port = s.getsockname()[1]; s.close()
    return port


def needs_refresh(creds):
    """True if access token is expired or missing."""
    if not creds.get("refresh_token"):
        return True
    expiry = creds.get("expiry_date", 0)
    return expiry <= int(time.time() * 1000) + 300_000  # 5 min buffer


def _release_lock(lock_fd):
    lock_fd.close()
    try:
        os.unlink(LOCK_PATH)
    except FileNotFoundError:
        pass


def ensure_valid_tokens(client_id, client_secret):
    """Refresh or re-authenticate. Uses a file lock so only one instance
    opens the browser; the rest wait for it to finish."""
    lock_fd = open(LOCK_PATH, "w")
    fcntl.flock(lock_fd, fcntl.LOCK_EX)

    # Re-read credentials after acquiring lock — another process may have
    # already refreshed them while we waited.
    creds = load_credentials()
    if not needs_refresh(creds):
        log("Another instance already refreshed the token.")
        _release_lock(lock_fd)
        return

    refresh_token = creds.get("refresh_token", "")

    if refresh_token:
        log("Access token expired. Refreshing...")
        new = try_refresh(client_id, client_secret, refresh_token)
        if new:
            save_credentials(new)
            log("Token refreshed.")
            _release_lock(lock_fd)
            return
        log("Refresh token expired. Starting interactive auth...")
        new = interactive_auth(client_id, client_secret)
        if new:
            save_credentials(new)
            log("Re-authenticated.")
        else:
            _release_lock(lock_fd)
            log("ERROR: Interactive auth failed.")
            sys.exit(1)
    else:
        log("No refresh token found. Starting interactive auth...")
        new = interactive_auth(client_id, client_secret)
        if new:
            save_credentials(new)
            log("Authenticated.")
        else:
            _release_lock(lock_fd)
            log("ERROR: Interactive auth failed.")
            sys.exit(1)

    _release_lock(lock_fd)


def main():
    client_id, client_secret = load_oauth_keys()

    if needs_refresh(load_credentials()):
        ensure_valid_tokens(client_id, client_secret)

    os.environ["PORT"] = str(_free_port())
    os.execvp("npx", ["npx", "-y", "@shinzolabs/gmail-mcp", *sys.argv[1:]])


if __name__ == "__main__":
    main()
