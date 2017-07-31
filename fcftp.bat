::请确保你很懂bat,不然随便改点什么都会出错,写这个我调试了好久,萌新练手之作！---by lovefc 版权所有 未经本人许可 不得用于商业用途
@echo off
::定义脚本颜色
color 9a
::定义标题
title FTP--目录打包上传脚本--by lovefc
::定义窗口大小
mode con cols=80 lines=30
echo ******************************************************************************* 
echo * 目录打包FTP上传 * 
echo * 作者：lovefc  *
echo *  QQ : 1102952084 *
echo ******************************************************************************* 
::winrar 地址
::set RARDIR=C:\Program Files\WinRAR\Rar.exe(winrar的默认地址)
set  RARDIR=%~dp07Z\7z.exe
set  ftpinfo=%~dp0ftp.info
set bak_mkdir=%date:~0,4%%date:~5,2%%date:~8,2%
call:operas
:operas
echo:
set /p bak_webFiles=        请将要上传的文件夹或者文件 拖到此处 或者输入路径:
if not exist %bak_webFiles% ( 
echo: 文件 or 目录好像并不存在。。。。。
set /p bak_webFiles=        请将要上传的文件夹或者文件 拖到此处 或者输入路径:
)
for %%a in (%bak_webFiles%) do set "b=%%~aa"
if defined b (
if "%b:~0,1%"=="d" (
set isdir=1 
) else (
set isdir=2
)
)
if %isdir%==1 (
::取得路径中最后的字符串
for /f "delims=" %%i in ("%bak_webFiles%") do (
set filen=%%~nxi
)
set bak_webFile=%~dp0%filen%.zip
"%RARDIR%" a -r %bak_webFile% %bak_webFiles%\*.*
) else (
set bak_webFile= %bak_webFiles%
)
set bak_date=%date:~0,4%%date:~5,2%%date:~8,2%%time:~0,2%%time:~3,2%%time:~6,2%
if not EXIST %ftpinfo% (
set /p bak_ftpServer=      输入ip地址:
if not defined bak_ftpServer (
echo:  地址不能为空
set /p bak_ftpServer=      输入ip地址:
)
set /p bak_ftpPort=        输入端口 默认21:
if not defined bak_ftpPort (
set bak_ftpPort= 21
)
set /p bak_ftpUserName=    输入帐号:
if not defined bak_ftpUserName (
echo:  帐号不能为空
set /p bak_ftpUserName=      输入帐号:
)
set /p bak_ftpUserPass=    输入密码:
if not defined bak_ftpUserPass (
echo:  密码不能为空
set /p bak_ftpUserPass=      输入密码:
)
) else (
setlocal enabledelayedexpansion  
set /a v=0  
for /f "delims=" %%i in (%ftpinfo%) do (
set /a v+=1
if "!v!"=="1" (
set bak_ftpServer=%%i
)
if "!v!"=="2" (
set bak_ftpPort=%%i
)
if "!v!"=="3" (
set bak_ftpUserName=%%i
)
if "!v!"=="4" (
set bak_ftpUserPass=%%i
)
)
)
if not EXIST %ftpinfo% (
echo open %bak_ftpServer%>%ftpinfo%
echo %bak_ftpPort%>>%ftpinfo%
echo %bak_ftpUserName%>>%ftpinfo%
echo %bak_ftpUserPass%>>%ftpinfo%
) else (
set bak_ftpServer=%bak_ftpServer:~4% 
)
set "bak_ftpServer=%bak_ftpServer%" 
set "bak_ftpServer=%bak_ftpServer: =%"
set "bak_ftpPort=%bak_ftpPort%" 
set "bak_ftpPort=%bak_ftpPort: =%"
set "bak_ftpUserName=%bak_ftpUserName%" 
set "bak_ftpUserName=%bak_ftpUserName: =%"
set "bak_ftpUserPass=%bak_ftpUserPass%" 
set "bak_ftpUserPass=%bak_ftpUserPass: =%"
setlocal disabledelayedexpansion
echo:   FTP地址：%bak_ftpServer% 端口：%bak_ftpPort%
if %isdir%==1 (
echo:   压缩包文件名称：%bak_webFile%
) else (
echo:   文件名称地址：%bak_webFile%
)
echo:
echo:        开始上传
::生成ftp命令文件
echo open %bak_ftpServer% %bak_ftpPort%>ftp.up
echo %bak_ftpUserName%>>ftp.up
echo %bak_ftpUserPass%>>ftp.up
echo bin >>ftp.up
echo mkdir %bak_mkdir%>>ftp.up
echo cd %bak_mkdir%>>ftp.up
echo put %bak_webFile%>>ftp.up
echo bye >>ftp.up
FTP -s:ftp.up -i >>%bak_logPath%log-%bak_date%.txt
del ftp.up /q
del log-%bak_date%.txt /q
if %isdir%==1 (
del %bak_webFile% /q
)
echo:
echo:
echo:        上传完成
call:operas
pause
GOTO:EOF