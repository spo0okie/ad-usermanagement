#��������� �������������� ������ ��� �������� ���������� ��������������

#�� ������������ ������
#����� �����������
$domain="domain.local"
#������������� ��� �������� ������������
$u_OUDN="OU=������������,DC=domain,DC=local"
#������������� ���� ����������� ������������
$f_OUDN="OU=���������,DC=domain,DC=local"

#������ �� ��������� � ��
#read-only AD
$write_ad=$true
#��������� �������������� ���������� ��� �������������
$auto_dismiss=$true
#��������� �������������� ��������� ���� �������:
#��� ��� ���������� �������� �����
$auto_dismiss_exclude=@(
    'ivanov.i',
    'petrov.p', 		
    'pupkin.v',
) #!!! ����� ������, ������� ���������! �������� ��� ������������� ����� ������� !!!


#�� ����� ����� ���������� ��� ����������
$dismiss_groups=@('������������ JIRA')
$dismiss_script='\\DOMAIN.LOCAL\NETLOGON\user_management\usr_dismiss.cmd'

$logfile="C:\temp\user.log"
$workdir="C:\temp\"


#�������������� ����
#URL ������� �������� � ������� ������������� ���
$inventory_RESTapi_URL="https://inventory.azimuth.holding.local/web/api"

#��������� ���������� �����������
$multiorg_support=$false

#������� ����, ��� ��������� ������������� ��� -> ��, ���� false, �� �������� �� ->SAP
$mobile_from_SAP=$false

#������� ���� ��� ���������� ����� ����� ������ � �������������� ����� ����������� ������������
$phone_from_SAP=$true

#������ ���� (������, ����������, ��) � ���
$dateformat_SAP='yyyy-MM-dd'

#read-only Inv
$write_inventory=$true

#������ � ������ (yandex PDD API) ���������
$use_mail_API=$false

#������ � �������� (���������� ����������� �������) ���������
$use_teampass_API=$false

#������� �������������
$sync_logfile="C:\Temp\user_sync.log"
