::��ȷ����ܶ�bat,��Ȼ���ĵ�ʲô�������,д����ҵ����˺þ�,��������֮����---by lovefc ��Ȩ���� δ��������� ����������ҵ��;
@echo off
color 9a
title FTP--Ŀ¼����ϴ��ű�--by lovefc
mode con cols=80 lines=30
echo ******************************************************************************* 
echo * Ŀ¼���FTP�ϴ� * 
echo * ���ߣ�lovefc  *
echo *  QQ : 1102952084 *
echo ******************************************************************************* 
set  RARDIR=%~dp07Z\7z.exe
set  ftpinfo=%~dp0ftp.info
set bak_mkdir=%date:~0,4%%date:~5,2%%date:~8,2%
call:operas
:operas
echo:
set /p bak_webFiles=        �뽫Ҫ�ϴ����ļ����ϵ��˴� ��������·��:
if not exist %bak_webFiles% ( 
echo: Ŀ¼���񲢲����ڡ���������
set /p bak_webFiles=        �뽫Ҫ�ϴ����ļ��� �ϵ��˴� ��������·��:
)
for /f "delims=" %%i in ("%bak_webFiles%") do (
set filen=%%~nxi
)
set bak_webFile=%~dp0%filen%.zip
"%RARDIR%" a -r %bak_webFile% %bak_webFiles%\*.*
set bak_date=%date:~0,4%%date:~5,2%%date:~8,2%%time:~0,2%%time:~3,2%%time:~6,2%
if not EXIST %ftpinfo% (

set /p bak_ftpServer=      ����ip��ַ:
if not defined bak_ftpServer (
echo:  ��ַ����Ϊ��
set /p bak_ftpServer=      ����ip��ַ:
)
set /p bak_ftpPort=        ����˿� Ĭ��21:
if not defined bak_ftpPort (
set bak_ftpPort= 21
)
set /p bak_ftpUserName=    �����ʺ�:
if not defined bak_ftpUserName (
echo:  �ʺŲ���Ϊ��
set /p bak_ftpUserName=      �����ʺ�:
)
set /p bak_ftpUserPass=    ��������:
if not defined bak_ftpUserPass (
echo:  ���벻��Ϊ��
set /p bak_ftpUserPass=      ��������:
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
echo:   FTP��ַ��%bak_ftpServer% �˿ڣ�%bak_ftpPort%
echo:   ѹ�����ļ����ƣ�%bak_webFile%
echo:
echo:        ��ʼ�ϴ�
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
del %bak_webFile% /q
echo:
echo:
echo:        �ϴ����
call:operas
pause
GOTO:EOF