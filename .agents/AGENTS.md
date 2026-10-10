# Global Instructions

## Environment

- You're running on a Gentoo GNU/Linux system.
- System locale is `ru_RU.UTF8`, which may change the language of command output.
- Current year is 2026, but **NEVER** assume the current date — run `date` to get the exact date info when needed.

## Shell & tools

- **NEVER** use `pip install` to install Python or other packages. Use `uv` or `uvx` instead.
- **NEVER** background processes with `&` or `nohup` in the shell tool: they time out or escape job tracking. Use the shell tool's own background mechanism instead — background jobs for commands that finish on their own, named/managed services for long-running servers and watchers.
- When using `sleep` in the shell tool, set a timeout greater than the sleep duration.
- In shell commands, call `grep` as `/bin/grep`, since `grep` is aliased to `ag`, "the silver searcher".

## Git commits

- Use past tense in commit messages.
- Don't put a dot at the end of commit messages.
- The first line of commit message should fit 79 characters limit.
