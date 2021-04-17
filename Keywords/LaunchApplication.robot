*** Settings ***
Resource          ../TestData/TestConfig.robot

*** Keywords ***
Launch Application
    Open Browser    ${AppURL}    ${Browser}
    Set Selenium Speed    1
    Maximize Browser Window

Clear SUT To Initial State
    Close Browser
