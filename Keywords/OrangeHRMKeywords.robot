*** Settings ***
Library           SeleniumLibrary
Resource          ../Objects/Locators/OrangeHRMLocators.robot
Resource          ../TestData/OrangeHRMData.robot
Resource          ../TestData/TestConfig.robot
Resource          ./LaunchApplication.robot

*** Keywords ***
Login With Credentials
    [Arguments]    ${username}    ${password}
    ${user_field}=    Resolve First Available Locator    ${UsernameInput}    ${UsernameInputCss}
    ${pass_field}=    Resolve First Available Locator    ${PasswordInput}    ${PasswordInputCss}
    Clear Element Text With Retry    ${user_field}
    Input Text With Retry    ${user_field}    ${username}
    Clear Element Text With Retry    ${pass_field}
    Input Text With Retry    ${pass_field}    ${password}
    Click First Available Locator    ${LoginButton}    ${LoginButtonCss}

Login With Valid Credentials
    Login With Credentials    ${ValidUsername}    ${ValidPassword}

Login With Invalid Credentials
    Login With Credentials    ${InvalidUsername}    ${InvalidPassword}

Login With Invalid Username
    Login With Credentials    ${InvalidOnlyUsername}    ${ValidPassword}

Click Login Without Credentials
    Click First Available Locator    ${LoginButton}    ${LoginButtonCss}

Verify Password Field Is Masked
    ${password_locator}=    Resolve First Available Locator    ${PasswordInput}    ${PasswordInputCss}
    ${field_type}=    Get Element Attribute    ${password_locator}    type
    Should Be Equal    ${field_type}    password

Click Forgot Password Link
    Click Element With Retry    ${ForgotPasswordLink}

Verify Reset Password Page Is Visible
    Wait Until Element Is Visible    ${ResetPasswordHeader}    timeout=${EXPLICIT_TIMEOUT}
    Page Should Contain Element    ${ResetPasswordHeader}

Submit Forgot Password Request
    ${user_field}=    Resolve First Available Locator    ${UsernameInput}    ${UsernameInputCss}
    Clear Element Text With Retry    ${user_field}
    Input Text With Retry    ${user_field}    ${ValidUsername}
    Click Element With Retry    ${ResetPasswordButton}

Verify Reset Password Success Message Is Visible
    ${has_504}=    Run Keyword And Return Status    Page Should Contain    504 Gateway Time-out
    ${has_503}=    Run Keyword And Return Status    Page Should Contain    503 Service Temporarily Unavailable
    ${has_502}=    Run Keyword And Return Status    Page Should Contain    502 Bad Gateway
    Run Keyword If    ${has_504} or ${has_503} or ${has_502}    Fail    OrangeHRM demo site became unavailable while submitting forgot password request.
    Wait Until Page Contains    Reset Password link sent successfully    timeout=${EXPLICIT_TIMEOUT}
    Page Should Contain Element    ${ResetPasswordSuccessMessage}

Verify Dashboard Is Visible
    Wait Until Element Is Visible    ${DashboardHeader}    timeout=${EXPLICIT_TIMEOUT}
    Page Should Contain Element    ${DashboardHeader}

Verify Invalid Credentials Error Is Shown
    Wait Until Element Is Visible    ${InvalidCredentialsError}    timeout=${EXPLICIT_TIMEOUT}
    Page Should Contain Element    ${InvalidCredentialsError}

Verify Required Field Validation Is Shown
    Wait Until Element Is Visible    ${RequiredFieldValidation}    timeout=${EXPLICIT_TIMEOUT}
    Page Should Contain Element    ${RequiredFieldValidation}

Logout From Application
    Click Element With Retry    ${ProfileMenu}
    Click Element With Retry    ${LogoutLink}

Verify User Is Redirected To Login Page
    Wait Until Element Is Visible    ${LoginPageHeader}    timeout=${EXPLICIT_TIMEOUT}
    Location Should Contain    /auth/login

Navigate To PIM Module
    Go To    ${PIMModuleURL}

Verify PIM Page Is Visible
    Wait Until Element Is Visible    ${PimHeader}    timeout=${EXPLICIT_TIMEOUT}
    Page Should Contain Element    ${PimHeader}
