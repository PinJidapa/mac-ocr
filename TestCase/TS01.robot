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

*** Variables ***
${smsInviteType}    invite?inviteType=sms&phoneNumber=0619926554
${emailInviteType}    invite?inviteType=email&email=jidapa.o@appman.co.th

# [TS01] Step
# Emulate agent create ekyc case for one insured to do ekyc and sends link via sms  (post create case by valid access token)
# Then, the agent resends link by sms (post resend link by insured's proprietor id)
# Next, agent get case to see the case detail (get case detail by case id)
# After that, the agent fetch the ekyc result before insured does ekyc (get ekyc result by proprietor id)
# Then, simulate insured does ekyc by patch front id, back id, and face compare (liveness's not passed) (patch and post ekyc data by insured's verification id)
# Next, the agent fetches the ekyc result after insured has done the ekyc (get ekyc result by insured's proprietor id)
# Lastly, the agent submits case (patch submit case by case id)

*** Test Cases ***
TS01 Create Case By Mobile Phone Number And Only One Proprietor Does Ekyc
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

    # Get proprietor id from create case response to use in next request
    ${insuredProprietorId} =    Get From Dictionary    ${responseDictCreateCases["proprietors"][0]}    id

    # Get case id from create case response to use in next request
    ${caseId} =    Get From Dictionary    ${responseDictCreateCases}    id

    # Get verification id from create case response to use in next request
    ${insuredVerificationId} =    Get From Dictionary    ${responseDictCreateCases["proprietors"][0]}    verificationRef
    
    # validate the response (post create case by id) with json schema which located in schema folder
    # mainly validate the invite type, insured datail, and verification config
    Validate Create Case Response
    ...    ${responseDictCreateCases}
    ...    verificationResponseSchemaTS001

    # retrieve the access token from get token api, and proprietor id from create case api 
    # then select the invite type as sms to resend the link
    # which the status code should be 204
    Resend Link
    ...    ${accessToken}
    ...    ${baseUrl}
    ...    ${insuredProprietorId}
    ...    ${smsInviteType}
    ...    204

    # retrieve the access token from get token api, and case id from create case api 
    # which the status code should be 200
    ${responseDictCases}=    Get Case By Id
    ...    ${accessToken}
    ...    ${baseUrl}
    ...    ${caseId}
    ...    200

    # validate the response (get the case by id) with json schema which located in schema folder
    # we mainly focus on insured detail, inviteType, verificationCache and case status
    Validate Case Detail Response
    ...    ${responseDictCases}
    ...    CaseResponsAfterCreateCaseTS001

    # retrieve the access token from get token api, and insured's proprietor id from create case api  
    # which the status code should be 200
    ${responseDictProprietor}=    Get Proprietors By ID
    ...    ${accessToken}
    ...    ${baseUrl}
    ...    ${insuredProprietorId}
    ...    200

    # validate the response (get the case by id) with json schema which located in schema folder
    # we mainly focus on insured detail, verificationCache, and ekyc status
    Validate Proprietors Response
    ...    ${responseDictProprietor}
    ...    ProprietorResponseBeforeDoEkycTS001

    # post and patch the ekyc data for insured that required the front and back id card image (located in testData file)
    # the status code should be 200
    Client Pass Front ID Card, Back ID Card, Not Pass Face Recognition
    ...    ${kycPrivateKey}
    ...    ${baseKycUrl}
    ...    ${insuredVerificationId}
    ...    /Resource/TestData/IdCard/FrontIdCard01.jpeg 
    ...    /Resource/TestData/IdCard/BackIdCard01.jpeg
    ...    image/jpeg
    ...    200
    
    # retrieve the access token from get token api, and proprietor id from create case api  
    # which the status code should be 200
    Sleep    5s
    ${responseDictProprietor}=  Get Proprietors By ID
    ...    ${accessToken}
    ...    ${baseUrl}
    ...    ${insuredProprietorId}
    ...    200
 
    # validate the response (get the case by id) with json schema which located in schema folder
    # we mainly focus on insured detail, verificationCache, ocr detail and ekyc status
    Validate Proprietors Response
    ...    ${responseDictProprietor}
    ...    ProprietorResponseAfterDoneEkycTS001

    # retrieve the access token from get token api, and case id from create case api
    # patch submit the case
    # which the status code should be 204
    Patch Submit Case
    ...    ${accessToken}
    ...    ${baseUrl}
    ...    ${caseId}
    ...    204   
    
    Sleep    2
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
    ...    CaseResponsAfterSubmitCaseTS001