*** Settings ***
Resource        ../Resource/Import.robot
Resource        ./GetTokenPage.robot

*** Keywords *** 
Get Proprietors By ID
    [Documentation]       Get Propietors by id from the api for geting EKYC resule
    ...                       Requires
    ...                           - accessToken to authenticate
    ...                           - base url
    ...                           - proprietor id which get from create case api
    ...                           - expected status after get proprietor by proprietor id
    ...                    Validate the case detail response
    ...                        Requires
    ...                           - response dict cases (response from get proprietor by proprietor id) 
    ...                           - json schema

    #get proprietors by proprietor id
    [Arguments]    ${accessToken}    ${baseUrl}    ${proprietorId}    ${expectedStatus}
    ${headers} =    Create Dictionary
    ${data} =    Create Dictionary
    Set To Dictionary    ${headers}    Authorization    Bearer ${accessToken}
    ${responseProprietor} =    GET    ${baseUrl}/proprietors/${proprietorId}
    ...    expected_status=${expectedStatus}
    ...    headers=${headers}

    ${responseBodyProprietor} =    Set Variable    ${responseProprietor.text}
    ${responseDictProprietor} =    Evaluate    json.loads($responseBodyProprietor)    json
    Return From Keyword    ${responseDictProprietor}    

Validate Proprietors Response
    #validate the response body from the get proprietor API with the json schema
    [Arguments]    ${responseDictProprietor}     ${jsonSchema}
    Validate Json Schema    ${responseDictProprietor}     ${EXECDIR}/Schema/ProprietorResponse/${jsonSchema}.json