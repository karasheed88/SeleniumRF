*** Settings ***
Documentation     This resource define keywords of SeleniumHQ in Robot Framework
Library           String
Library           DateTime
Library           OperatingSystem
Library           SeleniumLibrary    WITH NAME  selenium

*** Variables ***
${browser} =       Headless Chrome
${chrome_path}     C:\\PCAM\\tools\\Chrome87

${remote} =        ${EMPTY}
${remote_user} =   ${EMPTY}
${env} =           "empty"
${vnc} =           ${FALSE}
${video} =         ${FALSE}

${current_tx} =    ${EMPTY}
${tx_start} =      Convert Date     1990-01-01 01:02:3.0
${tx_log_file} =   txs.log

*** Keywords ***
open
    [Arguments]    ${url}
    Comment    The chrome executable should be in the path otherwise we cannot open it
    Append To Environment Variable    PATH     ${chrome_path}
    Run Keyword If    ('${browser}' == 'Chrome' or '${browser}' == 'Headless Chrome') and '${remote}' == ''    initChrome
    Run Keyword If    '${browser}' != 'Chrome' and '${browser}' != 'Headless Chrome' and '${remote}' == ''    Create Webdriver    ${browser}
    ${env_vars} =   Split String    ${env}    ;
    ${vnc} =    Convert To Boolean  ${vnc}
    ${video} =    Convert To Boolean  ${video}
    ${dc}=     Create Dictionary    browserName=chrome    version=${remote_user}    env=${env_vars}    enableVNC=${vnc}    enableVideo=${video}
    Run Keyword If    '${remote}' != ''   Create Webdriver    Remote    command_executor=${remote}   desired_capabilities=${dc}
    Set Selenium Implicit Wait     30s
    Go To    ${url}

clickAndWait
    [Arguments]    ${element}
    Click Element    ${element}

click
    [Arguments]    ${element}
    Click Element    ${element}

type
    [Arguments]    ${element}    ${value}
    Input Text    ${element}    ${value}

selectAndWait
    [Arguments]    ${element}    ${value}
    Select From List    ${element}    ${value}

select
    [Arguments]    ${element}    ${val}
    ${valueParts} =    Split String    ${val}    =    1
    ${valuesLen} =     Get Length      ${valueParts}
    Run Keyword If    ${valuesLen} > 1    Select From List By @{valueParts}[0]    ${element}    @{valueParts}[1]
    Comment    Katalon ommits the value= prefix 
    Run Keyword If    ${valuesLen} == 1    Select From List By Label    ${element}    ${val}

verifyValue
    [Arguments]    ${element}    ${value}
    Element Should Contain    ${element}    ${value}

verifyText
    [Arguments]    ${element}    ${value}
    Element Should Contain    ${element}    ${value}

verifyElementPresent
    [Arguments]    ${element}
    Page Should Contain Element    ${element}

verifyVisible
    [Arguments]    ${element}
    Page Should Contain Element    ${element}

verifyTitle
    [Arguments]    ${title}
    Title Should Be    ${title}

verifyTable
    [Arguments]    ${element}    ${value}
    Element Should Contain    ${element}    ${value}

assertConfirmation
    [Arguments]    ${value}
    Alert Should Be Present    ${value}

assertText
    [Arguments]    ${element}    ${value}
    Element Should Contain    ${element}    ${value}

assertValue
    [Arguments]    ${element}    ${value}
    Element Should Contain    ${element}    ${value}

assertElementPresent
    [Arguments]    ${element}
    Page Should Contain Element    ${element}

assertVisible
    [Arguments]    ${element}
    Page Should Contain Element    ${element}

assertTitle
    [Arguments]    ${title}
    Title Should Be    ${title}

assertTable
    [Arguments]    ${element}    ${value}
    Element Should Contain    ${element}    ${value}

waitForText
    [Arguments]    ${element}    ${value}
    Wait Until Element Contains    ${element}    ${value}

waitForValue
    [Arguments]    ${element}    ${value}
    Element Should Contain    ${element}    ${value}

waitForElementPresent
    [Arguments]    ${element}
    Page Should Contain Element    ${element}

waitForVisible
    [Arguments]    ${element}
    Page Should Contain Element    ${element}

waitForTitle
    [Arguments]    ${title}
    Title Should Be    ${title}

waitForTable
    [Arguments]    ${element}    ${value}
    Element Should Contain    ${element}    ${value}

doubleClick
    [Arguments]    ${element}
    Double Click Element    ${element}

doubleClickAndWait
    [Arguments]    ${element}
    Double Click Element    ${element}

goBack
    Go Back

goBackAndWait
    Go Back

runScript
    [Arguments]    ${code}
    Execute Javascript    ${code}

runScriptAndWait
    [Arguments]    ${code}
    Execute Javascript    ${code}

setSpeed
    [Arguments]    ${value}
    Set Selenium Timeout    ${value}

setSpeedAndWait
    [Arguments]    ${value}
    Set Selenium Timeout    ${value}

verifyAlert
    [Arguments]    ${value}
    Alert Should Be Present    ${value}

initChrome
    ${options}=  Evaluate  sys.modules['selenium.webdriver'].ChromeOptions()  sys, selenium.webdriver
    ${excluded}    Create List    enable-logging
    Call Method    ${options}   add_argument   --lang\=en
    Call Method    ${options}   add_argument   --no-sandbox
    Call Method    ${options}    add_experimental_option    excludeSwitches    ${excluded}
    ${cp}=   Catenate  SEPARATOR=\\   ${chrome_path}   chrome.exe
    ${options.binary_location}=  Set Variable  ${cp}
    Run Keyword If    '${browser}' == 'Headless Chrome'     Call Method    ${options}    add_argument    --headless
    ${roptions}=     Call Method     ${options}    to_capabilities
    Create WebDriver    Chrome    chrome_options=${options}


echo
    [Arguments]      ${tx_name}    ${status}=PASS
    ${now} =         Get Current Date
    ${runtime} =     Subtract Date From Date    ${now}    ${tx_start}
    ${tx_epoch} =    Convert Date    ${tx_start}    epoch
    Run Keyword If    '${current_tx}' != ''    Append To File    ${tx_log_file}    ${tx_epoch},${current_tx},${runtime},${status}${\n}
    Set Suite Variable     ${current_tx}   ${tx_name}
    Set Suite Variable     ${tx_start}     ${now}

testEnd
    echo  End   ${PREV_TEST STATUS}
    Close Browser

close
    [Arguments]    ${none}
    Close Browser

waitForFrame
    [Arguments]    ${index}
    Wait For Condition    return document.getElementsByTagName("iframe")[${index}] != null || document.getElementsByTagName("frame")[${index}] != null   30s    No Frame available

selectFrame
    [Arguments]    ${locator}
    ${index_str} =    Remove String    ${locator}    index=
    ${index_str} =    Set Variable If    '${index_str}' == '${locator}'    -1    ${index_str}
    ${index} =    Convert To Integer    ${index_str}
    Log    Index: ${index}
    Run Keyword If    '${locator}' != 'relative=parent' and ${index} == -1    selenium.Select Frame    ${locator}
    Run Keyword If    '${locator}' == 'relative=parent'    selenium.Unselect Frame
    Return From Keyword If    ${index} == -1    0
    waitForFrame    ${index}
    ${frame_loc} =    Execute JavaScript    if(document.getElementsByTagName("iframe")[${index}] != null && document.getElementsByTagName("frame")[${index}] == null){ return 'dom:document.getElementsByTagName("iframe")[${index}]'}else{ return 'dom:document.getElementsByTagName("frame")[${index}]'}
    ${frame_name} =    Execute JavaScript    if(document.getElementsByTagName("iframe")[${index}] != null && document.getElementsByTagName("frame")[${index}] == null){ return document.getElementsByTagName("iframe")[${index}].name}else{ return document.getElementsByTagName("frame")[${index}].name}
    ${frame_cur} =    Execute JavaScript    if(window.frameElement != null){ return window.frameElement.name}else { return 'null'}
    Log    Frame locator: ${frame_loc}
    Log    Name of selected frame: ${frame_name}
    Log    Name of current frame: ${frame_cur}
    Run Keyword If    ${index} > -1    selenium.Select Frame    ${frame_loc}

waitForPopUp
    ${main_window} =    Select Window   NEW
    Select Window   ${main_window}

captureEntirePageScreenshotAndWait
    Capture Page Screenshot

refreshAndWait
    Reload Page

Get Source
    [Arguments]    ${output_file_path}
    ${src}=    Get Source 
    OperatingSystem.Create File    ${output_file_path}    ${src}

Set Secret From Env
    [Arguments]    ${name}    ${env_var}
    ${OLD_LEVEL} =    Set Log Level    NONE
    ${secret}=   Get Environment Variable   ${env_var}
    Set Suite Variable   ${name}  ${secret} 
    Set Log Level    ${OLD_LEVEL}
