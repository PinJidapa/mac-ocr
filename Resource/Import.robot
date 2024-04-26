*** Settings ***
Library         SeleniumLibrary
Library         String
Library         Collections
Library         RequestsLibrary
Library         OperatingSystem
Library         DateTime
Resource        ${EXECDIR}/Keywords/Utils.robot
Library         ${EXECDIR}/Scripts/validate.py

*** Variables ***
${BROWSER}    chrome