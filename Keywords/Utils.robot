*** Settings ***
Library     SeleniumLibrary


*** Keywords ***
Click Element Using JavaScript Id ${ID}
    [Documentation]
    ...    Click element using javascript while passing location using id
    Execute JavaScript    document.getElementById('${ID}').click()

Run Until Keyword Succeed 
    [Arguments]    ${keyword}    ${args}
    [Documentation]
    ...    Run keyword until it succeeds or timeout is reached
    Wait Until Keyword Succeeds    10s    1s    ${keyword}    ${args}
    

Get Child Webelements
    [Arguments]    ${locator}

    ${element}    Get WebElement    ${locator}    
    ${children}     Call Method       
    ...                ${element}    
    ...                find_elements   
    ...                  by=xpath    value=child::*    
    Return From Keyword      ${children}

Click Element Using JavaScript Text
    [Arguments]    ${text}
    [Documentation]
    ...    Click element using javascript while passing location using text
    Execute JavaScript    document.evaluate("//*[text()='${text}']", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.click()

Check If Text is Present
    [Arguments]    ${text}
    [Documentation]
    ...    Check if text is present in the page
    TRY
        ${result}    Execute JavaScript    return document.evaluate("//*[text()='${text}']", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue != null
    EXCEPT
        ${result}    Set Variable    False
    END
    Return From Keyword   ${result}