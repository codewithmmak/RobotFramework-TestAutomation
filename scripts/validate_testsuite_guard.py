import subprocess
import sys
from pathlib import Path


def run_command(command: list[str]) -> int:
    print(f"Running: {' '.join(command)}")
    proc = subprocess.run(command, check=False)
    return proc.returncode


def main() -> int:
    repo_root = Path(__file__).resolve().parents[1]
    marker = repo_root / "results" / ".testsuite_validation.ok"
    marker.parent.mkdir(parents=True, exist_ok=True)

    venv_python = repo_root / "venv" / "Scripts" / "python.exe"
    runner = str(venv_python) if venv_python.exists() else sys.executable

    tag_cmd = [runner, "scripts/validate_test_tags.py", "TestSuite"]
    dry_cmd = [
        runner,
        "-m",
        "robot",
        "--dryrun",
        "--variablefile",
        "TestData/Environments/qa.yaml",
        "--outputdir",
        "results",
        "TestSuite",
    ]

    tag_rc = run_command(tag_cmd)
    if tag_rc != 0:
        return tag_rc

    dry_rc = run_command(dry_cmd)
    if dry_rc != 0:
        return dry_rc

    marker.write_text("validated\n", encoding="utf-8")
    print(f"Validation marker refreshed: {marker}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
