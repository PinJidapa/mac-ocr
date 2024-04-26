*** Settings ***
Resource        ../Resource/Import.robot
Library         ../Scripts/api.py
Resource        ./GetTokenPage.robot

*** Keywords *** 
Patch Consent
    [Documentation]    Patch consent for updating consent status for PDPA compliance.
    ...                Requires
    ...                - kycPrivateKey
    ...                - base kyc url
    ...                - verification id from create case response
    ...                - expected status after patch consent
    ...                - request body with the raw json file

    [Arguments]    ${kycPrivateKey}    ${baseKycUrl}    ${verificationId}    ${expectedStatus}
    ${headers} =    Create Dictionary
    Set To Dictionary    ${headers}    Authorization    Bearer ${kycPrivateKey}
    ${file_path} =    Get File    ${EXECDIR}/Resource/TestData/Ekyc/patchConsentBody.json
    ${json_data} =    Evaluate    json.loads('''${file_path}''')
    ${patchConsent} =    PATCH    ${baseKycUrl}/verifications/${verificationId}
    ...    expected_status=${expectedStatus}
    ...    json=${json_data}
    ...    headers=${headers}

Post Front ID Card
    [Documentation]    Post front id card file by verificationId for operating front id card OCR
    ...                Requires
    ...                - kycPrivateKey
    ...                - base kyc url
    ...                - verificationId from create case api
    ...                - front id card image as form-data
    ...                - expected status after post the front id card image

    [Arguments]    ${kycPrivateKey}    ${baseKycUrl}    ${verificationId}    ${frontIdCard}    ${extensionName}
    ${headers} =    Create Dictionary
    Set To Dictionary    ${headers}    Authorization    Bearer ${kycPrivateKey}
    ${response} =    Upload File
    ...    ${baseKycUrl}/verifications/${verificationId}/frontIdCards
    ...    ${EXECDIR}${frontIdCard}
    ...    ${extensionName}
    ...    ${headers}

Patch Front ID Card
    [Documentation]    Patch front id card for confirming the result from OCR
    ...                Requires
    ...                - kycPrivateKey
    ...                - base kyc url
    ...                - verification id from create case api
    ...                - expected status after patch confirm front id result
    ...                - request body with the raw json file

    [Arguments]    ${kycPrivateKey}    ${baseKycUrl}    ${verificationId}    ${expectedStatus}
    ${headers} =    Create Dictionary
    Set To Dictionary    ${headers}    Authorization    Bearer ${kycPrivateKey}
    ${file_path} =    Get File    ${EXECDIR}/Resource/TestData/Ekyc/patchIdCard.json
    ${json_data} =    Evaluate    json.loads('''${file_path}''')
    ${response} =    PATCH    ${baseKycUrl}/verifications/${verificationId}/frontIdCards
    ...    json=${json_data}
    ...    headers=${headers}
    ...    expected_status=${expectedStatus}

Post Back ID Card
    [Documentation]    Post back id card file by verificationId for operating back id card OCR
    ...                Requires
    ...                - kycPrivateKey
    ...                - base kyc url
    ...                - verification id from create case api
    ...                - back id card image as form-data
    ...                - expected status after post the back id card image 

    [Arguments]    ${kycPrivateKey}    ${baseKycUrl}    ${verificationId}    ${backIdCard}    ${extensionName}
    ${headers} =    Create Dictionary
    Set To Dictionary    ${headers}    Authorization    Bearer ${kycPrivateKey}
    ${response} =    Upload File
    ...    ${baseKycUrl}/verifications/${verificationId}/backIdCards
    ...    ${EXECDIR}${backIdCard}
    ...    ${extensionName}
    ...    ${headers}

Patch Back ID Card
    [Documentation]    Patch front id card for confirming the result from OCR
    ...                Requires
    ...                - kycPrivateKey
    ...                - base kyc url
    ...                - verification id from create case api
    ...                - expected status after patch confirm back id result
    ...                - request body with the raw json file

    [Arguments]    ${kycPrivateKey}    ${baseKycUrl}    ${verificationId}    ${expectedStatus}
    ${headers} =    Create Dictionary
    Set To Dictionary    ${headers}    Authorization    Bearer ${kycPrivateKey}
    ${file_path} =    Get File    ${EXECDIR}/Resource/TestData/Ekyc/patchIdCard.json
    ${json_data} =    Evaluate    json.loads('''${file_path}''')
    ${response} =    PATCH    ${baseKycUrl}/verifications/${verificationId}/backIdCards
    ...    json=${json_data}
    ...    headers=${headers}
    ...    expected_status=${expectedStatus}

Get FaceTec Token Session  
    [Documentation]    Get the sessionToken from FaceTec for making the face recognition 
    ...                    Requires
    ...                        - kycPrivateKey
    ...                        - base kyc url
    ...                        - verification id from create case api
    ...                        - expected status after get the session-token
    ...                Post the liveness Image/video to do the liveness 
    ...                    Requires
    ...                        - sessionToken
    ...                        - verification id from create case api
    ...                        - video and image file with Base64 format with the raw json file
    ...                        - expected status after post video and image file to do face recognition

    [Arguments]    ${kycPrivateKey}    ${baseKycUrl}    ${verificationId}    ${expectedStatus}
    ${headers} =    Create Dictionary
    Set To Dictionary    ${headers}    Authorization    Bearer ${kycPrivateKey}
    Set To Dictionary    ${headers}    X-Device-Key    dZKMPkqUqEBn370Rz8uq3nn0zdUAeqpE
    ${tokenResponse} =    GET    ${baseKycUrl}/verifications/${verificationId}/liveness/facetec/session-token
    ...    headers=${headers}

    ${tokenResponseSessionToken} =    Set Variable    ${tokenResponse.text}
    ${tokenResponseDictSessionToken} =    Evaluate    json.loads($tokenResponseSessionToken)
    ${sessionToken} =    Get From Dictionary    ${tokenResponseDictSessionToken}    sessionToken
    Set Test Variable    ${sessionToken}

    ${file_path} =    Get File    ${EXECDIR}/Resource/TestData/Ekyc/livenessFail.json
    ${json_data} =    Evaluate    json.loads('''${file_path}''')
    Set To Dictionary    ${json_data}    sessionId    ${sessionToken}
    ${response} =    POST     ${baseKycUrl}/verifications/${verificationId}/liveness/facetec/liveness-3d    json=${json_data}
    ...    headers=${headers}
    ...    expected_status=${expectedStatus}


Patch Remark
    [Documentation]    Patch the remark to note the reason why not pass face recognition
    ...                    Requires
    ...                        - kycPrivateKey
    ...                        - base kyc url
    ...                        - verification id from create case api
    ...                        - expected status after patch the remark reason
    ...                        - request body with the raw json file

    [Arguments]    ${kycPrivateKey}    ${baseKycUrl}    ${verificationId}    ${expectedStatus}
    ${headers} =    Create Dictionary
    Set To Dictionary    ${headers}    Authorization    Bearer ${kycPrivateKey}
    ${file_path} =    Get File    ${EXECDIR}/Resource/TestData/Ekyc/patchRemark.json
    ${json_data} =    Evaluate    json.loads('''${file_path}''')
    ${response} =    PATCH    ${baseKycUrl}/verifications/${verificationId}
    ...    json=${json_data}
    ...    headers=${headers}
    ...    expected_status=${expectedStatus}

Patch Confirm Verification
    [Documentation]    Patch confirm the EKYC verifcation to finish the EKYC process
    ...                    Requires
    ...                        - kycPrivateKey
    ...                        - base kyc url
    ...                        - verification id from create case api
    ...                        - expect status  after patch the confirm the verification
    ...                        - request body with the raw json file

    [Arguments]    ${kycPrivateKey}    ${baseKycUrl}    ${verificationId}    ${expectedStatus}
    ${headers} =    Create Dictionary
    Set To Dictionary    ${headers}    Authorization    Bearer ${kycPrivateKey}
    ${file_path} =    Get File    ${EXECDIR}/Resource/TestData/Ekyc/patchConfirm.json
    ${json_data} =    Evaluate    json.loads('''${file_path}''')
    ${response} =    PATCH    ${baseKycUrl}/verifications/${verificationId}/idFaceRecognitions
    ...    json=${json_data}
    ...    headers=${headers}
    ...    expected_status=${expectedStatus}