@echo off & setlocal enabledelayedexpansion
color A1
TITLE һ��ͬ��·����ʱ��ű�  --����·������ʽȺ��Ʒ
set routerPasswd=admin
pushd "%CD%"
CD /D "%~dp0"
echo.&echo =========================================================
echo 	���ű���#����·������ʽȺ#�ṩ
echo 	ע�⣺��½·�����������Ϊ%routerPasswd%�������Ȼʧ��
echo.&echo =========================================================
echo.
echo ��ʾ���ű������������·�ɵ���������IP��DNSΪ�Զ���ã�������ɹ����Ǿ��Լ�������������Ϊ�Զ���ú��ٴ�ִ�иýű���
pause
call ChangeIP.bat 2
echo ��ʾ���Ѿ���������·�ɵ���������IP��DNSΪ�Զ����
pause
echo ��ʾ��׼����·��ִ������ʱ��ű�
pause
echo y|plink -P 22 -pw %routerPasswd% root@192.168.1.1 "date %date:~0,4%.%date:~5,2%.%date:~8,2%-%time:~0,8%"
echo ��ʾ�����û������ʾ���ȴ�·��������Ͼ�ִ�гɹ���
pause
exit