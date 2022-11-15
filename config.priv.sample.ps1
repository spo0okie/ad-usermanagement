#Настройки информационных систем для скриптов управления пользователями

#АД используется всегда
#домен организации
$domain="domain.local"
#подразделение где хранятся пользователи
$u_OUDN="OU=Пользователи,DC=domain,DC=local"
#подразделение куда увольняются пользователи
$f_OUDN="OU=Уволенные,DC=domain,DC=local"

#писать ли изменения в АД
#read-only AD
$write_ad=$true
#разрешить автоматическое увольнение при синхронизации
$auto_dismiss=$true
#исключить автоматическое уольнение этих логинов:
#про все исключения написать здесь
$auto_dismiss_exclude=@(
    'ivanov.i',
    'petrov.p', 		
    'pupkin.v',
) #!!! ПОСЛЕ ПРАВОК, ПРОВЕРЬ СИНТАКСИС! ПОЛОЖИШЬ ВСЮ СИНХРОНИЗАЦИЮ ОДНОЙ ЗАПЯТОЙ !!!


#из каких групп выкидывать при увольнении
$dismiss_groups=@('Пользователи JIRA')
$dismiss_script='\\DOMAIN.LOCAL\NETLOGON\user_management\usr_dismiss.cmd'

$logfile="C:\temp\user.log"
$workdir="C:\temp\"


#Инвентаризация тоже
#URL сервиса запросов в таблицу пользователей САП
$inventory_RESTapi_URL="https://inventory.azimuth.holding.local/web/api"

#поддержка нескольких организаций
$multiorg_support=$false

#признак того, что мобильный транслируется САП -> АД, если false, то наоборот АД ->SAP
$mobile_from_SAP=$false

#признак того что внутренний номер будем искать в инвентаризации через привязанное оборудование
$phone_from_SAP=$true

#формат даты (приема, увольнения, др) в САП
$dateformat_SAP='yyyy-MM-dd'

#read-only Inv
$write_inventory=$true

#работу с почтой (yandex PDD API) отключаем
$use_mail_API=$false

#работу с тимпасом (сохранение создаваемых паролей) отключаем
$use_teampass_API=$false

#логфайл синхронизации
$sync_logfile="C:\Temp\user_sync.log"
