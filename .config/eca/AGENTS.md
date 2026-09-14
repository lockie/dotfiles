# Global Instructions

## Environment

- You're running on a Gentoo GNU/Linux system.
- System locale is `ru_RU.UTF8`, which may change the language of command output.
- Current year is 2026, but **NEVER** assume the current date — run `date` to get the exact date info when needed.

## Shell & tools

- **NEVER** use `pip install` to install Python or other packages. Use `uv` or `uvx` instead.
- **NEVER** background processes with `&` in `shell_command` — they time out. Use background jobs instead.
- When using `sleep` in `shell_command`, set a timeout greater than the sleep duration.
- Call `grep` as `/bin/grep`, since `grep` is aliased to `ag`, "the silver searcher".

## Git commits

- Use past tense in commit messages.
- Don't put a dot at the end of commit messages.
