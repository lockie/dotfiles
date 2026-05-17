#!/usr/bin/env bash
# Pick a free port for the Gmail MCP OAuth callback server,
# so multiple instances can run concurrently without port conflicts.
PORT=$(python3 -c "import socket; s=socket.socket(); s.bind(('',0)); print(s.getsockname()[1]); s.close()")
export PORT
exec npx -y @shinzolabs/gmail-mcp "$@"
