# Microsoft-ADDS-TieringModel
Default Tiering Design based on recommendations from my work experiance and company such as [Microsoft](https://www.microsoft.com), [Advania](https://www.advania.se), [CQURE](https://cqure.pl/) and [Truesec](https://www.truesec.com/).


NAME
    C:\Scripts\Scriptfiles.ps1
    
SYNOPSIS
    
    AUTHOR: Niklas Ilves (Niklas.ilves@advania.com)

    THIS CODE-SAMPLE IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED
    OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR
    FITNESS FOR A PARTICULAR PURPOSE.
# Clone  Script
First clone repository
```
# With Fine grain Access Token
git clone https://oauth2:[ACCESS_TOKEN]@github.com/niklasilves/iTIER.git

# With Fine grain Access Token exampel
git clone git clone https://oauth2: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@github.com/niklasilves/iTIER.git
```
# Prereq
Following modules are needed
- ActiveDirectory
- GroupPolicy
- NetSecurity
- DSACL

# Prepare Script
Then edit **GlobalVariable.ps1** with costume details. Default Values are listed in the table

Variable | Default Value
---------|---------------
$CompanyName | Company
$OuBaseName | Admin

# Run Script
To run the script execute **00_RunScript.ps1**

# Feature
### Active Directory - Oranizational Unit
- Create organizational unit structure for Microsoft Tiering Model
- Create and nests default tiering groups
- Removes Active Directore DSACL interitance on root OU
### Active Directory - Group Policy - Restrictions
- Create GPO for tiering user rights assignment restrictions
- Create GPO for adding AD DS group to local admin on computer objects
- Create GPO for adding AD DS group to Remote Destop Users on computer objects
### Active Directory - Group Policy - Remote Desktop
- Enables RDP for servers
- Enforcing RDP with Remote Credential Guards
### Active Directory - Authentication Silos
- Configuring Authentication Silos
### Active Directory - Group Policy - Windows Firewall
- Configuring Windows Firewall with IPsec AH only (computer)
- Configuring Windows Firewall with management ports (RDP, WinRM, SMB) with IPsec (computer)
- Create GPO Windows Firewall for custom rules needed

# Git help commands 
## Before editing Create new branch
```
git branch function/CreateFwPolicy
git checkout function/CreateFwPolicy
git push --set-upstream origin function/CreateFwPolicy
git push
```
## After editing push files
```
git add .
git commit -m "TEXT"
git push
```
## Squash to Main
```
git checkout main
git merge --squash function/CreateFwPolicy
git commit -m "TEXT"
git push
```
## Delete branch
```
git branch -D function/CreateFwPolicy
git push origin --delete function/CreateFwPolicy
git fetch -p 
git branch -a
```
## View Commits
```
git log --oneline
```
