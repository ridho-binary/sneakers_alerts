*** Settings ***
Library    SeleniumLibrary
Library    String
Resource     ../common/resource.robot

*** Variables ***
${NIKE_LINK}            https://www.nike.com/my/w?q=AIR%20JORDAN%201&vst=AIR%20JORDAN%201
${FL_LINK}              https://www.footlocker.my/en/all/jordan_1

*** Keywords ***
Go To Nike Site
    Chrome Headless
    Register Keyword To Run On Failure      NONE
    Go To   ${NIKE_LINK}
    Set window size     1484    800


Go To Footlocker Site
    Chrome Headless
    Register Keyword To Run On Failure      NONE
    go to       ${FL_LINK}
    Set window size     1484    800

