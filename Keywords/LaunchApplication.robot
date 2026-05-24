*** Settings ***
Library           SeleniumLibrary
Library           OperatingSystem
Resource          ../TestData/TestConfig.robot

*** Keywords ***
Launch Application
    Open Browser    ${AppURL}    ${Browser}
    Set Selenium Implicit Wait    ${IMPLICIT_TIMEOUT}
    Set Selenium Timeout    ${EXPLICIT_TIMEOUT}
    Maximize Browser Window
    Register Keyword To Run On Failure    Capture Failure Artifacts
    Ensure Application Is Available

Ensure Application Is Available
    ${has_504}=    Run Keyword And Return Status    Page Should Contain    504 Gateway Time-out
    ${has_503}=    Run Keyword And Return Status    Page Should Contain    503 Service Temporarily Unavailable
    ${has_502}=    Run Keyword And Return Status    Page Should Contain    502 Bad Gateway
    Run Keyword If    ${has_504} or ${has_503} or ${has_502}    Fail    OrangeHRM demo site is temporarily unavailable (gateway/service error). Re-run when service is healthy.

Run Transient Keyword
    [Arguments]    ${keyword}    @{args}
    ${attempts}=    Convert To Integer    ${RETRY_COUNT}
    FOR    ${index}    IN RANGE    ${attempts}
        ${attempt}=    Evaluate    ${index} + 1
        ${status}=    Run Keyword And Return Status    Run Keyword    ${keyword}    @{args}
        IF    ${status}
            Run Keyword If    ${attempt} > 1    Record Retry Usage    ${keyword}    ${attempt}
            RETURN
        END
        Sleep    ${RETRY_INTERVAL}
    END
    Record Retry Usage    ${keyword}    ${attempts}
    Fail    Keyword '${keyword}' failed after ${attempts} attempts

Record Retry Usage
    [Arguments]    ${keyword}    ${attempt}
    Create Directory    results
    ${line}=    Catenate    SEPARATOR=,    ${TEST NAME}    ${keyword}    ${attempt}
    Append To File    results${/}retry_audit.csv    ${line}\n

Click Element With Retry
    [Arguments]    ${locator}
    Run Transient Keyword    Click Element    ${locator}

Click First Available Locator
    [Arguments]    @{locators}
    ${resolved}=    Resolve First Available Locator    @{locators}
    Click Element With Retry    ${resolved}

Input Text With Retry
    [Arguments]    ${locator}    ${value}
    Run Transient Keyword    Input Text    ${locator}    ${value}

Input Text First Available Locator
    [Arguments]    ${value}    @{locators}
    ${resolved}=    Resolve First Available Locator    @{locators}
    Input Text With Retry    ${resolved}    ${value}

Clear Element Text With Retry
    [Arguments]    ${locator}
    Run Transient Keyword    Clear Element Text    ${locator}

Resolve First Available Locator
    [Arguments]    @{locators}
    FOR    ${locator}    IN    @{locators}
        ${is_visible}=    Run Keyword And Return Status    Wait Until Element Is Visible    ${locator}    timeout=5s
        IF    ${is_visible}
            RETURN    ${locator}
        END
    END
    Fail    None of the candidate locators are available: @{locators}

Capture Failure Artifacts
    Create Directory    results
    Run Keyword And Ignore Error    Capture Page Screenshot
    ${status}    ${source}=    Run Keyword And Ignore Error    Get Source
    Run Keyword If    '${status}' == 'PASS'    Create File    results${/}page_source_${TEST NAME}.html    ${source}
    ${url_status}    ${url}=    Run Keyword And Ignore Error    Get Location
    ${title_status}    ${title}=    Run Keyword And Ignore Error    Get Title
    ${context}=    Catenate    SEPARATOR=\n    test=${TEST NAME}    status=${PREV_TEST_STATUS}    url=${url}    title=${title}
    Create File    results${/}failure_context_${TEST NAME}.txt    ${context}

Clear SUT To Initial State
    Close All Browsers
