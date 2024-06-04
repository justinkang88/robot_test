*** Settings ***
Documentation     Example using the space separated format.
Library           OperatingSystem
Library           SeleniumLibrary
Library           DatabaseLibrary
Library           Collections
Library    String
Library    DateTime
Library    XML



*** Variables ***
${MESSAGE}        Hello, world!


*** Test Cases ***
My Test
    [Documentation]    Example test.
    Log    ${MESSAGE}
    My Keyword    ${CURDIR}

Another Test
    Should Be Equal    ${MESSAGE}    Hello, world!

승인내역 생성
    Connect To Database    dbapiModuleName=pymysql    dbName=gowid    dbUsername=justinkang    dbPassword=qwe123!@#    dbHost=34.64.33.60    dbCharset=utf8    dbPort=3306
    ${cardid}    Query    select card_id from expense.card where card_number = '510554******1914' and corp_id = '1074'
    ${userid}    Query    select card_user_id from expense.card where card_number = '510554******1914' and corp_id = '1074'
    ${aprvhid}    Query    select approval_hist_id from expense.expense order by expense_id desc limit 1
    ${expenseid}    Query    select expense_id from expense.expense order by expense_id desc limit 1
    ${iaprvhid}    Evaluate        ${aprvhid}[0][0] + 1
    ${iexpenseid}    Evaluate      ${expenseid}[0][0] + 1
    ${icardid}    Set Variable    ${cardid}[0][0]
    ${iuserid}    Set Variable    ${userid}[0][0]
    ${storerandnumb}    Generate Random String    length=4    chars=0123456789
    ${storename}    Set Variable    또순이백순대${storerandnumb}
    ${date}        Get Current Date    result_format=%Y%m%d

    # 변수정의
    ${iaprvid}    Generate Random String    length=9    chars=0123456789
        
    ${sqlquery}      Set Variable    INSERT INTO expense.expense(expense_id,created_at,updated_at,approval_hist_id,approval_status,card_approval_number,card_number,company_code,currency,expense_date,expense_time,krw_amount,store_address,store_name,use_amount,card_id,corp_id,user_id,vat,card_approval_date,card_approval_time,is_notified,expense_type,origin_type,is_hide,is_deleted) VALUES ('${iexpenseid}',now(),now(),'${iaprvhid}','NOT_SUBMITTED','${iaprvid}',5105545000831914,'0311','KRW','${date}','162025',10000,'경기 안양시 동안구 관평로170번길 43 101호','${storename}',10000,${icardid},1074,${iuserid},'0','${date}','162025',1,1,'CMS',0,0)
    Log    ${sqlquery}
    Log    ${storename}

    Execute Sql String    ${sqlquery}



    #Execute Sql String    INSERT INTO expense.expense(expense_id,created_at,updated_at,approval_hist_id,approval_status,card_approval_number,card_number,company_code,currency,expense_date,expense_time,krw_amount,store_address,store_name,use_amount,card_id,corp_id,user_id,vat,card_approval_date,card_approval_time,is_notified,expense_type,origin_type,is_hide,is_deleted) VALUES ('${expeenseid}',now(),now(),'1994782','NOT_SUBMITTED','${aprvid}',5105545000831914,'0311','KRW','20240205','162025',10000,'경기 안양시 동안구 관평로170번길 43 101호','kdgjslkdfjg',10000,5791,1074,9293,'0','20240205','162025',1,1,'CMS',0,0)  ;



영수증 제출 - 일반 사용자
    Open Browser     https://stg-expense.gowid.com/login    Chrome    executable_path=/Users/gowid/Desktop/cucuumber/chromedriver
    Input Text       id=loginCardEmailInputField    text=tdg-normal1@gowid.com
    Input Text       id=loginCardPasswordInputField    text=gowid26181!
    Click Element    id=login_submit    
    Sleep        time_=3
    Click Element    xpath=/html/body/div[1]/section/aside/div[3]/button[1]
    Click Element    id=expenseSubmitReceiptApprovalSummaryCardBasicSelectBox
    Input Text        id=expenseSubmitReceiptApprovalSummaryCardBasicSelectBox     text=1914
    Click Element    xpath=/html/body/div[1]/section/div/div[1]/div/div[2]/div[1]/div[1]/div[3]/div[1]/div/div[2]/div/ul/li/div/p
    Sleep    time_=3
    Click Element    xpath=/html/body/div[1]/section/div/div[1]/div/div[2]/div[6]/table/tbody/tr[1]
    Sleep    time_=3
    Click Element    id=expenseDetailToggleEditButton
    
    Click Element    id=expenseDetailNewPurposeBasicSelectBox
    Input Text        id=expenseDetailNewPurposeBasicSelectBox     text=auto_사용안함
    Click Element    xpath=/html/body/div[2]/div/div/div/div[2]/div[2]/div/div[2]/div[1]/div/div/div[2]/div/ul/li/div
    Click Element    id=expenseDetailSaveButton
    Sleep    time_=3
    Click Element    xpath=/html/body/div[2]/div/div/div/div[1]/button[3]
    Close Browser


    

영수증 처리 - 관리자
    Open Browser     https://stg-expense.gowid.com/login    Chrome    executable_path=/Users/gowid/Desktop/cucuumber/chromedriver
    Input Text       id=loginCardEmailInputField    text=tdg@gowid.com
    Input Text       id=loginCardPasswordInputField    text=gowid26181!
    Click Element    id=login_submit    
    Sleep        time_=3
 
    Click Element     xpath=/html/body/div[1]/section/aside/div[5]/button[2]/div

    Reload Page    
    Sleep    time_=3
    Click Element     xpath=/html/body/div[1]/section/div/div[1]/div/div[2]/div[1]/div[1]/div[3]/div[1]/div/button
    Input Text        id=expenseManagementApprovalSummaryCardBasicSelectBox    text=1914
    Click Element    xpath=/html/body/div[1]/section/div/div[1]/div/div[2]/div[1]/div[1]/div[3]/div[1]/div/div[2]/div/ul/li/div/p
    Sleep    time_=3
    Click Element    xpath=/html/body/div[1]/section/div/div[1]/div/div[2]/div[6]/table/tbody/tr[1]
    Sleep    time_=3
    Click Element    id=approvalSelectApproveFromApprovedButton
    Click Button    id=approvalSelectApproveSaveButton
    Click Button    xpath=/html/body/div[2]/div/div/div/div[1]/button[3]
    Close Browser

영수증 처리 상태 확인 - 일반 사용자 
    Open Browser     https://stg-expense.gowid.com/login    Chrome    executable_path=/Users/gowid/Desktop/cucuumber/chromedriver
    Input Text       id=loginCardEmailInputField    text=tdg-normal1@gowid.com
    Input Text       id=loginCardPasswordInputField    text=gowid26181!
    Click Element    id=login_submit    
    Sleep    time_=3
    Click Element    id=expenseSubmitReceiptApprovalSummaryCardBasicSelectBox
    Input Text        id=expenseSubmitReceiptApprovalSummaryCardBasicSelectBox     text=1914
    Click Element    xpath=/html/body/div[1]/section/div/div[1]/div/div[2]/div[1]/div[1]/div[3]/div[1]/div/div[2]/div/ul/li/div/p
    Sleep    time_=3
    Click Element    xpath=/html/body/div[1]/section/div/div[1]/div/div[2]/div[6]/table/tbody/tr[1]
    Sleep    time_=3
    ${status_result}       Get Text        id=approvalStatusButton
    Should Be True        '${status_result}' == '승인'

    Close All Browsers

*** Keywords ***
My Keyword
    [Arguments]    ${path}
    Directory Should Exist    ${path}


Justin
    [Arguments]    ${aaa}
    Log    ${aaa}
    Log    ${aaa}
    Log    ${aaa}
    Log    ${aaa}

