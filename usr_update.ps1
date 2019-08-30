#Скрипт смены пароля пользователя
#
#v1.1 Добавлена возможность не передавать пароль, тогда он будет сгенерирован
#v1.0 initial

if ( $Args[0] -eq $null ) {
	Write-Host "Usage: $($MyInvocation.MyCommand.Name) <user_AD_login> [new_password]"
	exit
}

$u_login = $Args[0]
$u_passwd = $Args[1]


Import-Module ActiveDirectory
. "$($PSScriptRoot)\config.priv.ps1"
. "$($PSScriptRoot)\lib_funcs.ps1"
. "$($PSScriptRoot)\lib_ydx.ps1"
. "$($PSScriptRoot)\lib_usr_ad.ps1"
. "$($PSScriptRoot)\lib_teampass.ps1"

$user =  LoadUser ($u_login) 
$user_mail=$user.mail.toLower();	

Write-Host "Пользователю $( $user.displayName ) будет установлен новый пароль"
if (($user_mail -like "*@"+$mail_domain_alias) -or ($user_mail -like "*@"+$mail_domain)) {
	Write-Host "Пароль на корпоративный ящик будет также изменен: $user_mail"
}

if ( ($u_passwd -eq "") -or ($u_passwd -eq $null) ){
	do {
		$u_passwd = invoke-expression "& cscript.exe //Nologo $workdir\pwgen.js"
		Write-Host "Сгенерированный пароль :" $u_passwd
		$pwd_accepted = TimedPrompt "Чтобы сгенерировать другой, нажмите любую клавишу в течении 5х сек..." 5
	} while	($pwd_accepted)
}

Write-host "Устанавливаем пароль $u_passwd (CTRL+C для отмены)"
for ( $n = 5; $n -ge 0; $n-- ) {
	Write-Host $n
	start-sleep -seconds 1
}

if (($user_mail -like "*@"+$mail_domain_alias) -or ($user_mail -like "*@"+$mail_domain)) {
	UpdPwMailbox $user_mail $u_passwd
}

UpdateADUserPwd $user $u_passwd

UserSet -login $u_login -passwd $u_passwd -mail $user_mail -name $user.Displayname -position $user.Title
