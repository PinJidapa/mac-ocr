*** Settings ***
Resource        ../Resource/Import.robot
Resource        ./GetTokenPage.robot

*** Keywords *** 
Patch Submit Case
    [Documentation]    Patch submit case by case id to submit the case
    ...                    Requires
    ...                         - accessToken to authenticate
    ...                         - base url
    ...                         - case id from create case response
    ...                         - expected statis after sibmit the case

    [Arguments]    ${accessToken}    ${baseUrl}    ${caseId}    ${expectedStatus}
    ${headers} =    Create Dictionary
    ${data} =    Create Dictionary
    Set To Dictionary    ${headers}    Authorization    Bearer ${accessToken}
    ${responseCases} =    PATCH    ${baseUrl}/cases/${caseId}/submit
    ...    expected_status=${expectedStatus}
    ...    headers=${headers}
