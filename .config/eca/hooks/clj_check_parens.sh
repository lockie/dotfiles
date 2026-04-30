# Hook to check Clojure files with clj-kondo and auto-repair parens
# First install latest [babashka] + [bbin]. Then run: bbin install https://github.com/bhauman/clojure-mcp-light.git --as clj-paren-repair --main-opts '["-m" "clojure-mcp-light.paren-repair"]'

# Read stdin and extract path (returns empty string if null/invalid)
file_path=$(jq -r '.tool_input.path // empty' 2>/dev/null)

# Helper function to generate JSON output
respond() {
  cat <<EOF
{
  "suppressOutput": $1,
  "systemMessage": "$2",
  "additionalContext": "$3"
}
EOF
}

# 1. Guard Clause: Exit if no path or not a Clojure file
if [[ -z "$file_path" || ! "$file_path" =~ \.(clj|cljs|cljd|cljc)$ ]]; then
  respond true
  exit 0
fi

# 2. Run clj-kondo (We only care about Exit Code 3: Unbalanced Parens)
clj-kondo --lint "$file_path" &>/dev/null
if [ $? -ne 3 ]; then
  respond true
  exit 0
fi

# 3. Attempt Repair
if clj-paren-repair "$file_path" &>/dev/null; then
  respond false "Unbalanced parens fixed." "Unbalanced parens have been automatically fixed."
else
  respond false "Unbalanced parens not fixed!" "Unbalanced parens couldn't be automatically fixed. Tell user to fix it manually."
fi

exit 0
