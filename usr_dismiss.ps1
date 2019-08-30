#������ ���������� ������������ � ��:
#
# v1.1 ������� ������� ������ �������������� ��������, ����� ������
#      ������������ ����� ������ ������ � �������� ����� ��������� �����
# v1.0 Initial commit


if ( $Args[0] -eq $null ) {
	Write-Host "Usage: $($MyInvocation.MyCommand.Name) <user_AD_login>"
	exit
}

$u_login = $Args[0]
Import-Module ActiveDirectory
. "$($PSScriptRoot)\config.priv.ps1"
. "$($PSScriptRoot)\lib_funcs.ps1"
. "$($PSScriptRoot)\lib_ydx.ps1"
. "$($PSScriptRoot)\lib_usr_ad.ps1"
. "$($PSScriptRoot)\lib_teampass.ps1"

$user =  LoadUser ($u_login) 
$user_mail=$user.mail.toLower();	

Write-Host "������������ $( $user.displayName ) ����� ������ (CTRL+C ��� ������)"
if (($user_mail -like "*@"+$mail_domain_alias) -or ($user_mail -like "*@"+$mail_domain)) {
	Write-Host "������������� ���� ����� ��������: $user_mail"
}

for ( $n = 5; $n -ge 0; $n-- ) {
	Write-Host $n
	start-sleep -seconds 1
}



if (($user_mail -like "*@"+$mail_domain_alias) -or ($user_mail -like "*@"+$mail_domain)) {
	#Write-Host "������������� ����: $user_mail"
	DisableMailbox($user_mail)
}

DisableADUser($user)
