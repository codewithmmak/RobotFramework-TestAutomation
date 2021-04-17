*** Settings ***
Suite Setup
Suite Teardown
Resource          ../Keywords/LaunchApplication.robot
Resource          ../Keywords/CreateAnAccountKeywords.robot

*** Settings ***
Test Teardown    Clear SUT To Initial State

*** Test Cases ***
CreateAnAccountTest
    Launch Application
    Click SignIn button
    Enter Email Address
    Click Create An Account button
    Enter Your Personal Information
    Enter Your Address
    Click Register button
    # [Teardown]    Clear SUT To Initial State
