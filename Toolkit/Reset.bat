@echo off & setlocal enabledelayedexpansion
color 1A
TITLE һ����ԭ·�����ű�  --����·������ʽȺ��Ʒ
set routerPasswd=admin
pushd "%CD%"
CD /D "%~dp0"
echo.&echo =========================================================
echo 	���ű���#����·������ʽȺ#�ṩ
echo 	ע�⣺��½·�����������Ϊ%routerPasswd%�������Ȼʧ��
echo.&echo =========================================================
echo.
echo ��ʾ���ű������������·�ɵ���������IP��DNSΪ�Զ����
pause
call ChangeIP.bat 2
echo ��ʾ���Ѿ���������·�ɵ���������IP��DNSΪ�Զ����
pause
echo ��ʾ��׼����·��ִ��!!!!!!��ԭ!!!!!!�ű�
echo ��ʾ��׼����·��ִ��!!!!!!��ԭ!!!!!!�ű�
echo ��ʾ��׼����·��ִ��!!!!!!��ԭ!!!!!!�ű�
pause
echo y|plink -P 22 -pw %routerPasswd% root@192.168.1.1 "firstboot"
echo ��ʾ�����û������ʾ���ȴ�·��������Ͼ�ִ�гɹ���
pause
exit