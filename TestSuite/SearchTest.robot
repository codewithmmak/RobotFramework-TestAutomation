*** Settings ***
Suite Setup
Suite Teardown
Resource          ../Keywords/LaunchApplication.robot
Resource          ../Keywords/SearchKeywords.robot

*** Settings ***
Test Teardown    Clear SUT To Initial State

*** Test Cases ***
SearchTest
    Launch Application
    Search a Keyword
    Verify Search Result Page is shown
    # [Teardown]    Clear SUT To Initial State
