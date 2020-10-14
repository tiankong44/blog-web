@echo off
color  1f
title 
set BatVersion=V16
rem ---------------------------------------------------------------------------------------------
rem    作    者：penghong
rem    提交时间：2020/6/30
rem    版    本：V16
rem    使用范围：仅内部使用
rem    功能特点：
rem           基于windows批处理语言，界面设计简洁大方。
rem           + 小巧玲珑无需安装，更轻薄，更绿色；
rem           + 功能菜单自助导航，更快捷，更高效；
rem           + 用户信息加密存储，更安全，更可靠；
rem           + 添删改查样样精通，更全面，更专业；
rem           + 自动连接闪断重拨，更方便，更轻松；
rem           + 错误故障自检自查，更智能，更精准；
rem           + 业务访问畅通无阻，更快速，更长效；
rem           + 用户操作信手拈来，更舒适，更快乐。
rem
rem ---------------------------------------------------------------------------------------------
rem   2020/6/30 V16版本更新说明：
rem        * 增加789错误代码的解决方案，解决部分用户使用家宽时无法连接VPN的问题。
rem        - 优化添加路由显示界面。
rem
rem   2020/6/17 V15版本更新说明：
rem        * 主要增加一些操作提示信息，以便用户可以通过提示信息自行处理一部分问题。
rem        - 增加718错误代码报错提示解决方法；
rem        - 增加配置默认网关提示操作方法，添加一条断开指令；
rem        - 菜单中“办公门户访问”更名成“解决登录问题”；
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
rem 获取管理员权限
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
rem 程序入口
set "BatchPath=%~0"
set "BatehDir=%~dp0"
set "BatchName=%~nx0"

set TitleContent=欢迎使用易信VPN辅助连接器
set met=1
set debug=false

rem 统计值
rem ######
set CountOk=0
set CountFailed=0
set MonitorCount=0
set MonitorCountFailed=1

rem 倒计时（菜单，监听，重连）
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
echo 脚本版本：%BatVersion%
echo 系统版本：%SysVer%
goto MenuList


:MenuList
rem 菜单列表
reg add HKEY_CURRENT_USER\Console /v QuickEdit /t REG_DWORD /d 00000000 /f >nul
echo %SysVer% | findstr /R "6\.[0-3]" >nul
if %errorlevel% EQU 0 (
    echo.
    echo.
    echo                      %TitleContent%
    echo.
    echo     **********************************************************
    echo     *                            *                           *
    echo     *       O 自动VPN连接        *       S 保存登录信息      * 
    echo     *                            *                           *
    echo     *       D 断开VPN连接        *       C 清除登录信息      *  
    echo     *                            *                           *
    echo     *       H 解决登录问题       *       U 设置开机自启      * 
    echo     *                            *                           *
    echo     **********************************************************
    echo.
    echo     温馨提示： 最小化此窗口，实现闪断重连。
    echo.
    <nul set /p="请按键选择（%MenuTimer%秒后将自动选择O），"
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
    echo     ┌─────────────────┬───────────────────┬──────────────────┐
    echo     │                 │                   │                  │
    echo     │  F 查看VPN连接  │  O 自动连接VPN ← │  S 保存登录信息  │ 
    echo     │                 │                   │                  │
    echo     │  A 添加VPN连接  │  D 断开连接VPN    │  C 清除登录信息  │  
    echo     │                 │                   │                  │
    echo     │  R 删除VPN连接  │  H 解决登录问题   │  U 设置开机自启  │ 
    echo     │                 │                   │                  │
    echo     └─────────────────┴───────────────────┴──────────────────┘
    echo.
    echo     温馨提示： 最小化此窗口，实现闪断重连。
    echo.
    <nul set /p="请按键选择（%MenuTimer%秒后将自动选择O），"
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
    <nul set /p=操作系统不支持，请按任意键退出。
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
    <nul set /p=提示：无法连接VPN，请先“保存登录信息”，按任意键跳将转到“保存登录信息”菜单...
    pause >nul
    goto SaveLogin
)
goto :eof



:FindVpn
rem 查看VPN连接
echo.
call :SubTitle 查看VPN连接
call :GetVpnConnection
echo.
goto MenuList

:GetVpnConnection
<nul set /p=正在获取系统中所有的VPN...
echo.
echo.
echo %SysVer% | findstr "6\.[0-3]" >nul
if %errorlevel% EQU 0 (
    echo 如果你还未添加（创建）VPN连接，Win7/8用户请打开手机“易信APP→应用→VPN”，按对应的教程来添加（创建）VPN连接。
    echo.
    <nul set /p=该系统暂不支持自动获取VPN的连接名称，按任意键将打开“网络适配器窗口”来查看“连接名称”，
    pause
    ncpa.cpl
    goto :eof
)

set "psCommand=powershell -Command "$findvpn = Get-VpnConnection -AllUserConnection; $findvpn.name"
%psCommand% >%temp%\vpnlist.txt
echo 已存在的VPN连接（连接名称）
echo -----------------------------------
type %temp%\vpnlist.txt
echo -----------------------------------
goto :eof


:AddVpn
rem  添加 VPN 连接
set VpnName=
set VpnAddr=
set VpnKey=
echo.
call :SubTitle 添加VPN连接
echo.
echo 提示:
echo     + win7,win8用户按“易信手机APP→应用→VPN”中对应教程操作来添加VPN。
echo.
echo 如使用下面默认值，请直接按回车键：
echo.
echo     连接名称：ESVPN
echo     服务器地址：vpn.teamshub.com
echo     预共享密钥：vpn
echo.
call :GetVpnConnection
echo.
set /P VpnName=请输入连接名称：
if "x%VpnName%" == "x" set VpnName=ESVPN
echo         （%VpnName%）

set /P VpnAddr=请输入服务器地址：
if "x%VpnAddr%" == "x"  set VpnAddr=vpn.teamshub.com
echo         （%VpnAddr%）


set /P VpnKey=请输入预共享密钥：
if "x%VpnKey%" == "x"  set VpnKey=vpn
echo         （%VpnKey%）
echo.
echo 提示：
echo     + 一些安全软件会有安全提示，请点击允许全部操作/允许操作。
echo     + 如提示红色字样“当文件已存在时，无法创建该文件”，说明已存在 %VpnName% 连接，请删除连接后再添加。
echo     + 如提示黄色字样的警告提示，请忽略。
echo.
echo.
echo 正在添加 %VpnName% 连接...
set "psCommand=powershell -Command "$vpninfo = Add-VpnConnection -Name '%VpnName%' -ServerAddress '%VpnAddr%' -TunnelType L2TP -L2tpPsk '%VpnKey%' -Force -AuthenticationMethod PAP,CHAP -UseWinlogonCredential $True -SplitTunneling $True -EncryptionLevel 'Optional' -PassThru; $vpninfo""
%psCommand%
call :GetVpnConnection
echo.
pause
goto MenuList


:RemoveVpn
rem 删除 VPN 连接
set VpnName=
echo.
call :SubTitle 删除VPN连接
echo 此选项将删除一个VPN连接。
echo.
call :GetVpnConnection
echo.
set /P VpnName=请输入连接名称：
if "x%VpnName%" == "x" (
    <nul set /p=提示：你输入的连接名称为空，
    pause
    goto MenuList
)
echo 正在断开连接 %VpnName%...
rasdial "%VpnName%" /DISCONNECT
set "psCommand=powershell -Command "$vpninfo = Remove-VpnConnection -AllUserConnection -Name '%VpnName%' -Confirm; $vpninfo""
%psCommand%
echo.
call :GetVpnConnection
echo.
pause
goto MenuList


:Connection
rem 开启VPN连接
echo.
call :SubTitle 自动连接VPN
ipconfig /flushdns >nul
call :GetPasswd

if "x%VpnName%" == "x" (
    <nul set /p=提示：VPN连接名称为空，无法自动连接，请先“保存登录信息”，按任意键跳将转到“保存登录信息”菜单...
    pause >nul
    goto SaveLogin
)

if "x%VpnName%x" == "x x" (
    <nul set /p=提示：VPN连接名称为空，无法自动连接，请先“保存登录信息”，按任意键跳将转到“保存登录信息”菜单...
    pause >nul
    goto SaveLogin
)

if "x%VpnUser%" == "x" (
    <nul set /p=提示：VPN用户名为空，无法自动连接，请先“保存登录信息”，按任意键跳将转到“保存登录信息”菜单...
    pause >nul
    goto SaveLogin
)
if "x%VpnUser%" == "xUSER" (
    echo 【警告】VPN用户名为空，无法自动连接，请先手动连接%VpnName%。
)

if "x%VpnPassword%" == "x" (
    <nul set /p=提示：VPN密码为空，无法自动连接，请先“保存登录信息”，按任意键跳将转到“保存登录信息”菜单...
    pause >nul
    goto SaveLogin
)
if "x%VpnPassword%" == "xPASSWORD" (
    echo 【警告】VPN密码为空，无法自动连接，请先手动连接%VpnName%。
)
echo.
echo 连接名称：%VpnName%
echo 用户名：%VpnUser%
echo 密码：********
echo.
echo 正在提交VPN连接，请稍等...
set VpnPassword=%VpnPassword:~5%
if "x%errorid%" == "x0000" (
    echo 你已经连接到 %VpnName%
    <nul set /p=正在监控 %VpnName% 连接，侦测到断开会自动重连，已监控%MonitorTimers%秒。可按E键退出监控。
    goto MonitorVPN
)
if "x%errorid%" == "x0001" (
    echo 你已经连接到 %VpnName%
    <nul set /p=正在监控 %VpnName% 连接，侦测到断开会自动重连，已监控%MonitorTimers%秒。可按E键退出监控。
    goto MonitorVPN
)
rasdial "%VpnName%" "%VpnUser%" "%VpnPassword:~0,4%%VpnPassword:~9%" >%LinkLog%
for /f "usebackq tokens=1,2,3,4,5*" %%A in (%LinkLog%) do (
    if "x%%A" == "x已连接" (
        echo %%A %%B %%C
        SET /A CountOk=%CountOk%+1
        call :GetVpnIfIndex
        call :GetIP
        call :SetRoute
        call :SetMetric
        set errorid=0000
        call :SuccessLink
    )

    if "x%%A" == "x你已经连接到" (
        echo %%A %%B %%C
        call :GetVpnIfIndex
        call :GetIP
        call :SetRoute
        call :SetMetric
        set errorid=0001
        call :SuccessLink
    )

    if "x%%A" == "x您已经连接到" (
        echo %%A %%B %%C
        call :GetVpnIfIndex
        call :GetIP
        call :SetRoute
        call :SetMetric
        set errorid=0001
        call :SuccessLink
    )

    if "x%%A" == "x远程访问错误" (
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
rem 断开连接VPN
echo.
call :SubTitle 断开连接VPN
call :GetPasswd
echo 正在断开 %VpnName% 连接...
rasdial "%VpnName%" /DISCONNECT
TIMEOUT /T 2 /NOBREAK >nul
goto MenuList


:SetStartup
echo.
call :SubTitle 设置开机自启
echo.
echo 提示：
echo     + 一些安全软件会有安全提示，请点击允许全部操作/允许操作。
echo.
set "Startups=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\易信VPN辅助连接器.bat"
rem echo "%0" "%Startup%"
if NOT EXIST "%BatchPath%" (
    <nul set /p=提示：获取脚本%BatchPath%失败，请关闭窗口再重试。
    pause
    goto MenuList
)
copy /Y "%BatchPath%" "%Startups%" >nul
if %errorlevel% EQU 0 (
    echo [+] %BatchPath%文件已复制到%Startups%
    <nul set /p=设置开机自启成功，
    pause
) else ( 
    <nul set /p=提示：设置开机自启失败，请关闭窗口再重试。
    pause
)
echo.
goto MenuList


:ModifyHosts
echo.
call :SubTitle 解决登录问题
call :GetPasswd
echo.
echo 此选项可以帮助你解决因域名解析引起的门户无法登录，无法访问部分办公网页等问题。
echo.
echo.
echo 提示：
echo     + 一些安全软件会有安全提示，请点击允许全部操作/允许操作；
echo     + 此选项将向hosts文件中追加域名解析数据。
echo.
netsh interface ip show interface interface="%VpnName%" >nul
if %errorlevel% NEQ 0 (
    <nul set /p=提示：请 %VpnName% 连接成功后再使用此功能。
    pause
    goto MenuList
)
<nul set /p=正在修改HOSTS文件...
echo.
set HostsFile=C:\Windows\system32\drivers\etc\hosts
if NOT EXIST %HostsFile% (
    <nul set /p=%HostsFile%文件不存在，
    pause
    goto MenuList
)
attrib -r C:\Windows\system32\drivers\etc\hosts
call :ModifyHostsContent 172.18.48.118 eip.teamshub.com
call :ModifyHostsContent 172.18.48.119 sso.teamshub.com
rem call :ModifyHostsContent 172.18.194.160 partner-ehr.si-tech.cn
rem call :ModifyHostsContent 172.18.193.172 partner-ehr.si-tech.cn
echo.
echo 若无其它域名解析需求，直接按回车键跳过。
echo.
set /P DomainContents=请输入内网域名：
if "x%DomainContents%" == "x" (
    <nul set /p=已跳过，修改HOSTS文件完成，
    pause
    goto MenuList
)
ping -n 1 %DomainContents% >nul
if %errorlevel% NEQ 0 (
    echo 域名无法解析，请查正后重试。
    <nul set /p=已跳过，修改HOSTS文件完成，
    pause
    goto MenuList
)
for /f "skip=1 usebackq tokens=2" %%a in (`nslookup %DomainContents% 172.16.9.60 ^| find "Address"`) do set DomainIp=%%a
echo %DomainContents%域名系统自动解析结果（供参考）：%DomainIp%
echo.
set /P IPContents=请输入内网域名对应的IP地址：
if "x%IPContents%" == "x" (
    <nul set /p=已跳过，修改HOSTS文件完成，
    pause
    goto MenuList
)
ping -n 1 %IPContents% >nul
if %errorlevel% NEQ 0 (
    echo IP地址通信失败，请查正后重试。
    <nul set /p=已跳过，修改HOSTS文件完成，
    pause
    goto MenuList
)
call :ModifyHostsContent %IPContents% %DomainContents%
attrib +r C:\Windows\system32\drivers\etc\hosts
echo.
<nul set /p=修改HOSTS文件完成，
pause
goto MenuList


:ModifyHostsContent
type "%HostsFile%" | findstr /R "^[0-9]" | find "%1 %2" >nul
if %errorlevel% NEQ 0 (
    echo [+] %1 %2
    echo.>>%HostsFile%
    echo %1 %2 >>%HostsFile%
) else (
    echo [√] %1 %2
)
goto :eof


:SaveLogin
rem 保存登录信息
set VpnName=
set VpnUser=
set VpnPassword=
echo.
call :SubTitle 保存登录信息
echo 此选项将保存你的VPN连接名称，用户名和密码。用于自动连接/断开重连。
echo.
echo 提示：
echo     + 连接名称（必填）。单击电脑右下角wifi或电脑图标，VPN连接处显示的名称。
echo     + 用户名、密码（选填）。填写用户名、密码，用于实现自动连接和断开自动重连。
echo.
echo.
call :GetVpnConnection
echo.
set /P VpnName=请输入连接名称：
if "x%VpnName%" == "x" (
    <nul set /p=提示：你输入的连接名称为空，请按任意键将返回菜单...
    pause >nul
    goto MenuList
)
set /P VpnUser=请输入用户名：
if "x%VpnUser%" == "x" (
    <nul set /p=提示：你输入的用户名为空，按任意键将返回菜单...
    pause >nul
    goto MenuList
)

echo %SysVer% | findstr /R "6\.[0-3]" >nul
if %errorlevel% EQU 0 (
    set /P VpnPassword=请输入密码：
)
echo %SysVer% | findstr /R "10\.[0-3]" >nul
if %errorlevel% EQU 0 (
    call :hidepasswd
)

if "x%VpnPassword%" == "x" (
    <nul set /p=提示：你输入的密码为空，按任意键将返回菜单...
    pause >nul
    goto MenuList
)

echo.
echo 你保存的登录信息，将用于自动连接/断开重连。
echo 连接名称：%VpnName%
echo 用户名：%VpnUser%
echo 密码：********
echo.
set /A MD5=%random%*1239
set /A MD6=%random%*7574
rem set "salta=5550044.26673,249987778889"
rem set "saltb=EwX0#kPoDO$cAdKe1_2GaMPeT"
rem echo %VpnName%:%VpnUser%:%MD5:~0,5%%salta%%VpnPassword:~0,4%%MD6:~0,5%%saltb%%VpnPassword:~4% >%ES001%
echo %VpnName%:%VpnUser%:%MD5:~0,5%%VpnPassword:~0,4%%MD6:~0,5%%VpnPassword:~4% >%ES001%
<nul set /p=已保存登录信息，
pause
echo.
goto MenuList


:ClearLogin
rem 清除登录信息
echo.
call :SubTitle 清除登录信息
echo.
echo 提示：清除登录信息后无法恢复。
echo.
echo :: >%ES001%
<nul set /p=已清除登录信息，
pause
goto MenuList


:Man
rem 使用帮助说明
echo.
call :SubTitle 使用帮助说明
echo.   
echo       F 查看VPN连接    O 自动连接VPN    S 保存登录信息  
echo.
echo       A 添加VPN连接    D 断开连接VPN      C 清除登录信息 
echo.
echo       R 删除VPN连接    H 解决登录问题     U 设置开机自启 
echo.
echo     功能特点：
echo         基于windows批处理语言，源于win-route-v12，界面设计简洁大方。
echo         + 小巧玲珑无需安装，更轻薄，更绿色；
echo         + 功能菜单自助导航，更快捷，更高效；
echo         + 用户信息加密存储，更安全，更可靠；
echo         + 添删改查样样精通，更全面，更专业；
echo         + 自动连接闪断重拨，更方便，更轻松；
echo         + 错误故障自检自查，更智能，更精准；
echo         + 业务访问畅通无阻，更快速，更长效；
echo         + 使用指南随用随查，更便携，更实用。
echo.
echo     查看VPN连接：查看当前系统上已有的VPN连接。
echo     添加VPN连接：在当前系统上添加一个指定的VPN连接。
echo     删除VPN连接：在当前系统上删除一个指定的VPN连接。
echo     自动VPN连接：自动连接VPN，断开自动重连。断开自动重连的前提条件：窗口常开并处于监听提示界面。
echo     断开VPN连接：在当前系统上断开一个指定的VPN连接。
echo     设置本地DNS：导入内网域名到本地hosts文件中。
echo     保存登录信息：在你的系统上保存VPN连接名称、用户名、密码信息，用于自动VPN连接、断开自动重连。
echo     清除登录信息：清除已保存的VPN连接名称、用户名、密码信息。
echo     设置开机自启：设置开机自行启动本工具，如取消开机自启，需要自行手动取消。
echo.
<nul set /p=更多使用说明敬请期待，
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
echo     ┌────────────────────────────────────────────────────────┐
echo                             %1                     
echo     └────────────────────────────────────────────────────────┘
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
rem 获取VPN连接状态
netsh interface ip show interface interface="%VpnName%" >nul
if %errorlevel% equ 0 (
    set %1=ok
) else (
    set %1=failed
)
goto :eof



rem ##########
:hidepasswd
rem 密码隐藏显示
set "psCommand=powershell -Command "$pword = read-host '请输入密码' -AsSecureString ; ^
        $BSTR=[System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($pword); ^
            [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)""
for /f "usebackq delims=" %%p in (`%psCommand%`) do set password=%%p
set VpnPassword=%password%
goto :eof


rem 获取VPN连接索引号
rem #################
:GetVpnIfIndex
for /f "usebackq tokens=1,2,3" %%a in (`netsh interface ip show interface "%VpnName%" ^| find "IfIndex"`) do set IfIndex=%%c
if "x%IfIndex%" == "x" (
    <nul set /p=提示：%VpnName% 连接的索引号为空，无法进行配置，
    pause
    goto MenuList
) else (
    echo %VpnName% 连接的索引号：%IfIndex%
    goto :eof
)
goto :eof

rem 获取VPN的IP地址
rem ###############
:GetIP
call :IpConnStatus IpReturn IpAddr
if "%debug%" == "true" echo [DEBUG] 判断是否勾选了“在远程网络上使用默认网关”的返回值：%IpReturn%
if "%IpReturn%" == "yes" (
    echo .
    echo 你的 %VpnName% 连接需要去掉“在远程网络上使用默认网关”勾选配置，才可以同时访问内外网。
    echo .
    echo 去掉“在远程网络上使用默认网关”勾选配置的操作步骤：
    echo    1）运行框（按win+R组合键）中输入ncpa.cpl回车；
    echo    2）打开窗口后，找到%VpnName%，并右击它，选择“属性”；
    echo    3）在属性对话框中选择“网络”→“Internet协议版本4”→“属性”；
    echo    4）再选择“高级”→“IP设置”，去掉“在远程网络上使用默认网关”的勾选，确认即可；
    echo .
    rasdial "%VpnName%" /DISCONNECT >nul
   <nul set /p=.
    pause
    goto MenuList
)
if "x%IpAddr%" == "x" (
    <nul set /p=提示：%VpnName% 连接的IP地址为空，无法进行配置，
    pause
    goto MenuList
)
echo %IpAddr% | find "172.20." >nul
if %errorlevel% EQU 0 (
    echo %VpnName% 连接的IP地址：%IpAddr%
) else (
    <nul set /p=提示：%VpnName% 连接的IP地址 %IpAddr% 无效，无法进行配置，
    pause
    goto MenuList
)
goto :eof


rem 向VPN添加路由
rem #############
:SetRoute
set GwAddr=1.0.0.1
echo %VpnName% 连接的路由：
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


rem 添加路由命令
rem ###########
:AddRoute
route print | findstr /R "%1.*%2.*%GwAddr%.*%IpAddr%" >nul
if %errorlevel% EQU 0 (
    echo     [√] %1 %2 已存在！
) else (
    <nul set /p=.   [＋] %1 %2
    route ADD %1 MASK %2 %GwAddr% METRIC %met% IF %IfIndex%
)
goto :eof


rem 向VPN路由设置度量值
rem ##################
:SetMetric
if "%debug%" == "true" echo [DEBUG]：%VpnName%连接的索引号为%IfIndex%，metric为%met%。
netsh interface ip set interface "%IfIndex%" metric=%met% >nul
if %errorlevel% EQU 0 (
    echo %VpnName% 连接的metric值：%met%
    echo %VpnName% 已成功连接和配置。
    goto :eof
) else (
    <nul set /p=提示：%VpnName% 连接的IfIndex值无效，配置metric失败，
    pause
    goto MenuList
)


:SuccessLink
if "x%errorid%" == "x0000" (
    call :PopupWindows 已成功连接%VpnName%。
)
echo.
<nul set /p=正在监控 %VpnName% 连接，侦测到断开会自动重连，已监控%MonitorTimers%秒。可按E键退出监控。
goto MonitorVPN


:IpConnStatus
rem IP连接状态，用于识别有无勾选默认网关
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
    CHOICE /T %MonitorTimer% /C LE /D L /M "请按键选择" >nul
    if errorlevel 2 (
        call :RecordLog
        goto MenuList
    )
    if errorlevel 1 (
        set /a MonitorTimers=%MonitorTimers%+10
        <nul set /p=%BackSpace%正在监控 %VpnName% 连接，侦测到断开会自动重连，已监控%MonitorTimers%秒。可按E键退出监控。
        goto MonitorVPN
    )
) else (
    CHOICE /T 5 /C LE /D L /M "请按键选择" >nul
    if errorlevel 2 (
        call :RecordLog
        goto MenuList
    )
    if errorlevel 1 (
        echo.
        echo 监控到%VpnName%已断开，第%MonitorCountFailed%次重新连接中...
        call :PopupWindows 监控到VPN已断开，第%MonitorCountFailed%次自动重新连接中...
        rem echo msgbox "监听到%VpnName%已断开，第%MonitorCountFailed%次重新连接中...",48,"易信VPN辅助连接器" >C:\VpnAlert.vbs && start C:\VpnAlert.vbs
        set errorid=0003
        set /a MonitorCountFailed=%MonitorCountFailed%+1
        goto Connection
    )
)


:PopupWindows
rem 类似msgbox
rem 定时停留弹出框函数
set "PopupVbs=%temp%\EsvpnPopup.vbs"
echo Sub Print^(text,timeout,title^) >"%PopupVbs%"
echo     Dim WshShell >>"%PopupVbs%"
echo     Set WshShell = CreateObject^("WScript.Shell"^) >>"%PopupVbs%"
echo     WshShell.Popup text,timeout,title >>"%PopupVbs%"
echo     Set WshShell = nothing >>"%PopupVbs%"
echo End Sub >>"%PopupVbs%"
rem Print "弹窗显示的内容",10,"对话框在10秒内自动关闭！"
echo Print "%1%2%3%4",3,"易信VPN辅助连接器" >>"%PopupVbs%"
start "%SystemRoot%\System32\WScript.exe" "%PopupVbs%"
goto :eof


:ReConnection
rem 重连VPN
SET /A CountFailed=%CountFailed%+1
call :RecordLog >%VpnLog%
<nul set /p=%ReConnTimer%秒后将自动重新 %VpnName% 连接，第%CountFailed%次重连，可按L键即刻重连VPN，按E键退出并返回菜单。
CHOICE /T %ReConnTimer% /C LE /D L /M "请按键选择" >nul
echo.
if errorlevel 2 (
    call :RecordLog
    goto MenuList
)
if errorlevel 1 goto Connection


:RecordLog
echo.
echo.
echo 连接统计：
echo     监听连接：%MonitorCount% 次
echo     成功连接：%CountOk% 次
echo     失败连接：%CountFailed% 次
echo.
goto :eof


:QA
rem 错误代码报错提示解决
echo.
echo 正在查找 %errorid% 错误的解决方案...
echo.
rem echo 提示：
rem echo     + 提供的解决方案仅供参考，这些解决方案可能会损坏你的系统，需谨慎操作。
rem echo     + 你可以自行搜索解决 或 寻求身边同事协助解决。
rem echo     + 请多次尝试连接VPN失败后再到《VPN使用和问题反馈》圈子里反馈，反馈时需提供错误代码和错误描述。
rem echo     + 如果你上次成功连接过，请忽略这些解决方案。可能是由于你的电脑与VPN服务器网络不畅或VPN服务器异常引起的错误。

if "%errorid%" == "623" (
    echo 系统上不存在“%VpnName%”连接。
    echo. 
    echo 参考解决方案1：
    echo     填写的连接名称和实际的VPN连接名称不一样。连接名称是单击电脑右下角wifi或电脑图标中VPN连接显示的名称。
    echo. 
    echo 参考解决方案2：
    echo     win7,win8用户可以按“易信手机APP→应用→VPN”中教程添加一个VPN连接；
    echo     win10用户可以使用“添加VPN连接”菜单来添加。
    echo.
    goto OtherHelp
)

if "%errorid%" == "691" (
    echo 参考解决方案1：
    echo     请输入正确用户名或密码。重新选择“保存登录信息”选项。
    echo.
    echo 参考解决方案2：
    echo     打开“服务”窗口
    echo         （win10）启动“IKE and AuthIP IPsec Keying Modules”服务，并设置为自动。
    rem echo         （win10）启动“Remote Access Connection Manager”服务，并设置为自动。
    echo.
    goto OtherHelp
)

if "%errorid%" == "703" (
    echo 参考解决方案1：
    echo     在“安全”选项卡中：
    echo         1、VPN类型中选择“使用IPsec的第二层隧道协议（L2TP/IPsec）”；
    echo         2、数据加密中选择“可选加密（没有加密也可以连接）”；
    echo         3、勾选“允许使用这些协议”；
    echo         4、勾选“未加密的密码（PAP）”；
    echo         5、勾选“质询握手身份验证协议（CHAP）”。
    echo.
    goto OtherHelp
)

rem 更新时间2020-06-16，来源于用户反馈。
if "%errorid%" == "718" (
    echo 参考解决方案1：
    echo     您所连接的VPN服务器发生了异常，请保持脚本监控状态，它将自动进行重连直到连接成功。
    echo.
    goto OtherHelp
)

if "%errorid%" == "720" (
    echo 注意：这些更改可能会损坏你的系统，win7用户需谨慎操作。
    echo.
    echo 参考解决方案1：
    echo     （win10）尝试把设备管理器中的网络适配器下“wan 微型端口（IP）”卸载后再重启电脑。
    echo.
    echo 参考解决方案2：
    echo     （win10）尝试把设备管理器中的网络适配器下“wan 微型端口（XXX）”都卸载后再重启电脑。
    echo.
    goto OtherHelp
)

if "%errorid%" == "789" (
    rem ################################################################################
    rem 错误 789：L2TP连接尝试失败，因为安全层在初始化与远程计算机的协商时遇到了一个处理错误
    rem https://support.microsoft.com/zh-cn/help/926179/how-to-configure-an-l2tp-ipsec-server-behind-a-nat-t-device-in-windows  
    rem ################################################################################
    echo 参考解决方案1：
    echo     打开“服务”窗口（运行框中输入services.msc回车）
    echo          （win10）找到IKEEXT (IKE and AuthIP IPsec Keying Modules）服务，将其设置为自动，并启动它。
    echo.
    echo 参考解决方案2：
    echo     尝试使用你的手机热点或使用另一部手机热点，再进行VPN连接。
    echo.
    call :RunReg789
    echo.
    goto OtherHelp
)

if "%errorid%" == "809" (
    rem ################################################################################
    rem 错误 809：无法建立计算机与 VPN 服务器之间的网络连接，因为远程服务器未响应。
    rem 这可能是因为未将计算机与远程服务器之间的某种网络设备（如防火墙、NAT、路由器等）配置为允许 VPN 连接。
    rem 请与管理员或服务提供商联系以确定哪种设备可能产生此问题。
    rem https://superuser.com/questions/1481394/windows-10-l2tp-vpn-connection-issue
    rem 如果将服务器放置在NAT设备后面，然后使用IPsec NAT-T环境，则可以通过更改VPN客户端计算机和VPN服务器上的注册表值来启用通信。
    rem ################################################################################
    echo 参考解决方案1：
    echo     禁用再启用一下外网网卡。
    echo.
    echo 参考解决方案2：
    echo     如果你的主机刚开机或从休眠中恢复时，请等待后台系统服务启动完成，再连接VPN。
    echo.
    goto OtherHelp
)

if "%errorid%" == "868" (
    echo 参考解决方案1：
    echo     请先联接互联网后再连接VPN。
    echo.
    rem echo 参考解决方案2：
    rem echo     修改DNS服务器地址，尝试改成114.114.114.114
    rem echo.
    rem echo 参考解决方案3：
    rem echo     分别尝试将vpn.teamshub.com域名地址更换为下面IP地址之一：
    rem echo         219.143.121.34 电信
    rem echo         219.143.121.35 电信
    rem echo         223.70.245.113 移动
    rem echo         223.70.245.114 移动
    rem echo         114.255.113.5  联通
    rem echo         114.255.113.6  联通
    rem echo.
    goto OtherHelp
)

echo 暂无该%errorid%错误代码的参考解决方案。
goto OtherHelp


:OtherHelp
echo 还可以：
echo     1）咨询周边同事或好友协助解决；
echo     2）百度搜索报错关键字自行排查解决；
echo     3）到易信APP“VPN使用和问题反馈”圈子反馈问题（需提供系统版本、错误代码、错误描述、外网环境）；
echo     4）直接反馈给客服人员。
rem echo     4）访问https://documentation.meraki.com/MX/Client_VPN/Troubleshooting_Client_VPN#Windows_Error_809
rem echo     5）访问https://github.com/hwdsl2/setup-ipsec-vpn/blob/master/docs/clients-zh.md#windows-%E9%94%99%E8%AF%AF-809
echo.
goto ReConnection


:RunReg789
echo 正在尝试自动修复此问题：
<nul set /p=【1】修改注册表AllowL2TPWeakCrypto值为0x1，
REG ADD HKLM\SYSTEM\CurrentControlSet\Services\RasMan\Parameters /v AllowL2TPWeakCrypto /t REG_DWORD /d 0x1 /f
<nul set /p=【2】修改注册表ProhibitIpSec值为0x1，
REG ADD HKLM\SYSTEM\CurrentControlSet\Services\RasMan\Parameters /v ProhibitIpSec /t REG_DWORD /d 0x1 /f
echo.
echo 问题已修复，请重启电脑，再连接！
pause >nul
echo 问题已修复，请重启电脑，再连接！
pause >nul
echo 问题已修复，请重启电脑，再连接！
pause >nul
goto :eof

:RunReg809
REG QUERY HKLM\SYSTEM\CurrentControlSet\Services\PolicyAgent /v AssumeUDPEncapsulationContextOnSendRule 2>nul 1>nul
if %errorlevel% EQU 0 (
    for /f "usebackq tokens=3" %%i in (`REG QUERY HKLM\SYSTEM\CurrentControlSet\Services\PolicyAgent /v AssumeUDPEncapsulationContextOnSendRule`) do (
        if "%%i" == "0x0" (
            <nul set /p=修改注册表AssumeUDPEncapsulationContextOnSendRule值为0x1，
            REG ADD HKLM\SYSTEM\CurrentControlSet\Services\RasMan\Parameters /v AssumeUDPEncapsulationContextOnSendRule /t REG_DWORD /d 0x1 /f
        )
    )
) else (
     echo 注册表ProhibitIpSec值不存在，
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
<nul set /p=正在启动...
TIMEOUT /T 2 /NOBREAK >nul
cls
rem TIMEOUT /T 2 /NOBREAK >nul
goto :eof



:TestExample
rem start /B iexplore eip.teamshub.com
rem start notepad "%BatchPath%"

rem 连接提示1：
rem     你已经连接到 ESVPN。
rem     命令已完成。

rem 连接提示2：
rem     正在连接到 ESVPN...
rem     正在验证用户名及密码...
rem     正在网络上注册你的计算机...
rem     已连接 ESVPN。
rem     命令已完成。

rem 连接提示3：
rem     正在连接到 ESVPN...
rem     正在验证用户名及密码...
rem     
rem     远程访问错误 691 已拒绝远程连接，因为未识别出你提供的用户名和密码组合，或在远程访问服务器上禁止使用选定的身份验证协议。