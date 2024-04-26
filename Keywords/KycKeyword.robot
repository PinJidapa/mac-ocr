*** Settings ***
Resource    ../Page/KycPage.robot

*** Keywords ***
Client Pass Front ID Card, Back ID Card, Not Pass Face Recognition
    [Arguments]
    ...    ${kycPrivateKey}
    ...    ${baseKycUrl}
    ...    ${verificationId}
    ...    ${frontIdCard} 
    ...    ${backIdCard} 
    ...    ${extensionName}
    ...    ${expectedStatus}
    Patch Consent
    ...    ${kycPrivateKey}    
    ...    ${baseKycUrl}    
    ...    ${verificationId}    
    ...    ${expectedStatus}
    Post Front ID Card
    ...    ${kycPrivateKey}    
    ...    ${baseKycUrl}    
    ...    ${verificationId}   
    ...    ${frontIdCard}    
    ...    ${extensionName}
    Patch Front ID Card
    ...    ${kycPrivateKey}    
    ...    ${baseKycUrl}    
    ...    ${verificationId}    
    ...    ${expectedStatus}
    Post Back ID Card
    ...    ${kycPrivateKey}    
    ...    ${baseKycUrl}    
    ...    ${verificationId}    
    ...    ${backIdCard}    
    ...    ${extensionName}
    Patch Back ID Card
    ...    ${kycPrivateKey}    
    ...    ${baseKycUrl}   
    ...    ${verificationId}    
    ...    ${expectedStatus}
    Get FaceTec Token Session  
    ...    ${kycPrivateKey}    
    ...    ${baseKycUrl}    
    ...    ${verificationId}    
    ...    ${expectedStatus}
    Patch Remark
    ...    ${kycPrivateKey}    
    ...    ${baseKycUrl}    
    ...    ${verificationId}    
    ...    ${expectedStatus}
    Patch Confirm Verification
    ...    ${kycPrivateKey}    
    ...    ${baseKycUrl}    
    ...    ${verificationId}    
    ...    ${expectedStatus}