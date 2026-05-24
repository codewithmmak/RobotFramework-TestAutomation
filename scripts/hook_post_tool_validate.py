import json
import sys
import time
from pathlib import Path


def _contains_testsuite_path(data: object) -> bool:
    if isinstance(data, dict):
        for key, value in data.items():
            if isinstance(value, str) and "testsuite/" in value.lower().replace("\\", "/"):
                return True
            if _contains_testsuite_path(value):
                return True
    elif isinstance(data, list):
        for item in data:
            if _contains_testsuite_path(item):
                return True
    elif isinstance(data, str):
        if "testsuite/" in data.lower().replace("\\", "/"):
            return True
    return False


def main() -> int:
    raw = sys.stdin.read().strip()
    if not raw:
        return 0

    try:
        payload = json.loads(raw)
    except json.JSONDecodeError:
        return 0

    if _contains_testsuite_path(payload):
        repo_root = Path(__file__).resolve().parents[1]
        marker = repo_root / "results" / ".testsuite_validation.ok"
        max_age_seconds = 30 * 60

        is_fresh = False
        if marker.exists():
            age = time.time() - marker.stat().st_mtime
            is_fresh = age <= max_age_seconds

        if not is_fresh:
            response = {
                "decision": "block",
                "systemMessage": (
                    "TestSuite changes detected without fresh validation marker. "
                    "Run: python scripts/validate_testsuite_guard.py"
                ),
            }
        else:
            response = {
                "decision": "continue",
                "systemMessage": "Fresh TestSuite validation marker found. Proceeding.",
            }

        print(json.dumps(response))

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
