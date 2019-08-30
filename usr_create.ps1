# ������ �������� ������������
# ���������� ����� cmd ������� usr_create.cmd
# v1.6 ������� ���������� ��������� ������� �� ������� js ������ ����������� �������� pwgen - ����� ������ ������������ (� ������������) ������
# v1.5 ��������� � ��������� ����� ��� ������ ����� ��������
# v1.4 �������������� ������, ��������� ����� �������� � ��������� ������
# v1.3 mail_commit, ������� ����� �������� �� ������������� ����� ����� �� ��������� � ����� �����������
# v1.2 �������� ��������� �������
# v1.1 �������� API ��� �������� �����
$u_login=	$Args[0]
$u_name=	$Args[1]
$u_position=	$Args[2]
$u_mail=	$Args[3]
$u_phone=	$Args[4]
$u_pager=	$Args[5]
$do_user=	$Args[6]
$do_mail=	$Args[7]
$u_passwd=	$Args[8]

if ( $Args[7] -eq $null ) {
	Write-Host "Usage: $($MyInvocation.MyCommand.Name) <AD_login> <name(3 tokens)> <position> <mailbox> <ext_phone> <loc_phone> <do_user_flag> <do_mail_flag> [passwd]"
	exit
}

$name	=$u_name.trim()
$names	=$name.split(' ')
$name_cnt=$names | measure
if (-not( $name_cnt.Count -eq 3)) {
	Write-Host 'Err: � ����� ������ ���� ��� ����� (���)'
	Exit
}


. "$($PSScriptRoot)\lib_funcs.ps1"
. "$($PSScriptRoot)\lib_ydx.ps1"
. "$($PSScriptRoot)\lib_usr_ad.ps1"
. "$($PSScriptRoot)\lib_teampass.ps1"
. "$($PSScriptRoot)\config.priv.ps1"

Log ("Script started --- --- ---")

Import-Module ActiveDirectory

Write-host "������ ������������:"
Write-host "���: $u_name"
Write-host "Login: $u_login"
Write-host "�����: $u_mail"
Write-host "���: $u_phone / $u_pager"


if ($u_passwd -eq "") {
	do {
		#$pwgen=
		$u_passwd = invoke-expression "& cscript.exe //Nologo $workdir\pwgen.js"
		#$u_passwd = New-SWRandomPassword -Count 1 -PasswordLength 8 -FirstChar 'ABCEFGHJKLMNPQRSTUVWXYZ' -InputStrings  @('abcdefghijkmnpqrstuvwxyz','23456789', '!,-=(){}_.')
		Write-Host "��������������� ������ :" $u_passwd
		$pwd_accepted = TimedPrompt "����� ������������� ������, ������� ����� ������� � ������� 5� ���..." 5
	} while	($pwd_accepted)
}

Log ("Pasword generated")

if ($do_user -eq 1) {
	Write-host "������� ������������ $u_login : $u_name \ $u_position"
	CreateADUser $u_login $u_name $u_passwd $u_position $u_mail $u_phone $u_pager
}


if ($do_mail -eq 1) {
	Write-host "����� $u_mail $u_passwd"
	CreateMailbox $u_login $u_name $u_passwd $u_position $u_mail $u_phone
}

UserSet -login $u_login -passwd $u_passwd -mail $u_mail -name $u_name -position $u_position

Log "������ ����� ������������: $u_name" $false
if ($do_user -eq 1) { Log "�����: $u_login" $false }
if ($do_mail -eq 1) { Log "�����: $u_mail" $false } 
Log "������ (� �� ���� � ��������� � � �����): $u_passwd" $false
Log "���� � ����� ����� ���� http://mail.yandex.ru ��� Outlook" $false
