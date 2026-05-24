import csv
import json
import sys
from pathlib import Path


def main() -> int:
    if len(sys.argv) != 3:
        print("Usage: python scripts/metrics_to_csv.py <input.json> <output.csv>")
        return 1

    input_path = Path(sys.argv[1])
    output_path = Path(sys.argv[2])

    if not input_path.exists():
        print(f"Metrics history file not found: {input_path}")
        return 0

    try:
        data = json.loads(input_path.read_text(encoding="utf-8"))
    except json.JSONDecodeError as exc:
        print(f"Invalid JSON in {input_path}: {exc}")
        return 1

    if not isinstance(data, list):
        print(f"Expected a JSON array in {input_path}")
        return 1

    fieldnames = [
        "timestamp",
        "total",
        "passed",
        "failed",
        "pass_rate",
        "duration_ms",
        "retried_tests",
        "retried_actions",
        "max_retry_attempt",
    ]

    output_path.parent.mkdir(parents=True, exist_ok=True)
    with output_path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=fieldnames)
        writer.writeheader()
        for row in data:
            if not isinstance(row, dict):
                continue
            writer.writerow({name: row.get(name, "") for name in fieldnames})

    print(f"CSV written to {output_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
