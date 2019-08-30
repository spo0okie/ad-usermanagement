#Скрипт увольнения пользователя в АД:
#
# v1.1 Сначала выводит список предполагаемых действий, потом делает
#      Пользователя можно искать указав в качестве имени табельный номер
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

Write-Host "Пользователь $( $user.displayName ) будет уволен (CTRL+C для отмены)"
if (($user_mail -like "*@"+$mail_domain_alias) -or ($user_mail -like "*@"+$mail_domain)) {
	Write-Host "Корпоративный ящик будет отключен: $user_mail"
}

for ( $n = 5; $n -ge 0; $n-- ) {
	Write-Host $n
	start-sleep -seconds 1
}



if (($user_mail -like "*@"+$mail_domain_alias) -or ($user_mail -like "*@"+$mail_domain)) {
	#Write-Host "Корпоративный ящик: $user_mail"
	DisableMailbox($user_mail)
}

DisableADUser($user)
