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
@{EXPECTED LIST}=       Sky Jordan 1\nYounger Kids' Shoe
...                     Sky Jordan 1\nBaby and Toddler Shoe
...                     Jordan 1 Low\nBaby &amp; Toddler Shoe
...                     Jordan 1 Low\nYounger Kids' Shoe


*** Keywords ***
Send test email
    Authorize       account=${USERNAME}    password=${PASSWORD}
    Send Message    sender=${USERNAME}
    ...    recipients=${RECIPIENT}
    ...    subject=Sample SNKRS LIST
    ...    body=This is the new entry ${NEW_LIST2}
    ...    attachments=/tmp/test-reports/my-jordan-list_1.png


Check current available shoes

    Wait until Element is visible       //*[@class="product-card__body"]        60
    Execute javascript          document.body.style.zoom="33%"
    Capture Page Screenshot     my-jordan-list_1.png
    ${TOTAL_CURRENT}    get element count   //*[@class="product-card__body"]
    run keyword if     ${TOTAL_CURRENT}!=9       Get latest release


Get latest release


    ${NEW}      get element count      //*[@id="Wall"]/div/div[5]/div[2]/main/section/div/div[*]

    ${NEW_LIST1}=    Create List
    FOR    ${INDEX}    IN RANGE    1    ${NEW}+1
        ${passed}    Run Keyword And Return Status
        ...  Element Should Be Visible       //*[@id="Wall"]/div/div[5]/div[2]/main/section/div/div[${INDEX}]/div//*[@class="product-card__messaging accent--color" and text()=("Just In")]//following-sibling::div[@class='product-card__titles']
        run keyword if     ${passed}        append to list     ${NEW_LIST1}       ${INDEX}
    END


    ${NEW_LIST2}=    Create List
    FOR    ${INDEX2}    IN  @{NEW_LIST1}
      # ${i}    get from list     ${NEW_LIST1}       ${INDEX2}
        ${TEXT}      get text           //*[@id="Wall"]/div/div[5]/div[2]/main/section/div/div[${INDEX2}]/div//*[@class="product-card__messaging accent--color" and text()=("Just In")]//following-sibling::div[@class='product-card__titles']
        append to list     ${NEW_LIST2}       ${TEXT}
    END

    Remove Values From List     ${NEW_LIST2}   @{EXPECTED LIST}
    set global variable         ${NEW_LIST2}

*** Test Cases ***
Check Jordan 1
    Go To Nike Site
    Check current available shoes
    Send test email
