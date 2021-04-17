*** Settings ***
Library           Selenium2Library
Library           OperatingSystem
Library           Collections
Library           DateTime
Library           String
Resource          ../Objects/Locators/SearchLocators.robot

*** Keywords ***
Search a Keyword
    Wait Until Element Is Visible    ${SearchQuery}
    Input Text    ${SearchQuery}    ${SearchKeyword}
    Click Element    ${SearchSubmitButton}

Verify Search Result Page is shown
    Wait Until Element Is Visible    ${SearchResultKeyword}
    Page Should Contain Element    ${SearchResultKeyword}
