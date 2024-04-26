*** Settings ***
Resource        ../Resource/Import.robot
Resource        ./GetTokenPage.robot

*** Keywords *** 
Get Case By Id
    [Documentation]       Get case by id from the api for geting the case detail
    ...                       Requires
    ...                           - accessToken to authenticated 
    ...                           - base url
    ...                           - case id which get from create case api
    ...                           - expected status after get case detail by case id
    ...                   Validate the case detail response
    ...                        Requires
    ...                           - response dict cases (response from get case by id) 
    ...                           - json schema

    #get case by id
    [Arguments]    ${accessToken}    ${baseUrl}    ${caseId}    ${expectedStatus}
    ${headers} =    Create Dictionary
    ${data} =    Create Dictionary
    Set To Dictionary    ${headers}    Authorization    Bearer ${accessToken}
    ${responseCase} =    GET    ${baseUrl}/cases/${caseId}
    ...    expected_status=${expectedStatus}
    ...    headers=${headers}
    
    ${responseBodyCase} =    Set Variable    ${responseCase.text}
    ${responseDictCase} =    Evaluate    json.loads($responseBodyCase)    json

    Return From Keyword    ${responseDictCase}
    
Validate Case Detail Response
    #validate the response body from the get cases API with the json schema
    [Arguments]    ${responseDictCase}    ${jsonSchema}
    Validate Json Schema   ${responseDictCase}    ${EXECDIR}/Schema/CaseResponse/${jsonSchema}.json