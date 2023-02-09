<#
.Synopsis
    New-TierUser.ps1
     
    AUTHOR: Niklas Ilves (Niklas.ilves@advania.com)
    
    THIS CODE-SAMPLE IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED 
    OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR 
    FITNESS FOR A PARTICULAR PURPOSE.
    
.DESCRIPTION
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
.EXAMPLE
    .\New-TierUser.ps1 -Firstname Firstname -Lastname Lastname -Tier T0 -EmployeeType External

    Creates account in T0 for user named Firstname Lastname for external user
.EXAMPLE
    .\New-TierUser.ps1 -Firstname Firstname -Lastname Lastname -Tier All -EmployeeType Internal

    Creates account in All tiers for user named Firstname Lastname
.OUTPUTS

.LINK
    https://github.com/niklasilves

.NOTES
    Version: 1.0
    9 Febuary, 2023
#>
Param (
    # Firstname
    [Parameter(Mandatory=$true, 
                ParameterSetName='')]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [string] 
    $Firstname,

    # Lastname
    [Parameter(Mandatory=$true, 
                ParameterSetName='')]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [string] 
    $Lastname,

    # Tier to create account in
    [Parameter(Mandatory=$true, 
                ParameterSetName='')]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [ValidateSet('T0', 'T1', 'T2','All')]
    [String]
    $Tier,

    # Type of employee External or internal
    [Parameter(Mandatory=$true, 
                ParameterSetName='')]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [ValidateSet('External', 'Internal')]
    [string]     
    $EmployeeType
)

clear-host
Write-host  "********************************************"
Write-host  "Author: niklas.ilves@advania.com"
Write-host  "github: https://github.com/niklasilves/"
Write-host  "********************************************`n"

$VerbosePreference = "continue"
$AdRootDn = (Get-ADDomain).DistinguishedName
$AdDnsRoot = (Get-ADDomain).DNSRoot
$TierRoot = "OU=Admin,"+$AdRootDn
Add-Type -AssemblyName System.Web
$EmpType = $null

if ($EmployeeType -eq 'External'){
    $EmpType = 'x'
    $ExtDescrption = ' [EXT]'
}

if ($Tier -eq 'All'){
    $TierLevel = 'T0', 'T1', 'T2'
} else {
    $TierLevel = $Tier  
}

foreach ($T in $TierLevel){
    $TireName = 'Tier'+($t -split 'T')[1]
    $string = ([System.Web.Security.Membership]::GeneratePassword(63, 13))
    $secPw = ConvertTo-SecureString -String $string -AsPlainText -Force

    $FN = $FirstName.Substring(0,2).ToLower()
    $LN = $LastName.Substring(0,2).ToLower()
    $tmpusrname = $FN+$LN
    $tmpusrname = [Text.Encoding]::ASCII.GetString([Text.Encoding]::GetEncoding("Cyrillic").GetBytes($tmpusrname))
    $UserName = "adm$EmpType$tmpusrname$T"

    if (Get-ADUser -Filter {samaccountname -eq $UserName}){
        $i = 1
        do{
            $UserName ="adm$EmpType$tmpusrname"+"{0:D2}" -f ($i++)+$T
        }
        until(!(Get-ADUser -Filter {samaccountname -eq $UserName}))
    }
    $AdminAccountsDN = "OU=AdminAccounts,OU=$TireName,$TierRoot"
    $Name = "[$T ADM] $FirstName $LastName"
    $Description = "$Name$ExtDescrption"

    New-ADUser -Path $AdminAccountsDN  `
            -Name $Name `
            -AccountPassword $secPw `
            -Description $Description `
            -GivenName $FirstName `
            -SurName $LastName `
            -DisplayName $Name `
            -SamAccountName $UserName `
            -UserPrincipalName "$UserName@$AdDnsRoot"`
            -Enable $True -Verbose
    Get-ADUser -Identity $UserName | Set-ADObject -Replace @{adminCount=1}
    
    if($host.Name -eq "ConsoleHost"){
        Set-Clipboard -Value $string
        Write-Host "Password is saved in clipboard, document it and press any key to continue..." -ForegroundColor Yellow
        $KeyInfo = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        Set-Clipboard -Value $null
        Write-Host "Clipboard is cleared..." -ForegroundColor Yellow
    } else{
        Write-Host "Set new password on $username..." -ForegroundColor Yellow
        Write-Host "TIP: If you runt script in powershell console, password is saved temporay in clipboard." -ForegroundColor Yellow
    }
}

Clear-Variable secPw,string,EmpType,ExtDescrption -ErrorAction SilentlyContinue | Out-Null
