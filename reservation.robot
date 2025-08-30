*** Settings ***
Library    SeleniumLibrary    run_on_failure=Capture Page Screenshot

*** Variables ***
${BROWSER}              chrome
${HOME_URL}             http://localhost:5173/patient/home
${branch}                xpath=//*[@id="root"]/div/main/div/div/div[1]/div[2]/div/div[2]/span[1]
${branch_btn}            xpath=//button[normalize-space()='รายละเอียด']/following-sibling::button[normalize-space()='จอง']
${reserve_btn_today}      xpath=//button[@type='button' and normalize-space()='จองวันนี้']
${reserve_btn_summit}     xpath=//div[@role='dialog']//button[normalize-space()='ยืนยันการจอง']



*** Test Cases ***
success เลือกสาขาเเละเเพทย์ที่จะจอง    
    Open Browser        ${HOME_URL}     ${BROWSER}
    Maximize Browser Window
    Wait Until Element Is Visible           ${branch}               10s
    Click Element                           ${branch} 
    Wait Until Element Is Visible           ${branch_btn}           10s
    Click Element                          ${branch_btn}
    Close Browser

success เจองคิวสำเร็จ   
    Open Browser        ${HOME_URL}     ${BROWSER}
    Maximize Browser Window
    Wait Until Element Is Visible           ${branch}               10s
    Click Element                           ${branch} 
    Wait Until Element Is Visible           ${branch_btn}           10s
    Click Element                          ${branch_btn}
    Close Browser 
    Wait Until Element Is Visible           ${reserve_btn_today}     10s
    Click Element                           ${reserve_btn_today}
    Wait Until Element Is Visible           ${reserve_btn_summit}     10s
    Click Element                           ${reserve_btn_summit}      
    Close Browser



