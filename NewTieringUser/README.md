# Synopsis
New-TierUser.ps1

AUTHOR: Niklas Ilves (Niklas.ilves@advania.com)
    
    THIS CODE-SAMPLE IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED 
    OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR 
    FITNESS FOR A PARTICULAR PURPOSE.
    
# DESCRIPTION
A script that creates administrator users in tier model based on Microsoft documentation.
1. Users will be automatically created in OU=AdminAccounts,OU=TierX,DC=DOMAIN,DC=DOMAIN
2. Password is stored tempoary in clipboard
3. AdminCount will be set to 1

Naming convention

    [adm][ifexternal][FFLL][TierLevel]
    External - admxffllT1
    Internal - admffllT1

If samAccountName will match on new user script will add 2digits right after FFLL

    External - admxffll01T1
    Internal - admffll01T1
# EXAMPLE
    .\New-TierUser.ps1 -Firstname Firstname -Lastname Lastname -Tier T0 -EmployeeType External

    Creates account in T0 for user named Firstname Lastname for external user
# EXAMPLE
    .\New-TierUser.ps1 -Firstname Firstname -Lastname Lastname -Tier All -EmployeeType Internal

    Creates account in All tiers for user named Firstname Lastname
