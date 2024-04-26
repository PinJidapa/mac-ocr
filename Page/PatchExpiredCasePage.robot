*** Settings ***
Resource        ../Resource/Import.robot
Resource        ./GetTokenPage.robot

*** Keywords *** 
Patch Expired Case
    [Documentation]    Patch close case by case id to make the link expire
    ...                Requires
    ...                - accessToken to authenticate
    ...                - base url
    ...                - case id from create case response
    ...                - expected status after patch close the case (make the case expire)

    [Arguments]    ${accessToken}    ${baseUrl}    ${caseId}    ${expectedStatus}
    ${headers} =    Create Dictionary
    ${data} =    Create Dictionary
    Set To Dictionary    ${headers}    Authorization    Bearer ${accessToken}
    ${responseCases} =    PATCH    ${baseUrl}/cases/${caseId}/close
    ...    expected_status=${expectedStatus}
    ...    headers=${headers}
