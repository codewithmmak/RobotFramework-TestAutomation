import sys
import json
import xml.etree.ElementTree as ET
from pathlib import Path
from datetime import datetime, timezone


def get_test_elements(root):
    for test in root.iter("test"):
        status = test.find("status")
        if status is None:
            continue
        yield test, status


def get_retry_metrics(audit_path: Path):
    if not audit_path.exists():
        return 0, 0, 0

    retried_tests = set()
    total_retried_actions = 0
    max_retry_attempt = 0

    for raw_line in audit_path.read_text(encoding="utf-8").splitlines():
        line = raw_line.strip()
        if not line:
            continue
        parts = line.split(",")
        if len(parts) < 3:
            continue
        test_name = parts[0].strip()
        attempt = parts[2].strip()
        try:
            attempt_num = int(attempt)
        except ValueError:
            continue

        if attempt_num > 1:
            retried_tests.add(test_name)
            total_retried_actions += 1
            if attempt_num > max_retry_attempt:
                max_retry_attempt = attempt_num

    return len(retried_tests), total_retried_actions, max_retry_attempt


def main() -> int:
    if len(sys.argv) != 2:
        print("Usage: python scripts/ci_metrics.py <output.xml>")
        return 1

    xml_path = Path(sys.argv[1])
    if not xml_path.exists():
        print(f"Metrics: output not found at {xml_path}")
        return 0

    root = ET.parse(xml_path).getroot()

    total = 0
    passed = 0
    failed = 0
    elapsed_ms = 0

    for _test, status in get_test_elements(root):
        total += 1
        outcome = (status.attrib.get("status") or "").upper()
        elapsed_ms += int(status.attrib.get("elapsed", "0"))
        if outcome == "PASS":
            passed += 1
        elif outcome == "FAIL":
            failed += 1

    pass_rate = (passed / total * 100.0) if total else 0.0
    retried_tests, retried_actions, max_retry_attempt = get_retry_metrics(
        Path("results") / "retry_audit.csv"
    )

    print("## Robot Test Metrics")
    print(f"- Total: {total}")
    print(f"- Passed: {passed}")
    print(f"- Failed: {failed}")
    print(f"- Pass rate: {pass_rate:.2f}%")
    print(f"- Duration (ms): {elapsed_ms}")
    print(f"- Retried tests: {retried_tests}")
    print(f"- Retried actions: {retried_actions}")
    print(f"- Max retry attempt used: {max_retry_attempt}")

    summary_file = Path("results") / "metrics-summary.md"
    summary_file.parent.mkdir(parents=True, exist_ok=True)
    summary_file.write_text(
        "\n".join(
            [
                "## Robot Test Metrics",
                f"- Total: {total}",
                f"- Passed: {passed}",
                f"- Failed: {failed}",
                f"- Pass rate: {pass_rate:.2f}%",
                f"- Duration (ms): {elapsed_ms}",
                f"- Retried tests: {retried_tests}",
                f"- Retried actions: {retried_actions}",
                f"- Max retry attempt used: {max_retry_attempt}",
            ]
        ),
        encoding="utf-8",
    )

    github_summary = Path("/github/workflow-summary")
    if github_summary.exists():
        with github_summary.open("a", encoding="utf-8") as handle:
            handle.write("\n")
            handle.write(summary_file.read_text(encoding="utf-8"))
            handle.write("\n")

    history_file = Path("results") / "metrics-history.json"
    entry = {
        "timestamp": datetime.now(timezone.utc).isoformat(),
        "total": total,
        "passed": passed,
        "failed": failed,
        "pass_rate": round(pass_rate, 2),
        "duration_ms": elapsed_ms,
        "retried_tests": retried_tests,
        "retried_actions": retried_actions,
        "max_retry_attempt": max_retry_attempt,
    }

    history = []
    if history_file.exists():
        try:
            history = json.loads(history_file.read_text(encoding="utf-8"))
            if not isinstance(history, list):
                history = []
        except (json.JSONDecodeError, OSError):
            history = []

    history.append(entry)
    history_file.write_text(json.dumps(history, indent=2), encoding="utf-8")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
