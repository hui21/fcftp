::��ȷ����ܶ�bat,��Ȼ���ĵ�ʲô�������,д����ҵ����˺þ�,��������֮����---by lovefc ��Ȩ���� δ��������� ����������ҵ��;
@echo off
color 9a
title SFTP-FTP--Ŀ¼����ϴ��ű�--by lovefc
::mode con cols=80 lines=30
echo ******************************************************************************* 
echo * Ŀ¼���SFTP-FTP�ϴ� * 
echo * ���ߣ�lovefc  *
echo *  QQ : 1102952084 *
echo ******************************************************************************* 
::winrar ��ַ
::set RARDIR=C:\Program Files\WinRAR\Rar.exe(winrar��Ĭ�ϵ�ַ)
set  RARDIR=%~dp07Z\7z.exe
set bak_mkdir=%date:~0,4%%date:~5,2%%date:~8,2%
call:operas
:operas
echo:
set /p bak_ftp_mode=       �ϴ���ʽ 1:ftp 2:sftp Ĭ��ftp:
::��ⷽʽ
if not defined bak_ftp_mode ( 
set bak_ftp_mode=ftp
) else (
if "%bak_ftp_mode%"=="1" (
set bak_ftp_mode=ftp 
) else (
set bak_ftp_mode=sftp
)
)
if %bak_ftp_mode%==ftp (
set  ftpinfo=%~dp0ftp.info
) else (
set  ftpinfo=%~dp0sftp.info
call:win_is_64
if "%BITS%"=="true"  (
set psftp_path=%~dp0psftp\64\psftp.exe
) else (
set psftp_path=%~dp0psftp\32\psftp.exe
)
)
set /p bak_webFiles=        �뽫Ҫ�ϴ����ļ��� or �ļ� �ϵ��˴� ��������·��:
if not exist %bak_webFiles% ( 
echo: �ļ� or Ŀ¼���񲢲����ڡ���������
set /p bak_webFiles=        �뽫Ҫ�ϴ����ļ��� or �ļ� �ϵ��˴� ��������·��:
)

for %%a in (%bak_webFiles%) do set "b=%%~aa"
if defined b (
if "%b:~0,1%"=="d" (
set fcdir=dirs
) else (
set fcdir=files
)
)
setlocal enabledelayedexpansion
if %fcdir%==dirs (
for /f "delims=" %%i in ("%bak_webFiles%") do (
set filen=%%~nxi
)
set bak_webFile=%~dp0!filen!.zip
%RARDIR% a -r !bak_webFile! %bak_webFiles%\*.*
) else (
set bak_webFile= %bak_webFiles%
)
setlocal disabledelayedexpansion
set bak_date=%date:~0,4%%date:~5,2%%date:~8,2%%time:~0,2%%time:~3,2%%time:~6,2%
if not EXIST %ftpinfo% (
set /p bak_ftpServer=      ����ip��ַ:
if not defined bak_ftpServer (
echo:  ip��ַ����Ϊ��
set /p bak_ftpServer=      ����ip��ַ:
)
set /p bak_ftpPort=        ����˿� ftp:21 sftp:22 :
if not defined bak_ftpPort (
echo:  �˿ڲ���Ϊ��
set /p bak_ftpPort=        ����˿� ftp:21 sftp:22 :
)
set /p bak_ftpUserName=    �����ʺ�:
if not defined bak_ftpUserName (
echo:  �ʺŲ���Ϊ��
set /p bak_ftpUserName=    �����ʺ�:
)
set /p bak_ftpUserPass=    ��������:
if not defined bak_ftpUserPass (
echo:  ���벻��Ϊ��
set /p bak_ftpUserPass=    ��������:
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
setlocal disabledelayedexpansion
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
if %bak_ftp_mode%==ftp (
echo:   FTP��ַ��%bak_ftpServer%
) else (
echo:   SFTP��ַ��%bak_ftpServer%
)
echo:   �˿ڣ�%bak_ftpPort%
if %fcdir%==dirs (
echo:   ѹ�����ļ����ƣ�%bak_webFile%
) else (
echo:   �ļ����ƣ�%bak_webFile%
)
echo:
echo:   ��ʼ�ϴ�
if %bak_ftp_mode%==ftp (
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
) else (
call :sput %bak_webFile%
%psftp_path% -P %bak_ftpPort% %bak_ftpUserName%@%bak_ftpServer% -pw %bak_ftpUserPass% -b sftp.up
del sftp.up /q
)
if %fcdir%==dirs (
del %bak_webFile% /q
)
echo:
echo:
echo:  �ϴ����
call:operas
pause
GOTO:EOF
:sput
(
echo put -r %1
echo exit
)>>sftp.up
GOTO:EOF 
:win_is_64
if "%PROCESSOR_ARCHITECTURE%"=="AMD64" (
  set BITS=true
) else (
  set BITS=false
)
GOTO:EOF 