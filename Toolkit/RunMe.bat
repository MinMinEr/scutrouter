@echo off & setlocal enabledelayedexpansion
color 1A
TITLE һ������·�����ű�  --����·������ʽȺ��Ʒ
set routerPasswd=admin
pushd "%CD%"
CD /D "%~dp0"
echo �������������������������������
echo ������������������������������������������������
echo ���������������������������������������
echo ����������������������������������������������
echo ��������������������������������������������������
echo �����������������������������������������
echo ������������������������������������������������
echo ���������������������������������������������
echo ��������������������������������������
echo �����������������������������������������������
echo �����������������������������������������������
echo �������������������������������������������
echo ����������������������������������������������������
echo �������������������������������
echo.&echo =========================================================
echo 	���ű���#����·������ʽȺ#�ṩ
echo 	ע�⣺��½·�����������Ϊ%routerPasswd%�������Ȼʧ��
echo.&echo =========================================================
echo.
echo ��ʾ���ű������������·�ɵ���������IP��DNSΪ�Զ���ã�������ɹ����Ǿ��Լ�������������Ϊ�Զ���ú��ٴ�ִ�иýű���
echo ��������б������һ��TAP-Win32 XX VXX�Ķ������Ǹ�������������������������һ���Intel��Realtek��Atheros��Nvidia��Broadcom��Marvell�ȳ�������
pause
call ChangeIP.bat 2
echo ��ʾ���Ѿ���������·�ɵ���������IP��DNSΪ�Զ����
pause
:_PING
ping OpenWrt
IF %errorlevel% EQU 0 ( goto _CONTINUE ) else ( goto NO_OPENWRT )
pause
:NO_OPENWRT
echo ��ϵͳ����Ϊ��OPENWRT�ٷ�ϵͳ�������ǲ�����OpenWrt�����������������˼���ִ�нű�������Ѿ�ȷ����OpenWrtϵͳ���Լ���
pause
echo.
ping -a 192.168.1.1
IF %errorlevel% EQU 0 ( goto _CONTINUE ) else ( goto _FAIL )
:_CONTINUE
echo �������������Ϣ��ÿ����Ϣ����󰴻س�������һ������
set /p User=�����õ��û���(��ʵ����ѧ��)��  
set /p Password=�����õ����루������������ѯ�������ģ�:  
set /p SSID=���Լ���Ҫ�ĵ�WIFI���֣�ֻ��Ӣ�Ļ������ָ����Ż�:  
set /p Key=·������WIFI���루����8λ��ֻ��Ӣ�Ļ������ָ����Ż�:  
:MAC_LOOP
echo.&echo ��������������������������������������������������������������������������������
echo.&echo  ѡ��ҪӦ�õ�·������MAC�����������ѧУ�Ǽ����ѡ����Ӧ��MAC��ַ
set /A N=0
for /f "skip=1 tokens=1,* delims= " %%a in ('wmic nic where AdapterTypeId^="0" get name^,macaddress') do ( if "%%b" == "" ( @echo off ) else (set /A N+=1&set _!N!MAC=%%a&call echo.[!N!] %%b %%a) )
set /A N+=1
echo [%N%] ���������������ѧУ�Ǽǵģ�Ҫ������MAC��ַ����ʽ��д��ĸXX:XX:XX:XX:XX:XX)  
echo.&echo ��������������������������������������������������������������������������������
echo.
set /p input=ѡ������ҪӦ�õ�MAC��ַ�������б�����е����־��У������û����ѡ��[%N%]:
IF %input% EQU %N% (goto DIY_MAC) ELSE (set MACaddress=!_%input%MAC! & goto MAC_END)
:DIY_MAC
echo.
set /p MACaddress=��д���ṩ��ѧУ��MAC��ַ,��Ӣ��״̬���뷨����:  
:MAC_END
checkMAC.bat %MACaddress%|findstr error && goto MAC_LOOP || goto _MAC_OK
:_MAC_OK
echo.
set /p IPaddress=��дѧУ�����IP��ַ(��ʽX.X.X.X):  
checkIP.bat %IPaddress%|findstr error && goto _MAC_OK || goto _IP_OK
:_IP_OK
echo.
set /p Mask=��дѧУ�������������(��ʽX.X.X.X):  
checkIP.bat %Mask%|findstr error && goto _IP_OK || goto _MASK_OK
:_MASK_OK
echo.
set /p Gateway=��дѧУ��������ص�ַ(��ʽX.X.X.X):  
checkIP.bat %Gateway%|findstr error && goto _IP_OK || goto _GATEWAY_OK
:_GATEWAY_OK
echo.
echo ��ʾ��׼��telnet·�ɿ�ͨSSH���������Ϊ%routerPasswd%,�������FATAL ERROR: Network error: Connection refused Ҳ�������
pause
echo (echo %routerPasswd% ^&^& echo %routerPasswd%) ^> pass.log ^&^& (passwd ^< pass.log ^&^& rm -f pass.log) ^&^& exit > telnet.sh
type telnet.sh|plink -telnet root@192.168.1.1
cd.>telnet.sh
echo.
echo ��ʾ��׼������setup_ipk�ļ��е�·�ɵ�/tmp/����
pause
echo opkg remove luci-app-scutclient> %~dp0setup_ipk\commands.sh
echo opkg remove scutclient>> %~dp0setup_ipk\commands.sh
echo opkg install /tmp/setup_ipk/*.ipk>> %~dp0setup_ipk\commands.sh
echo uci set system.@system[0].hostname='SCUT'>> %~dp0setup_ipk\commands.sh
echo uci set system.@system[0].timezone='HKT-8'>> %~dp0setup_ipk\commands.sh
echo uci set system.@system[0].zonename='Asia/Hong Kong'>> %~dp0setup_ipk\commands.sh
echo uci set luci.languages.zh_cn='chinese'>> %~dp0setup_ipk\commands.sh
echo uci set network.wan.macaddr='%MACaddress%'>> %~dp0setup_ipk\commands.sh
echo uci set network.wan.proto='static'>> %~dp0setup_ipk\commands.sh
echo uci set network.wan.ipaddr='%IPaddress%'>> %~dp0setup_ipk\commands.sh
echo uci set network.wan.netmask='%Mask%'>> %~dp0setup_ipk\commands.sh
echo uci set network.wan.gateway='%Gateway%'>> %~dp0setup_ipk\commands.sh
echo uci set network.wan.dns='202.112.17.33 114.114.114.114'>> %~dp0setup_ipk\commands.sh
echo uci set wireless.@wifi-device[0].disabled='0'>> %~dp0setup_ipk\commands.sh
echo uci set wireless.@wifi-iface[0].mode='ap'>> %~dp0setup_ipk\commands.sh
echo uci set wireless.@wifi-iface[0].ssid='%SSID%'>> %~dp0setup_ipk\commands.sh
echo uci set wireless.@wifi-iface[0].encryption='psk2'>> %~dp0setup_ipk\commands.sh
echo uci set wireless.@wifi-iface[0].key='%Key%'>> %~dp0setup_ipk\commands.sh
echo uci set scutclient.@option[0].boot='1'>> %~dp0setup_ipk\commands.sh
echo uci set scutclient.@option[0].enable='1'>> %~dp0setup_ipk\commands.sh
echo uci set scutclient.@scutclient[0]='scutclient'>> %~dp0setup_ipk\commands.sh
echo uci set scutclient.@scutclient[0].interface=$(uci get network.wan.ifname)>> %~dp0setup_ipk\commands.sh
echo uci set scutclient.@scutclient[0].username='%User%'>> %~dp0setup_ipk\commands.sh
echo uci set scutclient.@scutclient[0].password='%Password%'>> %~dp0setup_ipk\commands.sh
echo uci commit>> %~dp0setup_ipk\commands.sh
echo echo sleep 30 ^> /etc/rc.local>> %~dp0setup_ipk\commands.sh
echo echo killall scutclient^>^> /etc/rc.local>> %~dp0switch\commands.sh
echo echo scutclient %User% %Password% \^& ^>^> /etc/rc.local>> %~dp0setup_ipk\commands.sh
echo echo sleep 30 ^>^> /etc/rc.local>> %~dp0setup_ipk\commands.sh
echo echo ntpd -n -d -p s2g.time.edu.cn ^>^> /etc/rc.local>> %~dp0setup_ipk\commands.sh
echo echo exit 0 ^>^> /etc/rc.local>> %~dp0setup_ipk\commands.sh
echo echo 01 06 * * 1-5 killall scutclient ^> /etc/crontabs/root>> %~dp0setup_ipk\commands.sh
echo echo 05 06 * * 1-5 scutclient %User% %Password% \^& ^>^> /etc/crontabs/root>> %~dp0setup_ipk\commands.sh
echo echo 00 12 * * 0-7 ntpd -n -d -p s2g.time.edu.cn ^>^> /etc/crontabs/root>> %~dp0setup_ipk\commands.sh
echo reboot>> %~dp0setup_ipk\commands.sh
echo.
echo ��ʾ���Ѿ�����commands.sh�ű�
pause
echo y|pscp -scp -P 22 -pw %routerPasswd%  -r ./setup_ipk root@192.168.1.1:/tmp/ | findstr 100% && echo OK || goto _FAIL
echo ��ʾ��׼����·��ִ��commands.sh�ű�
pause
echo y|plink -P 22 -pw %routerPasswd% root@192.168.1.1 "sed -i 's/\r//g;' /tmp/setup_ipk/commands.sh && chmod 755 /tmp/setup_ipk/commands.sh && /tmp/setup_ipk/commands.sh"
echo ��ʾ���Զ����óɹ��������ڰ�·������ԴȻ���ٲ���(����·��)���ȵ�������ҳ�ܷ��ʾʹ������������
echo �Ժ��ʺţ���ip,MAC�ȵ����������ʹ��%routerPasswd%����ҳ����Խ��в��ŵȵ�������ã����ű��Ѿ����ʹ��
pause
explorer  "http://192.168.1.1/cgi-bin/luci/admin/network/scutclient"
goto _EXIT

:_FAIL
echo ������·��û��ͨ������
echo 1.·��ûͨ��
echo 2.�������ˣ���������������
echo 3.·���ǻ���,���������Թص�����ű����ڣ�����·����3���Ӻ����¿�����ű�����
echo 4.����·�������벻��%routerPasswd%�������ֽ̳�����ר�����·��������Ϊ%routerPasswd%
echo 5.�������뻹���п���·�����Ĺ̼������⣬�����ֽ̳�ˢһ�ѹ̼����������ٽ�ͼȺ���ʡ�
pause
goto _EXITFAIL

:_EXIT
cd.>%~dp0setup_ipk\commands.sh
echo ��ʾ���Ѿ����������Ϣ
pause
echo ������������������ù��̣������Զ��ص������ߵ����������ٹص�Ҳ��
pause
exit

:_EXITFAIL
echo ��ʱ������ʧ���˳��ű�������·����3���Ӻ����¿�����ű����ԣ������޷�ִ���밴���ֽ̳���ͷ��ˢ�̼��취��ˢ�¹̼���
cd.>%~dp0setup_ipk\commands.sh
echo ��ʾ���Ѿ����������Ϣ
pause
exit