import re
import sys
from pathlib import Path

REQUIRED_RULES = {
    "owner": re.compile(r"^owner_"),
    "priority": re.compile(r"^priority_"),
    "component": re.compile(r"^component_"),
    "type": re.compile(r"^type_"),
}


def extract_test_cases(content: str):
    lines = content.splitlines()
    in_tests = False
    current_test = None
    current_tags = []

    for line in lines:
        stripped = line.strip()
        if stripped == "*** Test Cases ***":
            in_tests = True
            continue
        if stripped.startswith("*** ") and stripped != "*** Test Cases ***":
            in_tests = False

        if not in_tests:
            continue

        if stripped and not line.startswith(" ") and not line.startswith("\t") and not stripped.startswith("#"):
            if current_test is not None:
                yield current_test, current_tags
            current_test = stripped
            current_tags = []
            continue

        if stripped.startswith("[Tags]"):
            parts = [p for p in re.split(r"\s{2,}|\t+", stripped) if p]
            current_tags.extend(parts[1:])

    if in_tests and current_test is not None:
        yield current_test, current_tags


def validate_file(path: Path):
    content = path.read_text(encoding="utf-8")
    issues = []
    for test_name, tags in extract_test_cases(content):
        missing = []
        for rule_name, pattern in REQUIRED_RULES.items():
            if not any(pattern.search(tag) for tag in tags):
                missing.append(rule_name)
        if missing:
            issues.append((test_name, missing, tags))
    return issues


def main() -> int:
    root = Path(sys.argv[1]) if len(sys.argv) > 1 else Path("TestSuite")
    if not root.exists():
        print(f"Test suite path not found: {root}")
        return 1

    files = sorted(root.rglob("*.robot"))
    all_issues = []

    for file_path in files:
        issues = validate_file(file_path)
        for test_name, missing, tags in issues:
            all_issues.append((file_path, test_name, missing, tags))

    if all_issues:
        print("Tag policy validation failed:")
        for file_path, test_name, missing, tags in all_issues:
            print(f"- {file_path}: {test_name}")
            print(f"  Missing: {', '.join(missing)}")
            print(f"  Found tags: {', '.join(tags) if tags else '(none)'}")
        return 1

    print(f"Tag policy validation passed for {len(files)} files.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
