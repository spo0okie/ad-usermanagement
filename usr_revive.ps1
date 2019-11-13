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

$user =  LoadOUUser $u_login $f_OUDN 
$user_mail=$user.mail.toLower();	

$nu_path=$user.distinguishedName.replace($f_OUDN,$u_OUDN)
$nu_path=$nu_path.substring($nu_path.IndexOf('OU='));

Write-Host "������������ $( $user.displayName ) ����� ��������� � $nu_path! *���� ����� �����*! (CTRL+C ��� ������)"

if (($user_mail -like "*@"+$mail_domain_alias) -or ($user_mail -like "*@"+$mail_domain)) {
	Write-Host "������������� ���� ����� �������: $user_mail"
}

$u_passwd=FetchPwInteractive $u_login $Args[1]

for ( $n = 10; $n -ge 0; $n-- ) {
	Write-Host -NoNewline "$n ... "
	start-sleep -seconds 1
}
Write-Host "�������"


if ( -not (PrepareOU $nu_path)) {
	Write-Host -ForegroundColor Red "������� �������� ����� ��� ��������������!"
    Exit
}


if (($user_mail -like "*@"+$mail_domain_alias) -or ($user_mail -like "*@"+$mail_domain)) {
	UpdPwMailbox $user_mail $u_passwd
}

UpdateADUserPwd $user $u_passwd


Write-Host "���������� ������������..."
Enable-ADAccount $user

UserSet -login $u_login -passwd $u_passwd -mail $user_mail -name $user.Displayname -position $user.Title

Write-Host -ForegroundColor Yellow "���������� � $nu_path"
Move-ADobject $user -Targetpath $nu_path