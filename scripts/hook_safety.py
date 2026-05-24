import json
import sys


def main() -> int:
    raw = sys.stdin.read().strip()
    if not raw:
        return 0

    try:
        payload = json.loads(raw)
    except json.JSONDecodeError:
        return 0

    tool_input = payload.get("toolInput", {})
    command = str(tool_input.get("command", "")).lower()

    blocked_patterns = [
        "git reset --hard",
        "git checkout --",
        "del /f /q",
        "rm -rf /",
    ]

    if any(pattern in command for pattern in blocked_patterns):
        response = {
            "hookSpecificOutput": {
                "hookEventName": "PreToolUse",
                "permissionDecision": "deny",
                "permissionDecisionReason": "Blocked potentially destructive command by workspace safety hook"
            }
        }
        print(json.dumps(response))
        return 0

    allow_response = {
        "hookSpecificOutput": {
            "hookEventName": "PreToolUse",
            "permissionDecision": "allow",
            "permissionDecisionReason": "Command passed workspace safety checks"
        }
    }
    print(json.dumps(allow_response))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
