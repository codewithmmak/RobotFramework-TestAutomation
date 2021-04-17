*** Settings ***
Library           Selenium2Library
Library           OperatingSystem
Library           Collections
Library           DateTime
Library           String
Resource          ../Objects/Locators/CreateAnAccountLocators.robot

*** Keywords ***
Click SignIn button
    Wait Until Element Is Visible    ${SignInButton}
    Click Element    ${SignInButton}

Enter Email Address
    Wait Until Element Is Visible    ${EmailAddress}
    ${RandomData}=    Generate Random String    15    [NUMBERS]
    Input Text    ${EmailAddress}    test${RandomData}@gmail.com

Click Create An Account button
    Click Element    ${CreateAnAccountButton}

Enter Your Personal Information
    Wait Until Page Contains Element    ${Title}
    Click Element    ${Title}
    Wait Until Page Contains Element    ${FirstName} 
    Input Text    ${FirstName}    ${FirstNameData}
    Input Text    ${LastName}    ${LastNameData}
    Input Text    ${Password}    ${PasswordData}
    Click Element    ${NewsLetterSignup}
    Click Element    ${SpecialOffer}

Enter Your Address
    Input Text    ${FirstName}    ${FirstNameData}
    Input Text    ${LastName}    ${LastNameData}
    Input Text    ${Company}    ${CompanyData}
    Input Text    ${Address}    ${AddressData}
    Input Text    ${Address2}    ${Address2Data}
    Input Text    ${City}    ${CityData}
    Input Text    ${ZipCode}    ${ZipCodeData}
    Input Text    ${AdditionalInformation}    ${AdditionalInformationData}
    Input Text    ${HomePhone}    ${HomePhoneData}
    Input Text    ${HomePhone}    ${HomePhoneData}
    Input Text    ${MobilePhone}    ${MobilePhoneData}
    Input Text    ${AssignAnAddressAlias}    ${AssignAnAddressAliasData}

Click Register button
    Click Element    ${Register}
