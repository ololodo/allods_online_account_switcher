@echo off
rem	Account switcher for MMORPG Allods Online.
rem	This project is licensed under the terms of the MIT license.
rem	MIT License
rem	
rem	Copyright (c) 2017 ololodo.github
rem	
rem	Permission is hereby granted, free of charge, to any person obtaining a copy
rem	of this software and associated documentation files (the "Software"), to deal
rem	in the Software without restriction, including without limitation the rights
rem	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
rem	copies of the Software, and to permit persons to whom the Software is
rem	furnished to do so, subject to the following conditions:
rem	
rem	The above copyright notice and this permission notice shall be included in all
rem	copies or substantial portions of the Software.
rem	
rem	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
rem	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
rem	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
rem	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
rem	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
rem	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
rem	SOFTWARE.
rem	
rem	
rem	version 20170619
rem	____________________History:
rem	������� �� 20170307
rem	20170307 � ������ ����������� ��������� ��������� �� ������ ������� � ���� ����, �� ��� � ������������ � ���������� ������-������.
rem	20170307 now checked not only launcher: addit check game's main process, updater and built-in telemetry.
rem	201706** ���������. ��� ���� ���������� ������ ����� ��������� ��������� ������. ���� ������ ��� ���������� �����.
rem	201706** improuvments. Acc's name passed with command line param.
rem	20170619 ��� ���������.
rem	20170619 Improuvments.
setlocal
set debug=1
set debug=0
rem 	debug=1 ���� �������� �����������/write a debug messages
rem 	debug=0 �� ���� �������� �����������/be quiet, not write debug messages
rem =========������ ��� ����������, ������� ���� �������� ������������=============
rem ���� ����� ����, ��� ������ ��� ������, ��� ������ �������� ������������.
rem =====��� ���� ���������� ���������� � ��������� ������======================

rem	//TODO ��������� ���-�� ��� �������������� ���������� ��������.

echo Account switcher for MMORPG Allods Online.
echo This project is licensed under the terms of the MIT license.
echo https://github.com/ololodo for more info.
echo http://ololodo.blogspot.com for help and howtos.
echo ------------------------------------------------------------

rem	��������� ������� ����������� ��������

set ech=data\Mods\_Addons_commonparts\echo_bike.exe
if not exist %ech% (
  echo Component echo_bike not found. Exitting.
  echo RTFM, please.
  pause
  exit /b 2
)


set sleep=data\Mods\_Addons_commonparts\sleep_bike.exe
if not exist %sleep% (
  echo Component sleep_bike not found. Exitting.
  pause
  exit /b 2
)


rem	get current date und time stamp
set datexe=data\Mods\_Addons_commonparts\date_bike.exe
if not exist %datexe% (
  echo Component date_bike not found. Exitting.
  pause
  exit /b 2
)


set z7=data\Mods\_Addons_commonparts\7za.exe
if not exist %z7% (
  echo Component 7Zip standalone module not found. Exitting.
  pause
  exit /b 2
)


rem	������� �����
>output.tmp %datexe% +"%%Y%%m%%d_%%Hh%%Mm%%Ss"
<output.tmp (
  set /p timestamp=
)
del output.tmp
rem	now we have current DateTimeStamp in %timestamp%
if %debug%==1 echo Debug: timestamp is [%timestamp%].

rem	checking game launcher
set lau=bin\Launcher.exe
if not exist %lau% (
  echo Error: Launcher not found. Exitting
  echo Check presence of Allods Online game.
  pause
  exit /b 2
)
if %debug%==1 echo Debug: Launcher %lau% is exist.



rem	logging procedures
set logfile=Personal\Logs\delete_me_%timestamp%.log
if %debug%==1 echo Debug: logfile is [%logfile%].


echo Log started at %timestamp%. >>%logfile%

rem	check if breaked previous batch traces found?
set rollbackarchive=__rollback.7z
if exist %rollbackarchive% (
  rem	need to roll back first
  %ech% Ubnormal previous batch termination. Rolling initial state back: 
  echo Ubnormal previous batch termination. Rolling initial state back. >>%logfile%
  rem	���������� �� ������ ������ ������� ���������� ��������� � �����.
  rem	������� ��� �� �����, �� ����� ����������� ������ ������������.
  call :subr_pack_content_and_delete %timestamp%_after_hanging_you_may_delete_it.7z %logfile%
  rem	����������� ���������� ��������� � �������� � ����
  rem	%z7% ������ ���� ��� ���������.
  %ech% +1
  echo Rollback: pack current state is OK. >>%logfile%

  rem	����� ����������� �� rollback ��, ��� ����.
  call :subr_extract_content %rollbackarchive% %logfile%
  rem	������������� �����.
  rem	%z7% ������ ���� ��� ���������.
  %ech% +2 
  echo Rollback: unpack from rollback is OK. >>%logfile%

  rem	������� rollback �����.
  del %rollbackarchive%

  echo +3. 
  echo Deleting of rollback achive is OK. >>%logfile%
)
if %debug%==1 echo ===control point 0===. 
echo ===control point 0===. >>%logfile%
if exist %rollbackarchive% (
  rem	O_O ����� ��� ��� ����������, ��� ���� �� ������, ���-�� ���-�� �����!
  rem	assert
  echo ASSERTION TRAPPING 1!!! 
  echo ASSERTION TRAPPING 1!!! >>%logfile%
  pause
  exit
  rem	������ �����, ������������.
)


rem	��� � ��� ��� ����� ��������, ���� ���� ������������ ���������� ������.
if %debug%==1 echo ===control point 1===. 
echo ===control point 1===. >>%logfile%

if Allods%1Online == AllodsOnline (
  rem	Usage
  echo Usage: %~nx0 LoginForGame
  rem	~nx = name+extension
  rem	c a l l / ? for more info
  echo RTFM, please.
  pause
  exit /b 2
)

set username=%1
rem	echo %username%
rem	exit /b
rem	��� login, ��� ������ � user.cfg ���� ������������.
rem	if %debug%==1 pause
if %debug%==1 echo Debug: username is [%username%].
title %1 - Allods Online account switcher

rem	checking existance of prepared addons file for that user
set prepfile=prep_%1.7z
if not exist %prepfile% (
  rem	Not found
  echo Prepared file %prepfile% not found.
  echo RTFM, please.
  pause
  exit /b 2
)

if %debug%==1 echo ===control point 2===.
echo ===control point 2===. >>%logfile%

rem	:subr_test_archive
rem	��������� ���������� ������ �� ������������ �������������.
rem	%z7% ������ ���� ��� ���������.
echo.|set/p yvar="Testing prepared archive for user %1: "
rem	%ech% Testing prepared archive for user %1: 
echo Testing prepared archive for user %1 >>%logfile%
call :subr_test_archive %prepfile% %logfile%
echo OK
echo Testing prepared archive for user %1 ended. >>%logfile%
if %debug%==1 echo Debug: Testing %prepfile% is passed.


if %debug%==1 echo ===control point 3===
echo ===control point 3===. >>%logfile%


if %debug%==1 pause
rem	exit /b 1

echo Starting an actions for user %username%
echo Starting an actions for user %username% >>%logfile%

rem	echo Checking presence of initial backup >>%logfile%
set initialbackupfilename=1st_backup.7z
if not exist %initialbackupfilename% (
  echo.|set/p yvar="Initial backup not found, creating it now: "
  echo Initial backup not found, so we will create it just now >>%logfile%
  rem	:subr_pack_content
  rem	����������� ���������� ��������� � �������� � ����
  rem	%z7% ������ ���� ��� ���������.
  rem	������������ ��������� ���������. ��� ������������
  call :subr_pack_content %initialbackupfilename% %logfile%
  echo OK. %initialbackupfilename%
  echo Archiving of initial backup is OK. %initialbackupfilename% >>%logfile%
) 
echo ===control point 4===. >>%logfile%
if exist %initialbackupfilename% (
  rem	���������� (������ ��� ��� ��� ��� ���� ��� �����, �������). 
  rem	��������� ��� �� ������������.
  rem	:subr_test_archive
  rem	��������� ���������� ������ �� ������������ �������������.
  rem	%z7% ������ ���� ��� ���������.
  call :subr_test_archive %initialbackupfilename% %logfile%
  rem	���� ��� ������, �� ������ ������������ �� ���� �������������.
)
if %debug%==1 echo ===control point 5===
echo ===control point 5===. >>%logfile%


rem	- ��������� ������� ��������� ������� � usercfg
echo.|set/p yvar="Saving initial configuration (addons + user.cfg) to [%rollbackarchive%]: "
rem	echo Start save current initial configuration ^(addons and user.cfg^) to %firstpack%
echo Saving current initial configuration ^(addons and user.cfg^) to %rollbackarchive% >>%logfile%

rem	:subr_pack_content_and_delete
rem	����������� ���������� ��������� � �������� � ����, ����� ����� ������� �������� �����.
rem	%z7% ������ ���� ��� ���������.
call :subr_pack_content_and_delete %rollbackarchive% %logfile%
rem	������������ ��������� ���������.

echo OK.
echo Archiving is OK. >>%logfile%
rem pause
echo ===control point 6===. >>%logfile%


rem	- �� ������ ����� ������� ������������ �������� ���� ����� ������� � usercfg
echo.|set/p yvar="Restoring user's config for user (%username%) from a file [%prepfile%]: "
rem	echo Starting restoring user's config for user ^(%username%^) from a file prep_%username%.7z
echo Restoring user's config for user ^(%username%^) from a file [%prepfile%]. >>%logfile%
rem	:subr_extract_content
rem	������������� �����.
rem	%z7% ������ ���� ��� ���������.
call :subr_extract_content %prepfile% %logfile%
echo OK.
echo A restoration user's config is OK. >>%logfile%
rem pause
if %debug%==1 echo ===control point 7===
echo ===control point 7===. >>%logfile%



rem	==============cut start=====================
rem 	- start launcher.exe
echo.
echo.
echo Starting Allods Online Launcher, please don't close this black window!
echo Just play now!
echo Starting launcher %lau%. >>%logfile%
start "XD" /wait %lau%
IF ERRORLEVEL 9059 (
 rem	Strange. O_o
 echo Error. Launcher not found
 echo Error. Launcher not found >>%logfile%
 pause
 exit
)
echo Launcher has been terminated. >>%logfile%
echo Launcher has been terminated just now.
if %debug%==1 echo ===control point 8===
echo ===control point 8===. >>%logfile%



rem	���������, ������� �� ������� aogame.exe?
rem	�� ����� � ����, ���� �� �������� ��������� ���� ���������� �������,
rem	� ����� � �� ����, ���� ������� ����� �����������
rem	��� ��� �������� �������, ������ �� ��������.
rem	��� ���� ��������������� � ������ ����� ������� � �������������.
rem	������� �������� ��� �������� ����:
rem	������������ ���� (��������� �������� ���� ��� �������)
rem	��� launcher, ���� ���� ����� �����������, ����� �������������
rem	��� ������� ���� (��� �� launcher)
rem	������ � ���������� ��������� �� ����������� �������� ����.
rem	������� ������, �.� ��� �������������� �������� �������.

echo.|set/p yvar="Checking is AOgame process still present in memory: "
rem	echo Checking presence of AOgame process
rem pause
set process_to_check=AOgame.exe
rem	set aogameispresent=1

QPROCESS * | find /i "%process_to_check%" >nul 2>&1 && (
    echo present.
    rem 	echo process %process_to_check% present now!
    %sleep% 5
    rem	set aogameispresent=2
    rem pause
) || (
    echo NOT present.
    rem	echo process %process_to_check% is not running
    rem 	echo process %process_to_check% is not running
    %sleep% 5
    rem	set aogameispresent=1
    rem pause
)
if %debug%==1 echo ===control point 8a ===
echo ===control point 8a ===. >>%logfile%


echo.|set/p yvar="Waiting terminating all game's components: "
:point2j
set flagw2=1
rem	---������� ������� �������� ����� ����
	set cesstocheck=AOgame.exe
QPROCESS * | find /i "%cesstocheck%" >nul 2>&1 && (
    rem	echo process %cesstocheck% still running
    echo.|set/p yvar="."
    set flagw2=2
    %sleep% 15
  ) || (
     rem	echo process %cesstocheck% NOT running
     rem	set flagw2=1
     rem	%sleep% 5
)

rem	---������� ������� launcher ����
	set cesstocheck=Launcher.exe
QPROCESS * | find /i "%cesstocheck%" >nul 2>&1 && (
    rem	echo process %cesstocheck% still running
    echo.|set/p yvar="l"
    set flagw2=2
    %sleep% 15
  ) || (
     rem	echo process %cesstocheck% NOT running
     rem	set flagw2=1
     rem	%sleep% 5
)

rem	---������� ������� ������������� ���� (��������� �������� ��� �������)
	set cesstocheck=SyncVersion.exe
QPROCESS * | find /i "%cesstocheck%" >nul 2>&1 && (
    rem	echo process %cesstocheck% still running
    echo.|set/p yvar="u"
    set flagw2=2
    %sleep% 15
  ) || (
     rem	echo process %cesstocheck% NOT running
     rem	set flagw2=1
     rem	%sleep% 5
)

rem	---������� ������� �������-������� ����
	set cesstocheck=CrashSender1402.exe
QPROCESS * | find /i "%cesstocheck%" >nul 2>&1 && (
    rem	echo process %cesstocheck% still running
    echo.|set/p yvar="x"
    set flagw2=2
    %sleep% 15
  ) || (
     rem	echo process %cesstocheck% NOT running
     rem	set flagw2=1
     rem	%sleep% 5
)

if %flagw2%==2    goto :point2j
if %debug%==1 echo ===control point 8b ===
echo ===control point 8b ===. >>%logfile%

echo Done.
echo There are no more games' processes found. >>%logfile%


echo.|set/p yvar="Pause 15 secs... "
echo Pause 15 secs for continueing. >>%logfile%
%sleep% 15
rem	����� ����� ��� ����� ����������� �����.
rem	���� ��� �����, �� ������ ��������� ����� ��� ��� �� �������� ������-��.
echo OK
echo Pause 15 secs is ended. >>%logfile%

rem	==============cut end=======================

rem	���������� ��������� � ������ ����� ������������
echo.|set/p yvar="Saving changes in %1's profile [%prepfile%]: "
rem	echo Saving changes in user's profile prep_%username%.7z
echo Saving changes in user's [%1] profile [%prepfile%]. >>%logfile%
rem	:subr_pack_content_and_delete
rem	����������� ���������� ��������� � �������� � ����, ����� ����� ������� �������� �����.
rem	%z7% ������ ���� ��� ���������.
call :subr_pack_content_and_delete %prepfile% %logfile%
echo OK.
echo Saving user's config is OK. Continueing. >>%logfile%
rem pause


rem	� ��������������� �������������� ���������.
rem 	- ������������ ����������� ������������ ������� � usercfg
echo.|set/p yvar="Restoring initial configuration from %rollbackarchive%: "
echo Restoring initial configuration from %rollbackarchive%. >>%logfile%
rem	echo We Restoring initial state.
rem	:subr_extract_content
rem	������������� �����.
rem	%z7% ������ ���� ��� ���������.
call :subr_extract_content %rollbackarchive% %logfile%
echo OK
echo Restoring state is OK from %rollbackarchive%. >>%logfile%

rem	������� rollback ����� 
del %rollbackarchive%
echo Delete %rollbackarchive% = OK. >>%logfile%

echo Account switcher for MMORPG Allods Online - normal termination.
echo Normal end of script. >>%logfile%
pause
endlocal
exit /b



rem	��������� �������� ������:
rem	- �������� "�����������" ���������� ������ ����������� ����
rem	  - ���� ���� "�����������", �� ������������ �������������� ��������� �� ����� ������.
rem	- ��������� ������� ��������� ������� � usercfg
rem	- �� ������ ����� ������� ������������ �������� ���� ����� ������� � usercfg
rem	- start launcher.exe
rem	- �������� ���������� ������ ���� � ���� � ���������.
rem	- ��������� ����� ������� � usercfg �������� � ����� ����� ������������
rem	- ������������ ����������� ������������ ������� � usercfg






rem	=================================================================
:subr_test_archive
rem	��������� ���������� ������ �� ������������ �������������.
rem	%z7% ������ ���� ��� ���������.
rem	param1	��� ������, ���� ���������
rem	param2	��� ���-�����, ���� ����������.
if a%z7%o==ao (
  rem	��� ����������
  echo Error: subr_test_archive: No 7Zip standalone executable set.
  pause
  exit 
  rem	exit /b 1
)
if a%1o==ao (
  rem	�� ������ �����
  echo Error: subr_test_archive: Archive filename not set.
  pause
  exit 
  rem	exit /b 2
)
if a%2o==ao (
  rem	�� ������� ��� ���-�����
  echo Error: subr_test_archive: Log filename not set.
  pause
  exit 
  rem	exit /b 3
)
rem	 >>%2 2>&1
%z7% t %1 >>%2
if errorlevel 1 (
  rem	���-�� �� �������� ��� ������ ����������
  echo Error: subr_pack_content: Archiving went wrong, read log file.
  pause
  exit 
  rem	exit /b 4
)
exit /b 0







rem	=================================================================
:subr_pack_content
rem	����������� ���������� ��������� � �������� � ����
rem	%z7% ������ ���� ��� ���������.
rem	param1	��� ������, ���� ���������
rem	param2	��� ���-�����, ���� ����������.
if a%z7%o==ao (
  rem	��� ����������
  echo Error: subr_pack_content: No 7Zip standalone executable set.
  pause
  exit 
  rem	exit /b 1
)
if a%1o==ao (
  rem	�� ������ �����
  echo Error: subr_pack_content: Archive filename not set.
  pause
  exit 
  rem	exit /b 2
)
if a%2o==ao (
  rem	�� ������� ��� ���-�����
  echo Error: subr_pack_content: Log filename not set.
  pause
  exit 
  rem	exit /b 3
)
rem	%z7% a %1 data\Mods\Addons\ Personal\user.cfg -sdel >>%2 2>&1
%z7% a %1 data\Mods\Addons\ Personal\user.cfg -sdel >>%2
if errorlevel 1 (
  rem	���-�� �� �������� ��� ������ ����������
  echo Error: subr_pack_content: Archiving went wrong, read log file.
  pause
  exit 
  rem	exit /b 4
)
exit /b 0


rem	=================================================================
:subr_pack_content_and_delete
rem	����������� ���������� ��������� � �������� � ����, ����� ����� ������� �������� �����.
rem	%z7% ������ ���� ��� ���������.
rem	param1	��� ������, ���� ���������
rem	param2	��� ���-�����, ���� ����������.
if a%z7%o==ao (
  rem	��� ����������
  echo Error: subr_pack_content_and_delete: No 7Zip standalone executable set.
  pause
  exit 
  rem	exit /b 1
)
if a%1o==ao (
  rem	�� ������ �����
  echo Error: subr_pack_content_and_delete: Archive filename not set.
  pause
  exit 
  rem	exit /b 2
)
if a%2o==ao (
  rem	�� ������� ��� ���-�����
  echo Error: subr_pack_content_and_delete: Log filename not set.
  pause
  exit 
  rem	exit /b 3
)
rem	%z7% a %1 data\Mods\Addons\ Personal\user.cfg -sdel >>%2 2>&1
%z7% a %1 data\Mods\Addons\ Personal\user.cfg -sdel >>%2
if errorlevel 1 (
  rem	���-�� �� �������� ��� ������ ����������
  echo Error: subr_pack_content_and_delete: Archiving went wrong, read log file.
  pause
  exit 
  rem	exit /b 4
)
exit /b 0

rem	=================================================================
:subr_extract_content
rem	������������� �����.
rem	%z7% ������ ���� ��� ���������.
rem	param1	��� ������, ����� ���� �����������.
rem	param2	��� ���-�����, ���� ����������.
if a%z7%o==ao (
  rem	��� ����������
  echo Error: subr_extract_content: No 7Zip standalone executable set.
  pause
  exit 
  rem	exit /b 1
)
if a%1o==ao (
  rem	�� ������ �����
  echo Error: subr_extract_content: Archive filename not set
  pause
  exit 
  rem	exit /b 2
)
if a%2o==ao (
  rem	�� ������� ��� ���-�����
  echo Error: subr_extract_content: Log filename not set
  pause
  exit 
  rem	exit /b 3
)
rem	%z7% x %1 >>%2 2>&1
%z7% x %1 >>%2 
if errorlevel 1 (
  rem	���-�� �� �������� ��� ������ ����������
  echo Error: subr_extract_content: Archiving went wrong, read log.
  pause
  exit 
  rem	exit /b 4
)
exit /b 0



rem	==������������� ������������ ����====

rem	:subr_test_archive
rem	��������� ���������� ������ �� ������������ �������������.
rem	%z7% ������ ���� ��� ���������.
rem	param1	��� ������, ��� �����������
rem	param2	��� ���-�����, ���� ����������.

rem	:subr_pack_content
rem	����������� ���������� ��������� � �������� � ����
rem	%z7% ������ ���� ��� ���������.
rem	param1	��� ������, ���� ���������
rem	param2	��� ���-�����, ���� ����������.

rem	:subr_pack_content_and_delete
rem	����������� ���������� ��������� � �������� � ����, ����� ����� ������� �������� �����.
rem	%z7% ������ ���� ��� ���������.
rem	param1	��� ������, ���� ���������
rem	param2	��� ���-�����, ���� ����������.

rem	:subr_extract_content
rem	������������� �����.
rem	%z7% ������ ���� ��� ���������.
rem	param1	��� ������, ����� ���� �����������.
rem	param2	��� ���-�����, ���� ����������.
