*** Settings ***
Library    SeleniumLibrary
Library    String

*** Variables ***
@{chrome_arguments}	    --disable-infobars    --headless    --disable-gpu
#@{chrome_arguments}

*** Keywords ***
Set Chrome Options
    [Documentation]    Set Chrome options for headless mode
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    FOR    ${option}    IN    @{chrome_arguments}
        Call Method    ${options}    add_argument    ${option}
    END
    [Return]    ${options}

Chrome Headless
    ${chrome_options}=    Set Chrome Options
    Create Webdriver    Chrome    chrome_options=${chrome_options}

