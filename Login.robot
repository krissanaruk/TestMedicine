*** Settings ***
Library    SeleniumLibrary    run_on_failure=Capture Page Screenshot
Suite Setup    Set Screenshot Directory    ${OUTPUT DIR}${/}screenshots

*** Variables ***
${BROWSER}          chrome
${LOGIN_URL}        http://localhost:5173/login
${HOME_URL}         http://localhost:5173/patient/home
${register_URL}         http://localhost:5173/register
${Forget_URL}         http://localhost:5173/forget
${EMAIL_INPUT}          xpath=//form//label[contains(normalize-space(),'Email')]/following::input[1]
${PASSWORD_INPUT}       xpath=//form//input[@type='password'][1]
${LOGIN_BUTTON}         xpath=//form//button[@type='submit' and (contains(normalize-space(.),'เข้าสู่ระบบ') or contains(normalize-space(.),'Login') or contains(normalize-space(.),'Sign in'))]
${REGISTER_LINK}        xpath=//a[contains(@href,'register') or contains(normalize-space(.),'สมัครสมาชิก')]
${FORGOT_LINK}         xpath=//form//a[contains(@href,'forgot') or contains(@href,'forget') or contains(normalize-space(.),'ลืมรหัสผ่าน')]
${PHONE}                xpath=//form//label[contains(normalize-space(),'เบอร์โทร')]/following::input[1]
${WARNING_FAIL}         xpath=//form//button[@type='submit']/preceding::div[contains(@class,'MuiBox-root')][normalize-space()][1]
${PASSWORD_FIELD_ANY}   xpath=//form//label[contains(normalize-space(),'Password')]/following::input[1]
${PW_TOGGLE_BTN}        xpath=//*[@data-testid='VisibilityOffIcon' or @data-testid='VisibilityIcon']/ancestor::button[1]
${PW_ICON_SHOW}         xpath=//*[@data-testid='VisibilityIcon']       
${PW_ICON_HIDE}         xpath=//*[@data-testid='VisibilityOffIcon']    

# Test data
${VALID_EMAIL}          ksnr2412@gmail.com
${VALID_PASSWORD}       1234
${INVALID_EMAIL}        1234
${INVALID_PASSWORD}     1234
${NO_EMAIL_DB}          test@gmail.com
${NO_PASSWORD_DB}       1234
${NULL_EMAIL}
${NULL_PASSWORD}

*** Test Cases ***

Login Success เข้าสู่ระบบด้วยอีเมลและรหัสที่ถูกต้อง
    Open Browser    ${LOGIN_URL}    ${BROWSER}
    Set Window Size    1366    768
    Wait Until Element Is Visible    ${EMAIL_INPUT}    10s
    Input Text    ${EMAIL_INPUT}      ${VALID_EMAIL}
    Input Text    ${PASSWORD_INPUT}   ${VALID_PASSWORD}
    Click Element    ${LOGIN_BUTTON}
    Wait Until Location Contains    /patient/home    10s
    Close Browser

Login Fails การเข้าสู่ระบบด้วยอีเมลที่ผิดฟอร์แมต
    Open Browser    ${LOGIN_URL}    ${BROWSER}
    Set Window Size    1366    768
    Wait Until Element Is Visible    ${EMAIL_INPUT}    10s
    Input Text    ${EMAIL_INPUT}      ${INVALID_EMAIL}
    Input Text    ${PASSWORD_INPUT}   ${INVALID_PASSWORD}
    Click Element    ${LOGIN_BUTTON}
    Wait For Inline Warning Box    15s
    Wait Until Element Is Visible    ${LOGIN_BUTTON}   10s
    Close Browser

Login Fails การเข้าสู่ระบบด้วยอีเมลที่ไม่ได้ลงทะเบียน
    Open Browser    ${LOGIN_URL}    ${BROWSER}
    Set Window Size    1366    768
    Wait Until Element Is Visible    ${EMAIL_INPUT}    10s
    Input Text    ${EMAIL_INPUT}      ${NO_EMAIL_DB}
    Input Text    ${PASSWORD_INPUT}   ${NO_PASSWORD_DB}
    Click Element    ${LOGIN_BUTTON}
    Wait For Inline Warning Box    15s
    Wait Until Element Is Visible    ${LOGIN_BUTTON}   10s
    Close Browser

Login Fails การเข้าสู่ระบบโดยไม่กรอกอีเมลเเละรหัสผ่าน
    Open Browser    ${LOGIN_URL}    ${BROWSER}
    Set Window Size    1366    768
    Wait Until Element Is Visible    ${EMAIL_INPUT}    10s
    Input Text    ${EMAIL_INPUT}      ${NULL_EMAIL}
    Input Text    ${PASSWORD_INPUT}   ${NULL_PASSWORD}
    Click Element    ${LOGIN_BUTTON}
    Expect Browser Validation Blocks Submit    10s
    Wait Until Element Is Visible   ${LOGIN_BUTTON}   10s
    Close Browser



Login Success การทำงานปุ่มสมัครสมาชิก
    Open Browser    ${LOGIN_URL}    ${BROWSER}
    Set Window Size    1366    768
    Wait Until Element Is Visible    ${EMAIL_INPUT}    10s
    Click Element    ${REGISTER_LINK}
    Wait Until Location Contains    ${register_URL}   10s
    Close Browser

Login Success การทำงานปุ่มลืมรหัสผ่าน
    Open Browser    ${LOGIN_URL}    ${BROWSER}
    Set Window Size    1366    768
    Wait Until Element Is Visible    ${EMAIL_INPUT}    10s
    Click Element    ${FORGOT_LINK} 
    Wait Until Location Contains    ${Forget_URL}   10s
    Close Browser

Password Toggle — Show/Hide
    Open Browser    ${LOGIN_URL}    ${BROWSER}
    Set Window Size    1366    768
    Wait Until Element Is Visible    ${EMAIL_INPUT}    10s
    Input Text    ${EMAIL_INPUT}        ${VALID_EMAIL}
    Input Text    ${PASSWORD_INPUT}     23131

    # ถ้าเริ่มเป็น text ให้กดให้ซ่อนก่อน เพื่อเซ็ต baseline
    ${t}=    Get Element Attribute    ${PASSWORD_FIELD_ANY}    type
    Run Keyword If    '${t}'=='text'    Click Element    ${PW_TOGGLE_BTN}
    Wait Until Keyword Succeeds    5s    0.2s    Input Type Should Be    ${PASSWORD_FIELD_ANY}    password
    Run Keyword And Ignore Error   Wait Until Page Contains Element    ${PW_ICON_HIDE}    3s

    # แสดง
    Click Element    ${PW_TOGGLE_BTN}
    Wait Until Keyword Succeeds    5s    0.2s    Input Type Should Be    ${PASSWORD_FIELD_ANY}    text
    Run Keyword And Ignore Error   Wait Until Page Contains Element    ${PW_ICON_SHOW}    3s

    # ซ่อนกลับ
    Click Element    ${PW_TOGGLE_BTN}
    Wait Until Keyword Succeeds    5s    0.2s    Input Type Should Be    ${PASSWORD_FIELD_ANY}    password

    Close Browser

*** Keywords ***
Wait For Inline Warning Box
    [Arguments]    ${timeout}=10s
    Wait Until Keyword Succeeds    ${timeout}    1s    Page Should Contain Element    ${WARNING_FAIL}
    Wait Until Element Is Visible   ${WARNING_FAIL}    2s

Input Type Should Be
    [Arguments]    ${locator}    ${expected}
    ${t}=    Get Element Attribute    ${locator}    type
    Should Be Equal As Strings       ${t}          ${expected}

Wait For Warning Or Field Invalid
    [Arguments]    ${timeout}=10s
    # พยายามหากล่องเตือนก่อน
    ${hasBox}=    Run Keyword And Return Status    Wait For Inline Warning Box    ${timeout}
    IF    not ${hasBox}
        # ถ้าไม่มีกล่อง ให้ตรวจ field state แทน
        ${eInv}=    Run Keyword And Return Status    Element Attribute Should Be    ${EMAIL_INPUT}       aria-invalid    true
        ${pInv}=    Run Keyword And Return Status    Element Attribute Should Be    ${PASSWORD_INPUT}    aria-invalid    true
        Run Keyword If    not ${eInv} and not ${pInv}    Fail    No inline warning and fields not marked invalid.
    END

Expect Browser Validation Blocks Submit
    [Arguments]    ${timeout}=10s
    # รอให้เบราว์เซอร์ mark ฟิลด์เป็น :invalid (HTML5 required/format)
    Wait Until Keyword Succeeds    ${timeout}    0.5s    _assert invalid field exists

_assert invalid field exists
    ${invalid_count}=    Execute Javascript    return document.querySelectorAll('form :invalid').length;
    Should Not Be Equal As Integers    ${invalid_count}    0
    ${first_msg}=    Execute Javascript    var el=document.querySelector('form :invalid'); return el ? el.validationMessage : '';
    Log    Browser validation message: ${first_msg}