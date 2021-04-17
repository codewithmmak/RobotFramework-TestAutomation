![Robot Test Automation Framework](./Images/robot-framework.png?raw=true "Robot Test Automation Framework")

# Robot Test Automation Framework Examples
This is sample Test Automation framework is designed using Robot Framework. And in this framework we will see some basic working examples for learning.

## Features
* This automation framework is designed using Robot Framework.
* Python is used as scripting language.
* Reporting is implemented using `Robot Framework` in-built module. This generates the report in html and it captures the screenshots.

## To Get Started

### Pre-requisites
* Download and install Chrome or Firefox browser.
* Download and install Python
* Download and install any Text Editor like Visual Code/Sublime/Brackets

### Setup Robot Framework 
* Clone the repository into a folder
* Go to Project root directory and install dependencies by running: `pip install -r requirements.txt`
* All the dependencies from requirements.txt would be installed.
* 
* Now you have to set the path of ChromeDriver. 
    Download the ChromeDriver from `https://chromedriver.chromium.org/`
    Unzip and save it in any location, but preferably in root directory of the framework.
    Add Environment Varable to System Variable path, in my case its `D:\MyWorkSpace\Drivers`

### How to run Robot Test Suite
1. From CLI, go to the directory where you have saved your test case file.
2. Then execute the following command `python -m robot TestSuite`

### How to run single Robot Script
1. From CLI, go to the directory where you have saved your test case file.
2. Then execute the following command `python -m robot TestSuite/CreateAnAccountTest.robot`

### How to open RIDE
1. Open Command Prompt
2. Go to you Project Path
3. Type: `ride.py`
4. Hit Enter key

### How to view HTML Report
* Go to root directory of your project and open `report.html`

![Robot Test Automation Framework Test Result](./Images/report.PNG?raw=true "Robot Test Automation Framework HTML Test Report")

### How to upgrade to latest packages version
* Open Terminal and run command `pip install --upgrade -r requirements.txt`
