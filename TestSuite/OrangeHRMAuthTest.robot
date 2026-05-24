*** Settings ***
Test Setup        Launch Application
Test Teardown     Run Keywords    Run Keyword If Test Failed    Capture Failure Artifacts    AND    Clear SUT To Initial State
Resource          ../Keywords/LaunchApplication.robot
Resource          ../Keywords/OrangeHRMKeywords.robot

*** Test Cases ***
TC001 - Valid Login Redirects To Dashboard
    [Tags]    smoke    regression    auth    owner_ui_team    priority_p1    component_auth    type_ui
    Login With Valid Credentials
    Verify Dashboard Is Visible

TC002 - Invalid Password Shows Error Message
    [Tags]    regression    negative    auth    owner_ui_team    priority_p1    component_auth    type_ui
    Login With Invalid Credentials
    Verify Invalid Credentials Error Is Shown

TC003 - Empty Credentials Show Required Validation
    [Tags]    regression    negative    auth    owner_ui_team    priority_p1    component_auth    type_ui
    Click Login Without Credentials
    Verify Required Field Validation Is Shown

TC004 - Logged In User Can Logout Successfully
    [Tags]    regression    auth    owner_ui_team    priority_p1    component_auth    type_ui
    Login With Valid Credentials
    Verify Dashboard Is Visible
    Logout From Application
    Verify User Is Redirected To Login Page

TC005 - Logged In User Can Open PIM Module
    [Tags]    regression    navigation    owner_ui_team    priority_p2    component_navigation    type_ui
    Login With Valid Credentials
    Verify Dashboard Is Visible
    Navigate To PIM Module
    Verify PIM Page Is Visible

TC006 - Invalid Username Shows Error Message
    [Tags]    regression    negative    auth    owner_ui_team    priority_p1    component_auth    type_ui
    Login With Invalid Username
    Verify Invalid Credentials Error Is Shown

TC007 - Forgot Password Request Shows Success Message
    [Tags]    regression    auth    owner_ui_team    priority_p2    component_auth    type_ui
    Click Forgot Password Link
    Verify Reset Password Page Is Visible
    Submit Forgot Password Request
    Verify Reset Password Success Message Is Visible

TC008 - Password Field Is Masked On Login Page
    [Tags]    regression    auth    owner_ui_team    priority_p2    component_auth    type_ui
    Verify Password Field Is Masked
