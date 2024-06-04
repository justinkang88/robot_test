*** Settings ***
Documentation     Example using the space separated format.
Library           OperatingSystem
Library           SeleniumLibrary
Library           DatabaseLibrary
Library           Collections
Library    String
Library    DateTime
Library    XML
Library    AppiumLibrary




*** Test Cases ***

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




영수증 제출 - 일반 사용자 (모바일)
    AppiumLibrary.Open Application    remote_url=http://localhost:4723/wd/hub    platformName=Android    platformVersion=13.0.0   app=${CURDIR}/prd.apk
    Sleep    time_=10
    AppiumLibrary.Input Text        id=com.gowid.expense:id/edit_email	    text=auto_normal1@ruu.kr
    AppiumLibrary.Click Element     id= com.gowid.expense:id/btn_cta
    AppiumLibrary.Input Text        id=com.gowid.expense:id/edit_pw    	    text=gowid26181!
    AppiumLibrary.Click Element        com.gowid.expense:id/btn_cta    	
    
*** Keywords ***
My Keyword
    [Arguments]    ${path}
    Directory Should Exist    ${path}



