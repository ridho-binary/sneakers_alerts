*** Settings ***
Library          Collections
Library	         OperatingSystem
Library          SeleniumLibrary
Library          String
Library          RPA.Email.ImapSmtp    smtp_server=smtp.gmail.com    smtp_port=587
Resource         common/resource.robot
Resource         common/navigation.robot
Test Teardown    Close Browser

*** Variables ***

${USERNAME}             %{email_username}
${PASSWORD}             %{email_password}
${RECIPIENT}            %{email_recipient}
@{EXPECTED_LIST_NIKE}=       Sky Jordan 1\nYounger Kids' Shoe
...                     Sky Jordan 1\nBaby and Toddler Shoe
...                     Jordan 1 Low\nBaby &amp; Toddler Shoe
...                     Jordan 1 Low\nYounger Kids' Shoe
...                     Jordan 1 Low Alt\nBaby and Toddler Shoe

@{EXPECTED_LIST_FL}=    Jordan 1 Low Alt - Pre School Shoes
...                     Jordan 1 Mid - Men Shoes
...                     Jordan 1 Mid - Men Shoes
...                     Jordan 1 Mid Alt - Pre School Shoes
...                     Jordan 1 Low - Baby Shoes
...                     Jordan 1 Low Se - Men Shoes
...                     Jordan 1 Low Alt - Baby Shoes
...                     Jordan Zion 1 Pf - Men Shoes
...                     Jordan 1 Low Alt - Pre School Shoes
...                     Jordan 1 Low - Baby Shoes
...                     Jordan 1 Mid - Women Shoes
...                     Jordan 1 Low Alternate Closure/Velcro - Pre School Shoes
...                     Jordan Air 1 Mid - Pre School Shoes
...                     Jordan 1 Mid Alt - Pre School Shoes
...                     Jordan 1 Mid Alt - Pre School Shoes
...                     Jordan Sky 1 - Pre School Shoes
...                     Jordan 1 Low - Men Shoes
...                     Jordan 1 Low - Men Shoes
...                     Jordan 1 Retro High Og Co.Jp - Men Shoes
...                     Jordan Sky 1 - Pre School Shoes
...                     Jordan 1 Mid - Pre School Shoes
...                     Jordan 1 Mid - Men Shoes

*** Keywords ***
Send email alert Nike
    Authorize       account=${USERNAME}    password=${PASSWORD}
    Send Message    sender=${USERNAME}
    ...    recipients=${RECIPIENT}
    ...    subject=New release Alerts in Nike !!!
    ...    body=This is the new entry ${NEW_LIST2} in Nike
    ...    attachments=/tmp/test-reports/my-jordan-list_1.png

Send email alert Footlocker
    Authorize       account=${USERNAME}    password=${PASSWORD}
    Send Message    sender=${USERNAME}
    ...    recipients=${RECIPIENT}
    ...    subject=New release Alerts in Footlocker !!!
    ...    body=This is the new entry ${NEW_AJ_LIST} in footlocker
    ...    attachments=/tmp/test-reports/my-jordan-list_fl_1.png


Check current available shoes in Nike

    Wait until Element is visible       //*[@class="product-card__body"]        60
    Execute javascript          document.body.style.zoom="33%"
    Capture Page Screenshot     my-jordan-list_1.png
    ${TOTAL_CURRENT}    get element count   //*[@class="product-card__body"]
    run keyword if     ${TOTAL_CURRENT}!=10       Get latest release in Nike


Get latest release in Nike


    ${NEW}      get element count      //*[@id="Wall"]/div/div[5]/div[2]/main/section/div/div[*]

    ${NEW_LIST1}=    Create List
    FOR    ${INDEX}    IN RANGE    1    ${NEW}+1
        ${passed}    Run Keyword And Return Status
        ...  Element Should Be Visible       //*[@id="Wall"]/div/div[5]/div[2]/main/section/div/div[${INDEX}]/div//*[@class="product-card__messaging accent--color" and text()=("Just In")]//following-sibling::div[@class='product-card__titles']
        run keyword if     ${passed}        append to list     ${NEW_LIST1}       ${INDEX}
    END


    ${NEW_LIST2}=    Create List
    FOR    ${INDEX2}    IN  @{NEW_LIST1}
        ${TEXT}      get text           //*[@id="Wall"]/div/div[5]/div[2]/main/section/div/div[${INDEX2}]/div//*[@class="product-card__messaging accent--color" and text()=("Just In")]//following-sibling::div[@class='product-card__titles']
        append to list     ${NEW_LIST2}       ${TEXT}
    END
    Remove Values From List     ${NEW_LIST2}   @{EXPECTED_LIST_NIKE}
    set global variable         ${NEW_LIST2}

    send email alert nike

Verify current list in Footlocker site

    Wait until Element is visible            //*[@class="fl-category--productlist"]/div/div[*]//span[@class="fl-product-tile--name"]        60
    sleep       60
    scroll page to middle
    scroll page to bottom
    sleep       30
    Execute javascript          document.body.style.zoom="33%"
    scroll page to top
    Capture Page Screenshot          my-jordan-list_fl_1.png

    ${AJ_LIST}      get element count       //*[@class="fl-category--productlist"]/div/div[*]//span[@class="fl-product-tile--name"]
    run keyword if     ${AJ_LIST}!=22       Get latest release in Footlocker

Get latest release in Footlocker

    ${AJ_LIST}      get element count       //*[@class="fl-category--productlist"]/div/div[*]//span[@class="fl-product-tile--name"]

    ${XPATH_LIST}=    Create List
    FOR    ${INDEX}    IN RANGE    1    ${AJ_LIST}+1
        ${passed}    Run Keyword And Return Status
        ...  Element Should Be Visible      //*[@class="fl-category--productlist"]/div/div[${INDEX}]//span[@class="fl-product-tile--name"]
        run keyword if     ${passed}        append to list     ${XPATH_LIST}       ${INDEX}
    END



    ${NEW_AJ_LIST}=    Create List
    FOR     ${INDEX_LIST}   IN  @{XPATH_LIST}
         ${TEXT}      get text           //*[@class="fl-category--productlist"]/div/div[${INDEX_LIST}]//span[@class="fl-product-tile--name"]
         append to list     ${NEW_AJ_LIST}       ${TEXT}
    END
    Remove Values From List     ${NEW_AJ_LIST}   @{EXPECTED_LIST_FL}
    set global variable         ${NEW_AJ_LIST}

    send email alert footlocker


*** Test Cases ***
Check Jordan 1 in Nike
    Go To Nike Site
    Check current available shoes in Nike


Check Jordan 1 in Footloker
    go to footlocker site
    verify current list in footlocker site