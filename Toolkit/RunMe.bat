@echo off & setlocal enabledelayedexpansion

set /A routerPasswd=admin

echo.&echo.
echo ���ű���#����·����Ⱥ#�ṩ
echo ע�⣺����Ĭ������Ϊ%routerPasswd%
echo.&echo.
echo ������ĳ�����Ϣ
set /p User=�����õ��û���  
set /p Password=�����õ�����  
set /p Key=���WIFI����  
:MAC_LOOP
echo.&echo.
set /A N=0
for /f "skip=1 tokens=1,* delims= " %%a in ('wmic nic where ^(adaptertype like "ethernet ___._" and netconnectionstatus^="2"^) get name^,macaddress') do ( if "%%b" == "" ( @echo off ) else (set /A N+=1&set _!N!MAC=%%a&call echo.[!N!] %%b %%a) )
set /A N+=1
echo [%N%] ���Ǳ��˵��ԣ���Ҫ������MAC��Ҫ��Ӣ��״̬���뷨���루��ʽ��д��ĸXX:XX:XX:XX:XX:XX)
echo.&echo.
set /p input=ѡ���㱾�˵��Ե���������:
IF %input% EQU %N% (goto DIY_MAC) ELSE (set MACaddress=!_%input%MAC! & goto MAC_END)
:DIY_MAC
set /p MACaddress=��д���ṩ��ѧУ��MAC��ַ  
:MAC_END
checkMAC.bat %MACaddress%|findstr error && goto MAC_LOOP || goto _MAC_OK
:_MAC_OK
set /p IPaddress=��дѧУ�����IP��ַ  
checkIP.bat %IPaddress%|findstr error && goto _MAC_OK || goto _IP_OK
:_IP_OK
set /p Mask=��дѧУ������������루MASK��  
checkIP.bat %Mask%|findstr error && goto _IP_OK || goto _MASK_OK
:_MASK_OK
set /p Gateway=��дѧУ��������ص�ַ  
checkIP.bat %Gateway%|findstr error && goto _IP_OK || goto _GATEWAY_OK
:_GATEWAY_OK
echo uci set system.@system[0].hostname=SCUT > commands.sh
echo uci set system.@system[0].timezone=HKT-8 >> commands.sh
echo uci set system.@system[0].zonename=Asia/Hong Kong >> commands.sh
echo uci set network.wan.macaddr=%MACaddress% >> commands.sh
echo uci set network.wan.proto=static >> commands.sh
echo uci set network.wan.ipaddr=%IPaddress%  >> commands.sh
echo uci set network.wan.netmask=%Mask%  >> commands.sh
echo uci set network.wan.gateway=%Gateway% >> commands.sh
echo uci set network.wan.dns=202.112.17.33 114.114.114.114 >> commands.sh
echo uci set wireless.@wifi-device[0].disabled=0  >> commands.sh
echo uci set wireless.@wifi-iface[0].mode=ap  >> commands.sh
echo uci set wireless.@wifi-iface[0].ssid=QQgroup:262939451   >> commands.sh
echo uci set wireless.@wifi-iface[0].encryption=psk2  >> commands.sh
echo uci set wireless.@wifi-iface[0].key=%Key%   >> commands.sh
echo uci commit  >> commands.sh
echo opkg install /tmp/setup_ipk/libpcap_1.3.0-1_ar71xx.ipk >> commands.sh
echo opkg install /tmp/setup_ipk/scutclient_1.3-1_ar71xx.ipk >> commands.sh
echo echo sleep 30 ^> /etc/rc.local >> commands.sh
echo echo scutclient %User% %Password% ^& ^> /etc/rc.local >> commands.sh
echo echo exit 0 ^> /etc/rc.local >> commands.sh
echo 01 06 * * 1-5 killall scutclient ^> /etc/crontabs/root >> commands.sh
echo 02 06 * * 1-5 scutclient %User% %Password% ^& ^> /etc/crontabs/root >> commands.sh
echo 00 12 * * 0-7 ntpd �Cn �Cd �Cp s2g.time.edu.cn ^> /etc/crontabs/root >> commands.sh
pause

echo ��ʾ����������·�ɵ���������IPΪ192.168.1.X
ChangeIP.bat 3
echo ��ʾ���Ѿ���������·�ɵ���������IPΪ192.168.1.X

:_PING
ping 192.168.1.1
IF %errorlevel% EQU 0 ( goto _CONTINUE ) else ( goto _FAIL )

:_CONTINUE

call telnet.vbs

echo y|pscp -scp -P 22 -pw admin  -r ./setup_ipk root@192.168.1.1:/tmp/ | findstr 100% && echo OK || echo NO

echo y|plink -m commands.sh -P 22 -pw admin root@192.168.1.1

goto _EXIT

:_FAIL
echo ������·��û��ͨ������
echo 1.·��ûͨ��
echo 2.�������ˣ���������������
echo 3.·���ǻ���
echo ��Ⱥ������
goto _EXIT

:_EXIT
echo.  > commands.sh
exit