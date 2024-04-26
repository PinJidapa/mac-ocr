*** Settings ***
Library         SeleniumLibrary
Library         JSONLibrary
Resource        ../Page/GetTokenPage.robot
Resource        ../Page/CreateCasePage.robot
Resource        ../Page/ResendPage.robot
Resource        ../Page/GetCaseByIdPage.robot
Resource        ../Keywords/KycKeyword.robot
Resource        ../Page/GetProprietorByIdPage.robot
Resource        ../Page/PatchExpiredCasePage.robot
Resource        ../Page/PatchSubmitCasePage.robot
Resource        ../Resource/Env/${env}/Credential.robot
Resource        ../Resource/Env/${env}/Url.robot

# [TS04] Step
# Emulate agent create ekyc case for one insured to do ekyc  (post create case by valid access token)
# Then, the agent closes the case to make the case expire (patch expire case by case id)
# Lastly, the agent close shouldn't patch to expired the case again (patch expire case by case id)
*** Test Cases ***
TS04 Close The Case To Be Expired
    # Get access token 
    ${accessToken}=     Get Token
    ...    ${clientId}    
    ...    ${clientSecret}    
    ...    ${authUrl}
    
    # Create the case by only insured do ekyc
    # which the status code should be 201
    ${responseDictCreateCases}=    Create Case
    ...    ${accessToken}
    ...    ${baseUrl}
    ...    OneProprietorCaseBySms
    ...    201

    # Get case id from create case response to use in next request
    ${caseId} =    Get From Dictionary    ${responseDictCreateCases}    id

    # retrieve the access token from get token api, and case id from create case api 
    # which the status code should be 200
    Patch Expired Case
    ...    ${accessToken}
    ...    ${baseUrl}
    ...    ${caseId}
    ...    204

    Sleep    5s
    # retrieve the access token from get token api, and case id from create case api 
    # which the status code should be 200
    ${responseDictCases}=    Get Case By Id
    ...    ${accessToken}
    ...    ${baseUrl}
    ...    ${caseId}
    ...    200

    # validate the response (get the case by id) with json schema which located in schema folder
    # we mainly focus on the case status
    Validate Case Detail Response
    ...    ${responseDictCases}
    ...    CaseResponsAfterExpireCaseTS004

    # retrieve the access token from get token api, and case id from create case api 
    # which the status code should be 404   
    Patch Expired Case
    ...    ${accessToken}
    ...    ${baseUrl}
    ...    ${caseId}
    ...    404