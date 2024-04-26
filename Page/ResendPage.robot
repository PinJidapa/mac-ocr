*** Settings ***
Resource        ../Resource/Import.robot
Resource        ./GetTokenPage.robot

*** Variables ***
${invite}    invite?inviteType=

*** Keywords *** 
Resend Link
    [Documentation]    Patch resend the link by proprietor id to send the link to user again
    ...                Requires
    ...                - accessToken
    ...                - proprietor id from create case response
    ...                - invite type as email or phone number 

    [Arguments]    ${accessToken}    ${baseUrl}    ${proprietorId}    ${inviteType}    ${expectedStatus}
    ${headers} =    Create Dictionary
    ${data} =    Create Dictionary
    Set To Dictionary    ${headers}    Authorization    Bearer ${accessToken}
    ${responseCases} =    POST    ${baseUrl}/proprietors/${proprietorId}/${invite}${inviteType}    
    ...    expected_status=${expectedStatus}
    ...    headers=${headers}
