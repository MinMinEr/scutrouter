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
IF %errorlevel% EQU 0 ( goto _OK ) else ( goto NO_OPENWRT )
pause
:NO_OPENWRT
echo ��ϵͳ����Ϊ��OPENWRT�ٷ�ϵͳ�������ǲ�����OpenWrt�����������������˼���ִ�нű�������Ѿ�ȷ����OpenWrtϵͳ���Լ���
pause
echo.
ping -a 192.168.1.1
IF %errorlevel% EQU 0 ( goto _OK ) else ( goto _FAIL )

:_OK
echo.
echo ��ʾ��׼��telnet·�ɿ�ͨSSH���������Ϊ%routerPasswd%,�������FATAL ERROR: Network error: Connection refused Ҳ�������
pause
echo (echo %routerPasswd% ^&^& echo %routerPasswd%) ^> pass.log ^&^& (passwd ^< pass.log ^&^& rm -f pass.log) ^&^& exit > telnet.scut
type telnet.scut|plink -telnet root@192.168.1.1
cd.>telnet.scut
echo.
echo ��ʾ��׼������setup_ipk�ļ��е�·�ɵ�/tmp/����
pause
echo opkg remove luci-app-scutclient> %~dp0setup_ipk\init.scut
echo opkg remove scutclient>> %~dp0setup_ipk\init.scut
echo opkg install /tmp/setup_ipk/*.ipk>> %~dp0setup_ipk\init.scut
echo uci set system.@system[0].hostname='SCUT'>> %~dp0setup_ipk\init.scut
echo uci set system.@system[0].timezone='HKT-8'>> %~dp0setup_ipk\init.scut
echo uci set system.@system[0].zonename='Asia/Hong Kong'>> %~dp0setup_ipk\init.scut
echo uci set luci.languages.zh_cn='chinese'>> %~dp0setup_ipk\init.scut
echo uci set network.wan.proto='static'>> %~dp0setup_ipk\init.scut
echo uci set network.wan.dns='202.112.17.33 114.114.114.114'>> %~dp0setup_ipk\init.scut
echo uci set network.lan.ip6addr='2001:250:3000:::/48'>> %~dp0setup_ipk\init.scut
echo uci set wireless.@wifi-device[0].disabled='0'>> %~dp0setup_ipk\init.scut
echo uci set wireless.@wifi-iface[0].mode='ap'>> %~dp0setup_ipk\init.scut
echo uci set wireless.@wifi-iface[0].encryption='psk2'>> %~dp0setup_ipk\init.scut
echo uci set scutclient.@option[0].boot='0'>> %~dp0setup_ipk\init.scut
echo uci set scutclient.@option[0].enable='1'>> %~dp0setup_ipk\init.scut
echo uci set scutclient.@scutclient[0]='scutclient'>> %~dp0setup_ipk\init.scut
echo uci set dhcp.wan.ra='server'>> %~dp0setup_ipk\init.scut
echo uci set dhcp.wan.dhcpv6='server'>> %~dp0setup_ipk\init.scut
echo uci set dhcp.wan.ndp='relay'>> %~dp0setup_ipk\init.scut
echo uci set dhcp.wan.ra_management='1'>> %~dp0setup_ipk\init.scut
echo uci set dhcp.wan.ra_default='1'>> %~dp0setup_ipk\init.scut
echo uci del network.globals>> %~dp0setup_ipk\init.scut
echo uci commit>> %~dp0setup_ipk\init.scut
echo echo ip6tables -t nat -I POSTROUTING -s 2001:250:3000:::/48 -j MASQUERADE ^> /etc/firewall.user>> %~dp0setup_ipk\init.scut
echo echo 01 06 * * 1-5 killall scutclient ^> /etc/crontabs/root>> %~dp0setup_ipk\init.scut
echo echo 05 06 * * 1-5 scutclient \$\(uci get scutclient.@scutclient[0].username\) \$\(uci get scutclient.@scutclient[0].password\) \^& ^>^> /etc/crontabs/root>> %~dp0setup_ipk\init.scut
echo echo 00 12 * * 0-7 ntpd -n -d -p s2g.time.edu.cn ^>^> /etc/crontabs/root>> %~dp0setup_ipk\init.scut
echo reboot>> %~dp0setup_ipk\init.scut
echo.
echo ��ʾ���Ѿ�����init.scut�ű�
pause
echo y|pscp -scp -P 22 -pw %routerPasswd%  -r ./setup_ipk root@192.168.1.1:/tmp/ | findstr 100% && echo OK || goto _FAIL
echo ��ʾ��׼����·��ִ��init.scut�ű�
pause
echo y|plink -P 22 -pw %routerPasswd% root@192.168.1.1 "sed -i 's/\r//g;' /tmp/setup_ipk/init.scut && chmod 755 /tmp/setup_ipk/init.scut && /tmp/setup_ipk/init.scut"
echo ��ʾ���Զ����óɹ��������ڰ�·������ԴȻ���ٲ���(����·��)���ȵ�������ҳ�ܷ��ʾʹ������������
echo �Ժ��ʺţ���ip,MAC�ȵ����������ʹ��%routerPasswd%����ҳ����Խ��в��ŵȵ�������ã����ű��Ѿ����ʹ��
pause
explorer  "http://192.168.1.1/cgi-bin/luci/admin/scutclient"
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
cd.>%~dp0setup_ipk\init.scut
echo ��ʾ���Ѿ����������Ϣ
pause
echo ������������������ù��̣������Զ��ص������ߵ����������ٹص�Ҳ��
pause
exit

:_EXITFAIL
echo ��ʱ������ʧ���˳��ű�������·����3���Ӻ����¿�����ű����ԣ������޷�ִ���밴���ֽ̳���ͷ��ˢ�̼��취��ˢ�¹̼���
cd.>%~dp0setup_ipk\init.scut
echo ��ʾ���Ѿ����������Ϣ
pause
exit