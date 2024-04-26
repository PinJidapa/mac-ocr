*** Settings ***
Resource        ../Resource/Import.robot
Resource        ./GetTokenPage.robot

*** Variables ***
${SCHEMA}    {"type": "object", "properties": {"key": {"type": "string"}}, "required": ["key"]}
${JSON_DATA}    {"key": "value"}

*** Keywords *** 
Create Case
    [Documentation]    Post create case for generate proprietors id, case id, and verification id For Patch The EKYC Data
    ...                    Requires
    ...                        - accessToken to authenticate
    ...                        - base url
    ...                        - case type is the file name which is Request body with raw JSON
    ...                        - expected status after post create case
    ...                Validate the create case response 
    ...                    Requires
    ...                        - response dict cases (response from post create case) 
    ...                        - json schema

    #post create case
    [Arguments]    ${accessToken}    ${baseUrl}    ${caseType}    ${expectedStatus}
    ${headers} =    Create Dictionary
    Set To Dictionary    ${headers}    Content-Type    application/json
    Set To Dictionary    ${headers}    Authorization    Bearer ${accessToken}
    ${filePath} =    Get File    ${EXECDIR}/Resource/TestData/CreateCase/${caseType}.json
    ${jsonData} =    Evaluate    json.loads('''${filePath}''')
    ${responseCreateCases} =    POST    ${baseUrl}/cases    json=${jsonData}
    ...    expected_status=${expectedStatus}
    ...    headers=${headers}
    
    #change the response to text format
    ${responseBodyCreateCases} =    Set Variable    ${responseCreateCases.text}

    #change the response to json format
    ${responseDictCreateCases} =    Evaluate    json.loads($responseBodyCreateCases)    json

    Return From Keyword   ${responseDictCreateCases}

Validate Create Case Response
    #validate the response body from the create case API with the json schema
    [Arguments]    ${responseDictCreateCases}       ${jsonSchema}
    Validate Json Schema    ${responseDictCreateCases}     ${EXECDIR}/Schema/CreateCaseResponse/${jsonSchema}.json