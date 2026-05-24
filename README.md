![Robot Test Automation Framework](./Images/robot-framework.png?raw=true "Robot Test Automation Framework")

# OrangeHRM Robot Test Automation Framework

A production-ready web UI test automation framework for OrangeHRM Demo built with **Robot Framework 6** and **SeleniumLibrary**, following industry-standard practices: keyword-driven architecture, negative testing, CI/CD integration, and linting.

---

## Features

- Keyword-driven architecture with clear separation of concerns (Locators → Keywords → Test Data → Test Suites)
- **SeleniumLibrary 6** (replaces legacy Selenium2Library)
- Automatic screenshot capture on test failure
- Tagged tests (`smoke`, `regression`, `negative`) for selective execution
- Governance tags for ownership and prioritization (`owner_*`, `priority_*`, `component_*`, `type_ui`)
- Environment profile support via YAML variable files (`dev`, `qa`, `staging`, `prodlike`)
- Dynamic test-data factory for collision-safe test data
- Fallback locator strategy (primary + CSS fallback) for resilient element resolution
- Negative and boundary test cases alongside happy-path tests
- GitHub Actions CI/CD quality gate with browser matrix (headless Chrome + headless Firefox)
- Targeted retry wrappers for transient UI actions (click/input/clear)
- Retry audit and flakiness metrics (`retried tests`, `retried actions`, `max retry attempt`)
- Persistent JSON trend history for dashboard plotting (`metrics-history.json`)
- CSV trend export for BI/dashboard tools (`metrics-history.csv`)
- Parallel execution support via `pabot`
- Allure reporting integration
- Static analysis via `robocop` linter + pre-commit hook

---

## Project Structure

```
RobotFramework-TestAutomation/
├── Keywords/                          # Business-level reusable keywords
│   ├── LaunchApplication.robot        # Browser open/close keywords
│   └── OrangeHRMKeywords.robot        # OrangeHRM action/validation keywords
├── Libraries/
│   └── TestDataFactory.py             # Dynamic test data factory
├── Objects/
│   └── Locators/                      # Page locators (Page Object layer)
│       └── OrangeHRMLocators.robot
├── TestData/                          # Test variables and configuration
│   ├── TestConfig.robot               # Global config (URL, browser, timeouts)
│   ├── Environments/                  # Environment profile variable files
│   │   ├── dev.yaml
│   │   ├── qa.yaml
│   │   ├── staging.yaml
│   │   └── prodlike.yaml
│   └── OrangeHRMData.robot            # OrangeHRM test data
├── TestSuite/                         # Test cases
│   └── OrangeHRMAuthTest.robot        # OrangeHRM tests (TC001–TC008)
├── .github/workflows/robot-tests.yml  # GitHub Actions CI pipeline
├── .robocop                           # Robocop linter configuration
├── .pre-commit-config.yaml            # Local quality gate hooks
├── .gitignore
└── requirements.txt
```

---

## Test Cases

| ID | Test Case | Tags |
|----|-----------|------|
| TC001 | Valid Login Redirects To Dashboard | smoke, regression, auth, owner_ui_team, priority_p1, component_auth, type_ui |
| TC002 | Invalid Password Shows Error Message | regression, negative, auth, owner_ui_team, priority_p1, component_auth, type_ui |
| TC003 | Empty Credentials Show Required Validation | regression, negative, auth, owner_ui_team, priority_p1, component_auth, type_ui |
| TC004 | Logged In User Can Logout Successfully | regression, auth, owner_ui_team, priority_p1, component_auth, type_ui |
| TC005 | Logged In User Can Open PIM Module | regression, navigation, owner_ui_team, priority_p2, component_navigation, type_ui |
| TC006 | Invalid Username Shows Error Message | regression, negative, auth, owner_ui_team, priority_p1, component_auth, type_ui |
| TC007 | Forgot Password Request Shows Success Message | regression, auth, owner_ui_team, priority_p2, component_auth, type_ui |
| TC008 | Password Field Is Masked On Login Page | regression, auth, owner_ui_team, priority_p2, component_auth, type_ui |

---

## Prerequisites

- Python 3.8+
- Chrome or Firefox browser
- Internet access to reach OrangeHRM demo environment

---

## Setup

```bash
# Clone the repository
git clone <repo-url>
cd RobotFramework-TestAutomation

# (Recommended) Create and activate a virtual environment
python -m venv venv
venv\Scripts\activate        # Windows
source venv/bin/activate     # macOS/Linux

# Install all dependencies
python -m pip install -r requirements.txt
```

### ChromeDriver Setup

Selenium 4.6+ includes Selenium Manager and can resolve browser drivers automatically in most environments.

If your environment blocks automatic driver download, install ChromeDriver/GeckoDriver manually and add it to system `PATH`.

Optional manual setup via `webdriver-manager` (included in `requirements.txt`):

```bash
python -c "from webdriver_manager.chrome import ChromeDriverManager; ChromeDriverManager().install()"
```

### Test Credentials

This suite targets the OrangeHRM demo login page:
- URL: `https://opensource-demo.orangehrmlive.com/web/index.php/auth/login`
- Username: `Admin`
- Password: `admin123`

Credentials are stored in `TestData/OrangeHRMData.robot` and can be overridden if needed.

---

## Running Tests

### Run all tests (recommended profile)
```bash
python -m robot --variablefile TestData/Environments/qa.yaml --outputdir results TestSuite
```

### Run smoke tests
```bash
python -m robot --variablefile TestData/Environments/qa.yaml --include smoke --outputdir results TestSuite
```

### Run regression tests
```bash
python -m robot --variablefile TestData/Environments/qa.yaml --include regression --outputdir results TestSuite
```

### Run a single test suite
```bash
python -m robot --variablefile TestData/Environments/qa.yaml --outputdir results TestSuite/OrangeHRMAuthTest.robot
```

### Run tests in parallel (pabot)
```bash
pabot --processes 4 --outputdir results TestSuite
```

---

## Viewing Reports

After a test run, open the HTML report:

```bash
# Windows
start results\report.html

# macOS/Linux
open results/report.html
```

![Robot Test Automation Framework Test Result](./Images/report.PNG?raw=true "Robot Test Automation Framework HTML Test Report")

---

## Linting

Run `robocop` to check for Robot Framework code style issues:

```bash
robocop
```

Configuration is in [.robocop](.robocop).

### Pre-commit quality gate

```bash
pre-commit install
pre-commit run --all-files
```

---

## CI/CD

The GitHub Actions workflow (`.github/workflows/robot-tests.yml`) automatically:
1. Runs quality-gated tests on a browser matrix (`headlesschrome`, `headlessfirefox`)
2. Uses environment profile variable files (`qa` by default, `staging` for nightly)
3. Runs smoke tests for push/PR and regression tests on nightly schedule
4. Splits nightly regression by component tags (`component_auth`, `component_navigation`)
5. Produces xUnit output for CI integrations and stores timestamped xUnit history artifacts
6. Generates metrics summary (total, pass, fail, pass rate, duration, retry/flaky signals)
7. Persists JSON trend history (`results/metrics-history.json`) and archives timestamped copies
8. Exports metrics trend CSV (`results/metrics-history.csv`) for external dashboards
9. Uploads `results/` artifacts for each browser/component run (retained 30 days)

### Branch Protection Recommended Checks

Configure these as required status checks in your repository branch protection settings:
1. `robot-tests (headlesschrome)`
2. `robot-tests (headlessfirefox)`
3. `nightly-regression-by-component (component_auth)` (for scheduled validation baseline)
4. `nightly-regression-by-component (component_navigation)` (for scheduled validation baseline)

### Tag Policy Gate

CI enforces required governance tags on every test case using `scripts/validate_test_tags.py`.
Each test case must include at least one tag matching each pattern:
1. `owner_*`
2. `priority_*`
3. `component_*`
4. `type_*`

### Metrics CSV Export

Use this locally to convert trend JSON into CSV:

```bash
python scripts/metrics_to_csv.py results/metrics-history.json results/metrics-history.csv
```

You can trigger a manual run from the **Actions** tab and choose profile and tag filter.

---

## Upgrading Dependencies

```bash
pip install --upgrade -r requirements.txt
```

