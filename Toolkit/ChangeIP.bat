@echo off & setlocal enabledelayedexpansion
echo     �޸Ĳ��ɹ��Ļ������Ҽ��Թ���Ա����
set /A N=0
echo.
for /f "skip=1 tokens=1,* delims= " %%a in ('wmic nic where AdapterTypeId^="0" get name^,Index') do ( if "%%b" == "" ( @echo off ) else (set /A N+=1&set _!N!INDEX=%%a&call echo.[!N!] %%b %%a) )
echo.
IF !N! EQU 1 set /A input=1&goto _DEVICE_OK
set /p input=ѡ���㱾�˵��Ե���������
:_DEVICE_OK
set /A _index=!_%input%INDEX!

if "%1"==""  ( goto _ChangeIP ) else ( goto _ChangeIP%1 )

:_ChangeIP
set var=""

echo.
echo     [1]�Զ���IP    [2]�Զ����IP  [3]192.168.1.X
echo.
set /p var=��ѡ��[1/2/3]:
echo.
if %var%==1 echo ���þ�̬IP  & goto _ChangeIP1
if %var%==2 echo �����Զ����IP & goto _ChangeIP2
if %var%==3 echo ����192.168.1.X & goto _ChangeIP3
goto END
:_ChangeIP1
set /p yourAddress=��д���ṩ��ѧУ��IP��ַ  
set /p yourMask=��д���ṩ��ѧУ������Դ��
set /p yourGateway=��д���ṩ��ѧУ�����ص�ַ  
wmic nicconfig where index=%_index% call enablestatic "%yourAddress%","%yourMask%"
wmic nicconfig where index=%_index% call enablestatic(%yourAddress%)
wmic nicconfig where index=%_index% call setgateways(%yourGateway%),(1)
wmic nicconfig where index=%_index% call SetDNSServerSearchOrder(202.112.17.33,114.114.114.114)
goto END
:_ChangeIP2
wmic nicconfig where index=%_index% call enabledhcp
goto END
:_ChangeIP3
wmic nicconfig where index=%_index% call enablestatic "192.168.1.11","255.255.255.0"
wmic nicconfig where index=%_index% call setgateways(192.168.1.1),(1)
wmic nicconfig where index=%_index% call SetDNSServerSearchOrder(202.112.17.33,114.114.114.114)
:END