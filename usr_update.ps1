#������ ����� ������ ������������
#
#v1.1 ��������� ����������� �� ���������� ������, ����� �� ����� ������������
#v1.0 initial

if ( $Args[0] -eq $null ) {
	Write-Host "Usage: $($MyInvocation.MyCommand.Name) <user_AD_login> [new_password]"
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

Write-Host "������������ $( $user.displayName ) ����� ���������� ����� ������"
if (($user_mail -like "*@"+$mail_domain_alias) -or ($user_mail -like "*@"+$mail_domain)) {
	Write-Host "������ �� ������������� ���� ����� ����� �������: $user_mail"
}

$u_passwd=FetchPwInteractive $u_login $Args[1]

Write-host "������������� ������ $u_passwd (CTRL+C ��� ������)"
for ( $n = 5; $n -ge 0; $n-- ) {
	Write-Host $n
	start-sleep -seconds 1
}

if (($user_mail -like "*@"+$mail_domain_alias) -or ($user_mail -like "*@"+$mail_domain)) {
	UpdPwMailbox $user_mail $u_passwd
}

UpdateADUserPwd $user $u_passwd

UserSet -login $u_login -passwd $u_passwd -mail $user_mail -name $user.Displayname -position $user.Title
