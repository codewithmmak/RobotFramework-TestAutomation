*** Settings ***
Suite Setup
Suite Teardown
Library           Selenium2Library
Library           OperatingSystem
Library           Collections
Library           DateTime
Library           String
Resource          ../Keywords/LaunchApplication.robot
Resource          ../Keywords/SearchKeywords.robot
Resource          ../Keywords/CreateAnAccountKeywords.robot
Resource          ../Objects/Locators/SearchLocators.robot
Resource          ../Objects/Locators/CreateAnAccountLocators.robot
Resource          ../TestData/TestConfig.robot
Resource          ../TestData/TestData.robot

*** Test Cases ***
SearchTest
    Launch Application
    Search a Keyword
    Verify Search Result Page is shown
    [Teardown]    Clear SUT To Initial State

CreateAnAccountTest
    Launch Application
    Click SignIn button
    Enter Email Address
    Click Create An Account button
    Enter Your Personal Information
    Enter Your Address
    Click Register button
    [Teardown]    Clear SUT To Initial State
