Library    SeleniumLibrary

 Variables 
${URL}                http://localhost:5173/register
${NAME}               zaza
${EMAIL}              zaza@gmail.com
${PASSWORD}           1234
${IMAGE_PATH}         C:/Temp/test101.jpg
${NAME_FIELD}         id=:r9:
${EMAIL_FIELD}        id=:rb:
${PHONE_FIELD}        id=:rd:
${PASSWORD_FIELD}     id=:rf:
${SUBMIT_BUTTON}      xpath=//button[.='สมัครสมาชิก']
${EMAIL_ERROR_XPATH}  xpath=//span[@class='error-message']   # แก้ตามจริงบนเว็บของคุณ

 Test Cases 
สมัครสมาชิกพร้อมรูป
    Open Browser    ${URL}    chrome
    Maximize Browser Window
    Wait Until Element Is Visible    ${NAME_FIELD}    5s
    Input Text    ${NAME_FIELD}      ${NAME}
    Input Text    ${EMAIL_FIELD}     ${EMAIL}
    Input Text    ${PASSWORD_FIELD}  ${PASSWORD}
    Click Button  ${SUBMIT_BUTTON}
    Close Browser

สมัครสมาชิกพร้อมรูป-EmailผิดFormat
    Open Browser    ${URL}    chrome
    Maximize Browser Window
    Wait Until Element Is Visible    ${NAME_FIELD}    5s
    Input Text    ${NAME_FIELD}      ${NAME}
    Input Text    ${EMAIL_FIELD}     test1@example.com
    Input Text    ${PASSWORD_FIELD}  ${PASSWORD}
    Click Button  ${SUBMIT_BUTTON}
    Sleep 2s
    Element Should Contain    ${EMAIL_ERROR_XPATH}    อีเมลไม่ถูกต้อง
    Close Browser