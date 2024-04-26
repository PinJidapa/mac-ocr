*** Settings ***
Resource        ../Resource/Import.robot

*** Keywords *** 
Get Token
    [Documentation]       
    ...    Get a token from the api Gateway for making authenticated requests. 
    ...    Requires 
    ...        - the clientId and the clientSecret
    ...        - autorization url

    #get token  from authorization
    [Arguments]    ${clientId}    ${clientSecret}    ${authUrl} 
    ${data} =    Create Dictionary
    ...    client_id=${clientId}
    ...    client_secret=${clientSecret}
    ...    grant_type=client_credentials
    ${response} =    POST    ${authUrl}    data=${data}
    ${responseBody} =    Set Variable    ${response.text}
    ${responseDict} =    Evaluate    json.loads($responseBody)
    ${accessToken} =    Get From Dictionary    ${responseDict}    access_token
    Return From Keyword    ${accessToken}