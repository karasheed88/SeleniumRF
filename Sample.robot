*** Settings ***
#Suite Teardown    testEnd
#Resource          seleniumLibrary.robot
Library						SeleniumLibrary

*** Test Cases ***
Test Case
		Open Browser      https://www.google.com/      Chrome
		Wait Until Page Contains    Google
		sleep    10s
		Close Browser
