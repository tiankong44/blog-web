@echo off
color  1f
title 
set BatVersion=V16
rem ---------------------------------------------------------------------------------------------
rem    ��    �ߣ�penghong
rem    �ύʱ�䣺2020/6/30
rem    ��    ����V16
rem    ʹ�÷�Χ�����ڲ�ʹ��
rem    �����ص㣺
rem           ����windows���������ԣ�������Ƽ��󷽡�
rem           + С���������谲װ�����ᱡ������ɫ��
rem           + ���ܲ˵���������������ݣ�����Ч��
rem           + �û���Ϣ���ܴ洢������ȫ�����ɿ���
rem           + ��ɾ�Ĳ�������ͨ����ȫ�棬��רҵ��
rem           + �Զ����������ز��������㣬�����ɣ�
rem           + ��������Լ��Բ飬�����ܣ�����׼��
rem           + ҵ����ʳ�ͨ���裬�����٣�����Ч��
rem           + �û��������������������ʣ������֡�
rem
rem ---------------------------------------------------------------------------------------------
rem   2020/6/30 V16�汾����˵����
rem        * ����789�������Ľ����������������û�ʹ�üҿ�ʱ�޷�����VPN�����⡣
rem        - �Ż����·����ʾ���档
rem
rem   2020/6/17 V15�汾����˵����
rem        * ��Ҫ����һЩ������ʾ��Ϣ���Ա��û�����ͨ����ʾ��Ϣ���д���һ�������⡣
rem        - ����718������뱨����ʾ���������
rem        - ��������Ĭ��������ʾ�������������һ���Ͽ�ָ�
rem        - �˵��С��칫�Ż����ʡ������ɡ������¼���⡱��
rem ---------------------------------------------------------------------------------------------


setlocal DisableDelayedExpansion
set "ModeFile=%temp%\EsvpnRunMode.txt"
set "BatchPath=%~0"
set RunMode=1
set "VBSGetPrivileges=%temp%\EsvpnGetPrivileges.vbs"
setlocal EnableDelayedExpansion

net session >nul 2>&1
if %errorlevel% EQU 0 (
    cls
    goto Main
) else (
    call :logo
    goto GetPrivileges
)

:GetPrivileges
rem ��ȡ����ԱȨ��
echo Set UAC = CreateObject^("Shell.Application"^) >"%VBSGetPrivileges%"
echo args = "ELEV " >> "%VBSGetPrivileges%"
echo For Each strArg in WScript.Arguments >>"%VBSGetPrivileges%"
echo args = args ^& strArg ^& " "  >>"%VBSGetPrivileges%"
echo Next >> "%VBSGetPrivileges%"
echo args = "/c """ + "!batchPath!" + """ " + args >>"%VBSGetPrivileges%"
echo UAC.ShellExecute "%SystemRoot%\System32\cmd.exe", args, "", "runas", %RunMode% >>"%VBSGetPrivileges%"
"%SystemRoot%\System32\WScript.exe" "%VBSGetPrivileges%"
exit /B


:Main
rem �������
set "BatchPath=%~0"
set "BatehDir=%~dp0"
set "BatchName=%~nx0"

set TitleContent=��ӭʹ������VPN����������
set met=1
set debug=false

rem ͳ��ֵ
rem ######
set CountOk=0
set CountFailed=0
set MonitorCount=0
set MonitorCountFailed=1

rem ����ʱ���˵���������������
rem #######################################
set MenuTimer=5
set MonitorTimer=10
set ReConnTimer=10

set /a MonitorTimers=0

set BackSpace=

set "LinkLog=c:\link.log"
set "VpnLog=c:\vpn.log"
set ES001=c:\windows\2f63e707443b304d


title %TitleContent%

for /f "usebackq tokens=*" %%r in (`ver`) do set SysVer=%%r
echo �ű��汾��%BatVersion%
echo ϵͳ�汾��%SysVer%
goto MenuList


:MenuList
rem �˵��б�
reg add HKEY_CURRENT_USER\Console /v QuickEdit /t REG_DWORD /d 00000000 /f >nul
echo %SysVer% | findstr /R "6\.[0-3]" >nul
if %errorlevel% EQU 0 (
    echo.
    echo.
    echo                      %TitleContent%
    echo.
    echo     **********************************************************
    echo     *                            *                           *
    echo     *       O �Զ�VPN����        *       S �����¼��Ϣ      * 
    echo     *                            *                           *
    echo     *       D �Ͽ�VPN����        *       C �����¼��Ϣ      *  
    echo     *                            *                           *
    echo     *       H �����¼����       *       U ���ÿ�������      * 
    echo     *                            *                           *
    echo     **********************************************************
    echo.
    echo     ��ܰ��ʾ�� ��С���˴��ڣ�ʵ������������
    echo.
    <nul set /p="�밴��ѡ��%MenuTimer%����Զ�ѡ��O����"
    CHOICE /T %MenuTimer% /C ODHSCU /D O
    if errorlevel 6 goto SetStartup
    if errorlevel 5 goto ClearLogin
    if errorlevel 4 goto SaveLogin
    if errorlevel 3 goto ModifyHosts
    if errorlevel 2 goto Disconnect
    if errorlevel 1 goto Connection
    echo.
    echo.
) 

echo %SysVer% | findstr "10\.[0-3]" >nul
if %errorlevel% EQU 0 (
    echo.
    echo.
    echo                      %TitleContent%
    echo.
    echo     �������������������������������������Щ��������������������������������������Щ�������������������������������������
    echo     ��                 ��                   ��                  ��
    echo     ��  F �鿴VPN����  ��  O �Զ�����VPN �� ��  S �����¼��Ϣ  �� 
    echo     ��                 ��                   ��                  ��
    echo     ��  A ���VPN����  ��  D �Ͽ�����VPN    ��  C �����¼��Ϣ  ��  
    echo     ��                 ��                   ��                  ��
    echo     ��  R ɾ��VPN����  ��  H �����¼����   ��  U ���ÿ�������  �� 
    echo     ��                 ��                   ��                  ��
    echo     �������������������������������������ة��������������������������������������ة�������������������������������������
    echo.
    echo     ��ܰ��ʾ�� ��С���˴��ڣ�ʵ������������
    echo.
    <nul set /p="�밴��ѡ��%MenuTimer%����Զ�ѡ��O����"
    CHOICE /T %MenuTimer% /C FARODHSCU /D O
    if errorlevel 9 goto SetStartup
    if errorlevel 8 goto ClearLogin
    if errorlevel 7 goto SaveLogin
    if errorlevel 6 goto ModifyHosts
    if errorlevel 5 goto Disconnect
    if errorlevel 4 goto Connection
    if errorlevel 3 goto RemoveVpn
    if errorlevel 2 goto AddVpn
    if errorlevel 1 goto FindVpn
    echo.
    echo.
) else (
    <nul set /p=����ϵͳ��֧�֣��밴������˳���
    pause >nul
    exit
)




:GetPasswd
set VpnName=
set VpnUser=
set VpnPassword=

IF EXIST %ES001% (
    FOR /F "usebackq tokens=1,2,3* delims=:" %%A in (%ES001%) do (
        set VpnName=%%A
        set VpnUser=%%B
        set VpnPassword=%%C
    )
) else (
    <nul set /p=��ʾ���޷�����VPN�����ȡ������¼��Ϣ���������������ת���������¼��Ϣ���˵�...
    pause >nul
    goto SaveLogin
)
goto :eof



:FindVpn
rem �鿴VPN����
echo.
call :SubTitle �鿴VPN����
call :GetVpnConnection
echo.
goto MenuList

:GetVpnConnection
<nul set /p=���ڻ�ȡϵͳ�����е�VPN...
echo.
echo.
echo %SysVer% | findstr "6\.[0-3]" >nul
if %errorlevel% EQU 0 (
    echo ����㻹δ��ӣ�������VPN���ӣ�Win7/8�û�����ֻ�������APP��Ӧ�á�VPN��������Ӧ�Ľ̳�����ӣ�������VPN���ӡ�
    echo.
    <nul set /p=��ϵͳ�ݲ�֧���Զ���ȡVPN���������ƣ�����������򿪡��������������ڡ����鿴���������ơ���
    pause
    ncpa.cpl
    goto :eof
)

set "psCommand=powershell -Command "$findvpn = Get-VpnConnection -AllUserConnection; $findvpn.name"
%psCommand% >%temp%\vpnlist.txt
echo �Ѵ��ڵ�VPN���ӣ��������ƣ�
echo -----------------------------------
type %temp%\vpnlist.txt
echo -----------------------------------
goto :eof


:AddVpn
rem  ��� VPN ����
set VpnName=
set VpnAddr=
set VpnKey=
echo.
call :SubTitle ���VPN����
echo.
echo ��ʾ:
echo     + win7,win8�û����������ֻ�APP��Ӧ�á�VPN���ж�Ӧ�̳̲��������VPN��
echo.
echo ��ʹ������Ĭ��ֵ����ֱ�Ӱ��س�����
echo.
echo     �������ƣ�ESVPN
echo     ��������ַ��vpn.teamshub.com
echo     Ԥ������Կ��vpn
echo.
call :GetVpnConnection
echo.
set /P VpnName=�������������ƣ�
if "x%VpnName%" == "x" set VpnName=ESVPN
echo         ��%VpnName%��

set /P VpnAddr=�������������ַ��
if "x%VpnAddr%" == "x"  set VpnAddr=vpn.teamshub.com
echo         ��%VpnAddr%��


set /P VpnKey=������Ԥ������Կ��
if "x%VpnKey%" == "x"  set VpnKey=vpn
echo         ��%VpnKey%��
echo.
echo ��ʾ��
echo     + һЩ��ȫ������а�ȫ��ʾ����������ȫ������/���������
echo     + ����ʾ��ɫ���������ļ��Ѵ���ʱ���޷��������ļ�����˵���Ѵ��� %VpnName% ���ӣ���ɾ�����Ӻ�����ӡ�
echo     + ����ʾ��ɫ�����ľ�����ʾ������ԡ�
echo.
echo.
echo ������� %VpnName% ����...
set "psCommand=powershell -Command "$vpninfo = Add-VpnConnection -Name '%VpnName%' -ServerAddress '%VpnAddr%' -TunnelType L2TP -L2tpPsk '%VpnKey%' -Force -AuthenticationMethod PAP,CHAP -UseWinlogonCredential $True -SplitTunneling $True -EncryptionLevel 'Optional' -PassThru; $vpninfo""
%psCommand%
call :GetVpnConnection
echo.
pause
goto MenuList


:RemoveVpn
rem ɾ�� VPN ����
set VpnName=
echo.
call :SubTitle ɾ��VPN����
echo ��ѡ�ɾ��һ��VPN���ӡ�
echo.
call :GetVpnConnection
echo.
set /P VpnName=�������������ƣ�
if "x%VpnName%" == "x" (
    <nul set /p=��ʾ�����������������Ϊ�գ�
    pause
    goto MenuList
)
echo ���ڶϿ����� %VpnName%...
rasdial "%VpnName%" /DISCONNECT
set "psCommand=powershell -Command "$vpninfo = Remove-VpnConnection -AllUserConnection -Name '%VpnName%' -Confirm; $vpninfo""
%psCommand%
echo.
call :GetVpnConnection
echo.
pause
goto MenuList


:Connection
rem ����VPN����
echo.
call :SubTitle �Զ�����VPN
ipconfig /flushdns >nul
call :GetPasswd

if "x%VpnName%" == "x" (
    <nul set /p=��ʾ��VPN��������Ϊ�գ��޷��Զ����ӣ����ȡ������¼��Ϣ���������������ת���������¼��Ϣ���˵�...
    pause >nul
    goto SaveLogin
)

if "x%VpnName%x" == "x x" (
    <nul set /p=��ʾ��VPN��������Ϊ�գ��޷��Զ����ӣ����ȡ������¼��Ϣ���������������ת���������¼��Ϣ���˵�...
    pause >nul
    goto SaveLogin
)

if "x%VpnUser%" == "x" (
    <nul set /p=��ʾ��VPN�û���Ϊ�գ��޷��Զ����ӣ����ȡ������¼��Ϣ���������������ת���������¼��Ϣ���˵�...
    pause >nul
    goto SaveLogin
)
if "x%VpnUser%" == "xUSER" (
    echo �����桿VPN�û���Ϊ�գ��޷��Զ����ӣ������ֶ�����%VpnName%��
)

if "x%VpnPassword%" == "x" (
    <nul set /p=��ʾ��VPN����Ϊ�գ��޷��Զ����ӣ����ȡ������¼��Ϣ���������������ת���������¼��Ϣ���˵�...
    pause >nul
    goto SaveLogin
)
if "x%VpnPassword%" == "xPASSWORD" (
    echo �����桿VPN����Ϊ�գ��޷��Զ����ӣ������ֶ�����%VpnName%��
)
echo.
echo �������ƣ�%VpnName%
echo �û�����%VpnUser%
echo ���룺********
echo.
echo �����ύVPN���ӣ����Ե�...
set VpnPassword=%VpnPassword:~5%
if "x%errorid%" == "x0000" (
    echo ���Ѿ����ӵ� %VpnName%
    <nul set /p=���ڼ�� %VpnName% ���ӣ���⵽�Ͽ����Զ��������Ѽ��%MonitorTimers%�롣�ɰ�E���˳���ء�
    goto MonitorVPN
)
if "x%errorid%" == "x0001" (
    echo ���Ѿ����ӵ� %VpnName%
    <nul set /p=���ڼ�� %VpnName% ���ӣ���⵽�Ͽ����Զ��������Ѽ��%MonitorTimers%�롣�ɰ�E���˳���ء�
    goto MonitorVPN
)
rasdial "%VpnName%" "%VpnUser%" "%VpnPassword:~0,4%%VpnPassword:~9%" >%LinkLog%
for /f "usebackq tokens=1,2,3,4,5*" %%A in (%LinkLog%) do (
    if "x%%A" == "x������" (
        echo %%A %%B %%C
        SET /A CountOk=%CountOk%+1
        call :GetVpnIfIndex
        call :GetIP
        call :SetRoute
        call :SetMetric
        set errorid=0000
        call :SuccessLink
    )

    if "x%%A" == "x���Ѿ����ӵ�" (
        echo %%A %%B %%C
        call :GetVpnIfIndex
        call :GetIP
        call :SetRoute
        call :SetMetric
        set errorid=0001
        call :SuccessLink
    )

    if "x%%A" == "x���Ѿ����ӵ�" (
        echo %%A %%B %%C
        call :GetVpnIfIndex
        call :GetIP
        call :SetRoute
        call :SetMetric
        set errorid=0001
        call :SuccessLink
    )

    if "x%%A" == "xԶ�̷��ʴ���" (
        set errorid=%%B
        SET /A CountFailed=%CountFailed%+1
        echo %%A %%B %%C %%D %%E
        TIMEOUT /T 2 /NOBREAK >nul
        call :QA
    )
    echo %%A %%B %%C
)
goto MenuList


:Disconnect
rem �Ͽ�����VPN
echo.
call :SubTitle �Ͽ�����VPN
call :GetPasswd
echo ���ڶϿ� %VpnName% ����...
rasdial "%VpnName%" /DISCONNECT
TIMEOUT /T 2 /NOBREAK >nul
goto MenuList


:SetStartup
echo.
call :SubTitle ���ÿ�������
echo.
echo ��ʾ��
echo     + һЩ��ȫ������а�ȫ��ʾ����������ȫ������/���������
echo.
set "Startups=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\����VPN����������.bat"
rem echo "%0" "%Startup%"
if NOT EXIST "%BatchPath%" (
    <nul set /p=��ʾ����ȡ�ű�%BatchPath%ʧ�ܣ���رմ��������ԡ�
    pause
    goto MenuList
)
copy /Y "%BatchPath%" "%Startups%" >nul
if %errorlevel% EQU 0 (
    echo [+] %BatchPath%�ļ��Ѹ��Ƶ�%Startups%
    <nul set /p=���ÿ��������ɹ���
    pause
) else ( 
    <nul set /p=��ʾ�����ÿ�������ʧ�ܣ���رմ��������ԡ�
    pause
)
echo.
goto MenuList


:ModifyHosts
echo.
call :SubTitle �����¼����
call :GetPasswd
echo.
echo ��ѡ����԰�����������������������Ż��޷���¼���޷����ʲ��ְ칫��ҳ�����⡣
echo.
echo.
echo ��ʾ��
echo     + һЩ��ȫ������а�ȫ��ʾ����������ȫ������/���������
echo     + ��ѡ���hosts�ļ���׷�������������ݡ�
echo.
netsh interface ip show interface interface="%VpnName%" >nul
if %errorlevel% NEQ 0 (
    <nul set /p=��ʾ���� %VpnName% ���ӳɹ�����ʹ�ô˹��ܡ�
    pause
    goto MenuList
)
<nul set /p=�����޸�HOSTS�ļ�...
echo.
set HostsFile=C:\Windows\system32\drivers\etc\hosts
if NOT EXIST %HostsFile% (
    <nul set /p=%HostsFile%�ļ������ڣ�
    pause
    goto MenuList
)
attrib -r C:\Windows\system32\drivers\etc\hosts
call :ModifyHostsContent 172.18.48.118 eip.teamshub.com
call :ModifyHostsContent 172.18.48.119 sso.teamshub.com
rem call :ModifyHostsContent 172.18.194.160 partner-ehr.si-tech.cn
rem call :ModifyHostsContent 172.18.193.172 partner-ehr.si-tech.cn
echo.
echo ��������������������ֱ�Ӱ��س���������
echo.
set /P DomainContents=����������������
if "x%DomainContents%" == "x" (
    <nul set /p=���������޸�HOSTS�ļ���ɣ�
    pause
    goto MenuList
)
ping -n 1 %DomainContents% >nul
if %errorlevel% NEQ 0 (
    echo �����޷�����������������ԡ�
    <nul set /p=���������޸�HOSTS�ļ���ɣ�
    pause
    goto MenuList
)
for /f "skip=1 usebackq tokens=2" %%a in (`nslookup %DomainContents% 172.16.9.60 ^| find "Address"`) do set DomainIp=%%a
echo %DomainContents%����ϵͳ�Զ�������������ο�����%DomainIp%
echo.
set /P IPContents=����������������Ӧ��IP��ַ��
if "x%IPContents%" == "x" (
    <nul set /p=���������޸�HOSTS�ļ���ɣ�
    pause
    goto MenuList
)
ping -n 1 %IPContents% >nul
if %errorlevel% NEQ 0 (
    echo IP��ַͨ��ʧ�ܣ�����������ԡ�
    <nul set /p=���������޸�HOSTS�ļ���ɣ�
    pause
    goto MenuList
)
call :ModifyHostsContent %IPContents% %DomainContents%
attrib +r C:\Windows\system32\drivers\etc\hosts
echo.
<nul set /p=�޸�HOSTS�ļ���ɣ�
pause
goto MenuList


:ModifyHostsContent
type "%HostsFile%" | findstr /R "^[0-9]" | find "%1 %2" >nul
if %errorlevel% NEQ 0 (
    echo [+] %1 %2
    echo.>>%HostsFile%
    echo %1 %2 >>%HostsFile%
) else (
    echo [��] %1 %2
)
goto :eof


:SaveLogin
rem �����¼��Ϣ
set VpnName=
set VpnUser=
set VpnPassword=
echo.
call :SubTitle �����¼��Ϣ
echo ��ѡ��������VPN�������ƣ��û��������롣�����Զ�����/�Ͽ�������
echo.
echo ��ʾ��
echo     + �������ƣ�����������������½�wifi�����ͼ�꣬VPN���Ӵ���ʾ�����ơ�
echo     + �û��������루ѡ�����д�û��������룬����ʵ���Զ����ӺͶϿ��Զ�������
echo.
echo.
call :GetVpnConnection
echo.
set /P VpnName=�������������ƣ�
if "x%VpnName%" == "x" (
    <nul set /p=��ʾ�����������������Ϊ�գ��밴����������ز˵�...
    pause >nul
    goto MenuList
)
set /P VpnUser=�������û�����
if "x%VpnUser%" == "x" (
    <nul set /p=��ʾ����������û���Ϊ�գ�������������ز˵�...
    pause >nul
    goto MenuList
)

echo %SysVer% | findstr /R "6\.[0-3]" >nul
if %errorlevel% EQU 0 (
    set /P VpnPassword=���������룺
)
echo %SysVer% | findstr /R "10\.[0-3]" >nul
if %errorlevel% EQU 0 (
    call :hidepasswd
)

if "x%VpnPassword%" == "x" (
    <nul set /p=��ʾ�������������Ϊ�գ�������������ز˵�...
    pause >nul
    goto MenuList
)

echo.
echo �㱣��ĵ�¼��Ϣ���������Զ�����/�Ͽ�������
echo �������ƣ�%VpnName%
echo �û�����%VpnUser%
echo ���룺********
echo.
set /A MD5=%random%*1239
set /A MD6=%random%*7574
rem set "salta=5550044.26673,249987778889"
rem set "saltb=EwX0#kPoDO$cAdKe1_2GaMPeT"
rem echo %VpnName%:%VpnUser%:%MD5:~0,5%%salta%%VpnPassword:~0,4%%MD6:~0,5%%saltb%%VpnPassword:~4% >%ES001%
echo %VpnName%:%VpnUser%:%MD5:~0,5%%VpnPassword:~0,4%%MD6:~0,5%%VpnPassword:~4% >%ES001%
<nul set /p=�ѱ����¼��Ϣ��
pause
echo.
goto MenuList


:ClearLogin
rem �����¼��Ϣ
echo.
call :SubTitle �����¼��Ϣ
echo.
echo ��ʾ�������¼��Ϣ���޷��ָ���
echo.
echo :: >%ES001%
<nul set /p=�������¼��Ϣ��
pause
goto MenuList


:Man
rem ʹ�ð���˵��
echo.
call :SubTitle ʹ�ð���˵��
echo.   
echo       F �鿴VPN����    O �Զ�����VPN    S �����¼��Ϣ  
echo.
echo       A ���VPN����    D �Ͽ�����VPN      C �����¼��Ϣ 
echo.
echo       R ɾ��VPN����    H �����¼����     U ���ÿ������� 
echo.
echo     �����ص㣺
echo         ����windows���������ԣ�Դ��win-route-v12��������Ƽ��󷽡�
echo         + С���������谲װ�����ᱡ������ɫ��
echo         + ���ܲ˵���������������ݣ�����Ч��
echo         + �û���Ϣ���ܴ洢������ȫ�����ɿ���
echo         + ��ɾ�Ĳ�������ͨ����ȫ�棬��רҵ��
echo         + �Զ����������ز��������㣬�����ɣ�
echo         + ��������Լ��Բ飬�����ܣ�����׼��
echo         + ҵ����ʳ�ͨ���裬�����٣�����Ч��
echo         + ʹ��ָ��������飬����Я����ʵ�á�
echo.
echo     �鿴VPN���ӣ��鿴��ǰϵͳ�����е�VPN���ӡ�
echo     ���VPN���ӣ��ڵ�ǰϵͳ�����һ��ָ����VPN���ӡ�
echo     ɾ��VPN���ӣ��ڵ�ǰϵͳ��ɾ��һ��ָ����VPN���ӡ�
echo     �Զ�VPN���ӣ��Զ�����VPN���Ͽ��Զ��������Ͽ��Զ�������ǰ�����������ڳ��������ڼ�����ʾ���档
echo     �Ͽ�VPN���ӣ��ڵ�ǰϵͳ�϶Ͽ�һ��ָ����VPN���ӡ�
echo     ���ñ���DNS��������������������hosts�ļ��С�
echo     �����¼��Ϣ�������ϵͳ�ϱ���VPN�������ơ��û�����������Ϣ�������Զ�VPN���ӡ��Ͽ��Զ�������
echo     �����¼��Ϣ������ѱ����VPN�������ơ��û�����������Ϣ��
echo     ���ÿ������������ÿ����������������ߣ���ȡ��������������Ҫ�����ֶ�ȡ����
echo.
<nul set /p=����ʹ��˵�������ڴ���
pause
goto MenuList


:SubTitle
echo %SysVer% | findstr /R "6\.[0-3]" >nul
if %errorlevel% EQU 0 (
echo.
echo     **********************************************************
echo                             %1                     
echo     **********************************************************
echo.
goto :eof
)
echo %SysVer% | findstr /R "10\.[0-3]" >nul
if %errorlevel% EQU 0 (
echo.
echo     ��������������������������������������������������������������������������������������������������������������������
echo                             %1                     
echo     ��������������������������������������������������������������������������������������������������������������������
echo.
goto :eof
)
echo.
echo     ----------------------------------------------------------
echo                             %1                     
echo     ----------------------------------------------------------
echo.
goto :eof


:VpnConnStatus
rem ��ȡVPN����״̬
netsh interface ip show interface interface="%VpnName%" >nul
if %errorlevel% equ 0 (
    set %1=ok
) else (
    set %1=failed
)
goto :eof



rem ##########
:hidepasswd
rem ����������ʾ
set "psCommand=powershell -Command "$pword = read-host '����������' -AsSecureString ; ^
        $BSTR=[System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($pword); ^
            [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)""
for /f "usebackq delims=" %%p in (`%psCommand%`) do set password=%%p
set VpnPassword=%password%
goto :eof


rem ��ȡVPN����������
rem #################
:GetVpnIfIndex
for /f "usebackq tokens=1,2,3" %%a in (`netsh interface ip show interface "%VpnName%" ^| find "IfIndex"`) do set IfIndex=%%c
if "x%IfIndex%" == "x" (
    <nul set /p=��ʾ��%VpnName% ���ӵ�������Ϊ�գ��޷��������ã�
    pause
    goto MenuList
) else (
    echo %VpnName% ���ӵ������ţ�%IfIndex%
    goto :eof
)
goto :eof

rem ��ȡVPN��IP��ַ
rem ###############
:GetIP
call :IpConnStatus IpReturn IpAddr
if "%debug%" == "true" echo [DEBUG] �ж��Ƿ�ѡ�ˡ���Զ��������ʹ��Ĭ�����ء��ķ���ֵ��%IpReturn%
if "%IpReturn%" == "yes" (
    echo .
    echo ��� %VpnName% ������Ҫȥ������Զ��������ʹ��Ĭ�����ء���ѡ���ã��ſ���ͬʱ������������
    echo .
    echo ȥ������Զ��������ʹ��Ĭ�����ء���ѡ���õĲ������裺
    echo    1�����п򣨰�win+R��ϼ���������ncpa.cpl�س���
    echo    2���򿪴��ں��ҵ�%VpnName%�����һ�����ѡ�����ԡ���
    echo    3�������ԶԻ�����ѡ�����硱����InternetЭ��汾4���������ԡ���
    echo    4����ѡ�񡰸߼�������IP���á���ȥ������Զ��������ʹ��Ĭ�����ء��Ĺ�ѡ��ȷ�ϼ��ɣ�
    echo .
    rasdial "%VpnName%" /DISCONNECT >nul
   <nul set /p=.
    pause
    goto MenuList
)
if "x%IpAddr%" == "x" (
    <nul set /p=��ʾ��%VpnName% ���ӵ�IP��ַΪ�գ��޷��������ã�
    pause
    goto MenuList
)
echo %IpAddr% | find "172.20." >nul
if %errorlevel% EQU 0 (
    echo %VpnName% ���ӵ�IP��ַ��%IpAddr%
) else (
    <nul set /p=��ʾ��%VpnName% ���ӵ�IP��ַ %IpAddr% ��Ч���޷��������ã�
    pause
    goto MenuList
)
goto :eof


rem ��VPN���·��
rem #############
:SetRoute
set GwAddr=1.0.0.1
echo %VpnName% ���ӵ�·�ɣ�
call :AddRoute 10.170.10.0 255.255.255.0
call :AddRoute 10.180.10.0 255.255.255.0
call :AddRoute 10.190.10.0 255.255.255.0
call :AddRoute 10.200.10.0 255.255.255.0
call :AddRoute 10.202.10.0 255.255.255.0
call :AddRoute 10.204.10.0 255.255.255.0
call :AddRoute 10.206.10.0 255.255.255.0
call :AddRoute 10.208.10.0 255.255.255.0
call :AddRoute 10.209.10.0 255.255.255.0
call :AddRoute 172.16.0.0  255.255.0.0
call :AddRoute 172.18.0.0  255.255.0.0
call :AddRoute 172.19.0.0  255.255.0.0
call :AddRoute 172.20.0.0  255.255.0.0
call :AddRoute 172.21.0.0  255.255.0.0
call :AddRoute 172.22.0.0  255.255.0.0
goto :eof


rem ���·������
rem ###########
:AddRoute
route print | findstr /R "%1.*%2.*%GwAddr%.*%IpAddr%" >nul
if %errorlevel% EQU 0 (
    echo     [��] %1 %2 �Ѵ��ڣ�
) else (
    <nul set /p=.   [��] %1 %2
    route ADD %1 MASK %2 %GwAddr% METRIC %met% IF %IfIndex%
)
goto :eof


rem ��VPN·�����ö���ֵ
rem ##################
:SetMetric
if "%debug%" == "true" echo [DEBUG]��%VpnName%���ӵ�������Ϊ%IfIndex%��metricΪ%met%��
netsh interface ip set interface "%IfIndex%" metric=%met% >nul
if %errorlevel% EQU 0 (
    echo %VpnName% ���ӵ�metricֵ��%met%
    echo %VpnName% �ѳɹ����Ӻ����á�
    goto :eof
) else (
    <nul set /p=��ʾ��%VpnName% ���ӵ�IfIndexֵ��Ч������metricʧ�ܣ�
    pause
    goto MenuList
)


:SuccessLink
if "x%errorid%" == "x0000" (
    call :PopupWindows �ѳɹ�����%VpnName%��
)
echo.
<nul set /p=���ڼ�� %VpnName% ���ӣ���⵽�Ͽ����Զ��������Ѽ��%MonitorTimers%�롣�ɰ�E���˳���ء�
goto MonitorVPN


:IpConnStatus
rem IP����״̬������ʶ�����޹�ѡĬ������
route print | findstr /R "172\.20\.0\.0.*1\.0\.0\.1" >nul
if %errorlevel% EQU 0 (
    set %1=no
    for /f "usebackq tokens=4" %%i in (`route print ^| findstr /R "172\.20\.0\.0.*1\.0\.0\.1"`) do set %2=%%i
) else (
    set %1=yes
)
goto :eof


:MonitorVPN
set /A MonitorCount=%MonitorCount%+1
netsh interface ip show interface "%VpnName%" >nul
if %errorlevel% EQU 0 (
    CHOICE /T %MonitorTimer% /C LE /D L /M "�밴��ѡ��" >nul
    if errorlevel 2 (
        call :RecordLog
        goto MenuList
    )
    if errorlevel 1 (
        set /a MonitorTimers=%MonitorTimers%+10
        <nul set /p=%BackSpace%���ڼ�� %VpnName% ���ӣ���⵽�Ͽ����Զ��������Ѽ��%MonitorTimers%�롣�ɰ�E���˳���ء�
        goto MonitorVPN
    )
) else (
    CHOICE /T 5 /C LE /D L /M "�밴��ѡ��" >nul
    if errorlevel 2 (
        call :RecordLog
        goto MenuList
    )
    if errorlevel 1 (
        echo.
        echo ��ص�%VpnName%�ѶϿ�����%MonitorCountFailed%������������...
        call :PopupWindows ��ص�VPN�ѶϿ�����%MonitorCountFailed%���Զ�����������...
        rem echo msgbox "������%VpnName%�ѶϿ�����%MonitorCountFailed%������������...",48,"����VPN����������" >C:\VpnAlert.vbs && start C:\VpnAlert.vbs
        set errorid=0003
        set /a MonitorCountFailed=%MonitorCountFailed%+1
        goto Connection
    )
)


:PopupWindows
rem ����msgbox
rem ��ʱͣ����������
set "PopupVbs=%temp%\EsvpnPopup.vbs"
echo Sub Print^(text,timeout,title^) >"%PopupVbs%"
echo     Dim WshShell >>"%PopupVbs%"
echo     Set WshShell = CreateObject^("WScript.Shell"^) >>"%PopupVbs%"
echo     WshShell.Popup text,timeout,title >>"%PopupVbs%"
echo     Set WshShell = nothing >>"%PopupVbs%"
echo End Sub >>"%PopupVbs%"
rem Print "������ʾ������",10,"�Ի�����10�����Զ��رգ�"
echo Print "%1%2%3%4",3,"����VPN����������" >>"%PopupVbs%"
start "%SystemRoot%\System32\WScript.exe" "%PopupVbs%"
goto :eof


:ReConnection
rem ����VPN
SET /A CountFailed=%CountFailed%+1
call :RecordLog >%VpnLog%
<nul set /p=%ReConnTimer%����Զ����� %VpnName% ���ӣ���%CountFailed%���������ɰ�L����������VPN����E���˳������ز˵���
CHOICE /T %ReConnTimer% /C LE /D L /M "�밴��ѡ��" >nul
echo.
if errorlevel 2 (
    call :RecordLog
    goto MenuList
)
if errorlevel 1 goto Connection


:RecordLog
echo.
echo.
echo ����ͳ�ƣ�
echo     �������ӣ�%MonitorCount% ��
echo     �ɹ����ӣ�%CountOk% ��
echo     ʧ�����ӣ�%CountFailed% ��
echo.
goto :eof


:QA
rem ������뱨����ʾ���
echo.
echo ���ڲ��� %errorid% ����Ľ������...
echo.
rem echo ��ʾ��
rem echo     + �ṩ�Ľ�����������ο�����Щ����������ܻ������ϵͳ�������������
rem echo     + ���������������� �� Ѱ�����ͬ��Э�������
rem echo     + ���γ�������VPNʧ�ܺ��ٵ���VPNʹ�ú����ⷴ����Ȧ���ﷴ��������ʱ���ṩ�������ʹ���������
rem echo     + ������ϴγɹ����ӹ����������Щ���������������������ĵ�����VPN���������粻����VPN�������쳣����Ĵ���

if "%errorid%" == "623" (
    echo ϵͳ�ϲ����ڡ�%VpnName%�����ӡ�
    echo. 
    echo �ο��������1��
    echo     ��д���������ƺ�ʵ�ʵ�VPN�������Ʋ�һ�������������ǵ����������½�wifi�����ͼ����VPN������ʾ�����ơ�
    echo. 
    echo �ο��������2��
    echo     win7,win8�û����԰��������ֻ�APP��Ӧ�á�VPN���н̳����һ��VPN���ӣ�
    echo     win10�û�����ʹ�á����VPN���ӡ��˵�����ӡ�
    echo.
    goto OtherHelp
)

if "%errorid%" == "691" (
    echo �ο��������1��
    echo     ��������ȷ�û��������롣����ѡ�񡰱����¼��Ϣ��ѡ�
    echo.
    echo �ο��������2��
    echo     �򿪡����񡱴���
    echo         ��win10��������IKE and AuthIP IPsec Keying Modules�����񣬲�����Ϊ�Զ���
    rem echo         ��win10��������Remote Access Connection Manager�����񣬲�����Ϊ�Զ���
    echo.
    goto OtherHelp
)

if "%errorid%" == "703" (
    echo �ο��������1��
    echo     �ڡ���ȫ��ѡ��У�
    echo         1��VPN������ѡ��ʹ��IPsec�ĵڶ������Э�飨L2TP/IPsec������
    echo         2�����ݼ�����ѡ�񡰿�ѡ���ܣ�û�м���Ҳ�������ӣ�����
    echo         3����ѡ������ʹ����ЩЭ�顱��
    echo         4����ѡ��δ���ܵ����루PAP������
    echo         5����ѡ����ѯ���������֤Э�飨CHAP������
    echo.
    goto OtherHelp
)

rem ����ʱ��2020-06-16����Դ���û�������
if "%errorid%" == "718" (
    echo �ο��������1��
    echo     �������ӵ�VPN�������������쳣���뱣�ֽű����״̬�������Զ���������ֱ�����ӳɹ���
    echo.
    goto OtherHelp
)

if "%errorid%" == "720" (
    echo ע�⣺��Щ���Ŀ��ܻ������ϵͳ��win7�û������������
    echo.
    echo �ο��������1��
    echo     ��win10�����԰��豸�������е������������¡�wan ΢�Ͷ˿ڣ�IP����ж�غ����������ԡ�
    echo.
    echo �ο��������2��
    echo     ��win10�����԰��豸�������е������������¡�wan ΢�Ͷ˿ڣ�XXX������ж�غ����������ԡ�
    echo.
    goto OtherHelp
)

if "%errorid%" == "789" (
    rem ################################################################################
    rem ���� 789��L2TP���ӳ���ʧ�ܣ���Ϊ��ȫ���ڳ�ʼ����Զ�̼������Э��ʱ������һ���������
    rem https://support.microsoft.com/zh-cn/help/926179/how-to-configure-an-l2tp-ipsec-server-behind-a-nat-t-device-in-windows  
    rem ################################################################################
    echo �ο��������1��
    echo     �򿪡����񡱴��ڣ����п�������services.msc�س���
    echo          ��win10���ҵ�IKEEXT (IKE and AuthIP IPsec Keying Modules�����񣬽�������Ϊ�Զ�������������
    echo.
    echo �ο��������2��
    echo     ����ʹ������ֻ��ȵ��ʹ����һ���ֻ��ȵ㣬�ٽ���VPN���ӡ�
    echo.
    call :RunReg789
    echo.
    goto OtherHelp
)

if "%errorid%" == "809" (
    rem ################################################################################
    rem ���� 809���޷������������ VPN ������֮����������ӣ���ΪԶ�̷�����δ��Ӧ��
    rem ���������Ϊδ���������Զ�̷�����֮���ĳ�������豸�������ǽ��NAT��·�����ȣ�����Ϊ���� VPN ���ӡ�
    rem �������Ա������ṩ����ϵ��ȷ�������豸���ܲ��������⡣
    rem https://superuser.com/questions/1481394/windows-10-l2tp-vpn-connection-issue
    rem �����������������NAT�豸���棬Ȼ��ʹ��IPsec NAT-T�����������ͨ������VPN�ͻ��˼������VPN�������ϵ�ע���ֵ������ͨ�š�
    rem ################################################################################
    echo �ο��������1��
    echo     ����������һ������������
    echo.
    echo �ο��������2��
    echo     �����������տ�����������лָ�ʱ����ȴ���̨ϵͳ����������ɣ�������VPN��
    echo.
    goto OtherHelp
)

if "%errorid%" == "868" (
    echo �ο��������1��
    echo     �������ӻ�������������VPN��
    echo.
    rem echo �ο��������2��
    rem echo     �޸�DNS��������ַ�����Ըĳ�114.114.114.114
    rem echo.
    rem echo �ο��������3��
    rem echo     �ֱ��Խ�vpn.teamshub.com������ַ����Ϊ����IP��ַ֮һ��
    rem echo         219.143.121.34 ����
    rem echo         219.143.121.35 ����
    rem echo         223.70.245.113 �ƶ�
    rem echo         223.70.245.114 �ƶ�
    rem echo         114.255.113.5  ��ͨ
    rem echo         114.255.113.6  ��ͨ
    rem echo.
    goto OtherHelp
)

echo ���޸�%errorid%�������Ĳο����������
goto OtherHelp


:OtherHelp
echo �����ԣ�
echo     1����ѯ�ܱ�ͬ�»����Э�������
echo     2���ٶ���������ؼ��������Ų�����
echo     3��������APP��VPNʹ�ú����ⷴ����Ȧ�ӷ������⣨���ṩϵͳ�汾��������롢����������������������
echo     4��ֱ�ӷ������ͷ���Ա��
rem echo     4������https://documentation.meraki.com/MX/Client_VPN/Troubleshooting_Client_VPN#Windows_Error_809
rem echo     5������https://github.com/hwdsl2/setup-ipsec-vpn/blob/master/docs/clients-zh.md#windows-%E9%94%99%E8%AF%AF-809
echo.
goto ReConnection


:RunReg789
echo ���ڳ����Զ��޸������⣺
<nul set /p=��1���޸�ע���AllowL2TPWeakCryptoֵΪ0x1��
REG ADD HKLM\SYSTEM\CurrentControlSet\Services\RasMan\Parameters /v AllowL2TPWeakCrypto /t REG_DWORD /d 0x1 /f
<nul set /p=��2���޸�ע���ProhibitIpSecֵΪ0x1��
REG ADD HKLM\SYSTEM\CurrentControlSet\Services\RasMan\Parameters /v ProhibitIpSec /t REG_DWORD /d 0x1 /f
echo.
echo �������޸������������ԣ������ӣ�
pause >nul
echo �������޸������������ԣ������ӣ�
pause >nul
echo �������޸������������ԣ������ӣ�
pause >nul
goto :eof

:RunReg809
REG QUERY HKLM\SYSTEM\CurrentControlSet\Services\PolicyAgent /v AssumeUDPEncapsulationContextOnSendRule 2>nul 1>nul
if %errorlevel% EQU 0 (
    for /f "usebackq tokens=3" %%i in (`REG QUERY HKLM\SYSTEM\CurrentControlSet\Services\PolicyAgent /v AssumeUDPEncapsulationContextOnSendRule`) do (
        if "%%i" == "0x0" (
            <nul set /p=�޸�ע���AssumeUDPEncapsulationContextOnSendRuleֵΪ0x1��
            REG ADD HKLM\SYSTEM\CurrentControlSet\Services\RasMan\Parameters /v AssumeUDPEncapsulationContextOnSendRule /t REG_DWORD /d 0x1 /f
        )
    )
) else (
     echo ע���ProhibitIpSecֵ�����ڣ�
     rem REG ADD HKLM\SYSTEM\CurrentControlSet\Services\PolicyAgent /v AssumeUDPEncapsulationContextOnSendRule /t REG_DWORD /d 0x2 /f
)
goto :eof


:logo
echo.
echo                                                                `$$$:           
echo                                                            '$$$$$$:            
echo                                                        .$$$$$$$$$.             
echo                                                     .$$$$$$$$$$'               
echo                                                   '$$$$$$$$$$$`                
echo                                                 $$$$$$$$$$$$$`                 
echo                                               :$$$$$$$$$$$$$`                  
echo                                             '$$$$$$$$$$$$$$'                   
echo                                           .$$$$$$$$$$$$$$$:                    
echo                                          `$$$$$$$$$$$$$$$$.                    
echo                                         '$$$$$$$$$$$$$$$$'                     
echo                                        '$$$$$$$$$$$$$$$:                    $$ 
echo                                       `$$$$$$`                          .$$$$$.
echo                                      .$$$'                      .`:$$$$$$$$$$` 
echo                                                            '$$$$$$$$$$$$$$$$`  
echo                                                           `$$$$$$$$$$$$$$$$`   
echo                                                           $$$$$$$$$$$$$$$$.    
echo                                                          :$$$$$$$$$$$$$$'      
echo                                                         :$$$$$$$$$$$$$$        
echo                                                        '$$$$$$$$$$$$$.         
echo                                                       :$$$$$$$$$$$$.           
echo                                                      $$$$$$$$$$$:              
echo                                                    `$$$$$$$$$$.                
echo                                                   :$$$$$$$:                    
echo                                                 `$$$$$:                        
echo                                                  `.                                                                                                                   
echo.
<nul set /p=��������...
TIMEOUT /T 2 /NOBREAK >nul
cls
rem TIMEOUT /T 2 /NOBREAK >nul
goto :eof



:TestExample
rem start /B iexplore eip.teamshub.com
rem start notepad "%BatchPath%"

rem ������ʾ1��
rem     ���Ѿ����ӵ� ESVPN��
rem     ��������ɡ�

rem ������ʾ2��
rem     �������ӵ� ESVPN...
rem     ������֤�û���������...
rem     ����������ע����ļ����...
rem     ������ ESVPN��
rem     ��������ɡ�

rem ������ʾ3��
rem     �������ӵ� ESVPN...
rem     ������֤�û���������...
rem     
rem     Զ�̷��ʴ��� 691 �Ѿܾ�Զ�����ӣ���Ϊδʶ������ṩ���û�����������ϣ�����Զ�̷��ʷ������Ͻ�ֹʹ��ѡ���������֤Э�顣