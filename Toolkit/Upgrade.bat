@echo off & setlocal enabledelayedexpansion
color 4A
TITLE һ��ˢ�̼��ű�  --����·������ʽȺ��Ʒ
set routerPasswd=admin
pushd "%CD%"
CD /D "%~dp0"
echo ���������������������������������
echo ����������������������������������������������
echo ��������������������������������������
echo ��������������������������������������������
echo ���������������������������������������������
echo ����������������������������������������
echo �����������������������������������������������
echo ��������������������������������������������
echo �������������������������������������������
echo ���������������������������������������������
echo �������������������������������������������
echo ����������������������������������������������
echo �������������������������������������������
echo �����������������������������������
echo.&echo =========================================================
echo 	���ű���#����·������ʽȺ#�ṩ
echo 	ע�⣺��½·�����������Ϊ%routerPasswd%�������Ȼʧ��
echo.&echo =========================================================
echo.
echo ��ʾ���Ȱ�Ҫˢ�Ĺ̼���.bin��ʽ)�Ž�.Toolkit/upgrade_bin/�ļ���
echo ��ʾ���Ȱ�Ҫˢ�Ĺ̼���.bin��ʽ)�Ž�.Toolkit/upgrade_bin/�ļ���
echo ��ʾ���Ȱ�Ҫˢ�Ĺ̼���.bin��ʽ)�Ž�.Toolkit/upgrade_bin/�ļ���
echo ��ʾ���ýű���Ϊ����ˢ��̼��޷�ʹ�õ�����������̼�
echo ��ʾ���ýű���Ϊ����ˢ��̼��޷�ʹ�õ�����������̼�
echo ��ʾ���ýű���Ϊ����ˢ��̼��޷�ʹ�õ�����������̼�
echo ��ʾ����֤·��������ͨ��ִ�нű�
echo ��ʾ����֤·��������ͨ��ִ�нű�
echo ��ʾ����֤·��������ͨ��ִ�нű�
pause
:_PING
echo.
ping -a 192.168.1.1
IF %errorlevel% EQU 0 ( goto _OK ) else ( goto _FAIL )

:_OK
echo.
echo ��ʾ��׼������upgrade_bin�ļ��е�·�ɵ�/tmp/����
pause
echo y|pscp -scp -P 22 -pw %routerPasswd%  -r ./upgrade_bin root@192.168.1.1:/tmp/ | findstr 100% && echo OK || goto _FAIL
echo ��ʾ��׼����·��ִ�������̼�
pause
echo y|plink -P 22 -pw %routerPasswd% root@192.168.1.1 "sysupgrade -n /tmp/upgrade_bin/*.bin"
echo ��ʾ���������
echo Switching to ramdisk...
echo Performing system upgrade...
echo Unlocking firmware ...
echo   
echo Writing from <stdin> to firmware ...
echo Upgrade completed
echo Rebooting system...
echo ˵�������ɹ��ˣ�����ʧ��
pause
exit
:_FAIL 
echo ��ʾ���޷�����·��
pause
exit