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
echo ��ʾ��׼��telnet·�ɿ�ͨSSH���������Ϊadmin,�������FATAL ERROR: Network error: Connection refused Ҳ�������
pause
type telnet.scut|plink -telnet root@192.168.1.1
echo.
echo ��ʾ��׼������setup_ipk�ļ��е�·�ɵ�/tmp/����
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
pause
echo �������Ժ󣬿���ʹ�����������http://192.168.1.1��ʹ������%routerPasswd%��¼·����ҳ�������������������л����ġ�
echo ������������������ù��̣������Զ��ص������ߵ����������ٹص�Ҳ��
pause
exit

:_EXITFAIL
echo ��ʱ������ʧ���˳��ű�������·����3���Ӻ����¿�����ű����ԣ������޷�ִ���밴���ֽ̳���ͷ��ˢ�̼��취��ˢ�¹̼���
pause
exit

:_EXITNOTFOUND
echo ���ɲ���init.scut�ű��ļ����п��ܱ�ɱ�����ɱ������رջ�ж��ɱ���������һ�飬��������У����Ի����������ԡ�
pause
exit