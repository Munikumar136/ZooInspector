@REM ----------------------------------------------------------------------------
@REM Copyright 2001-2004 The Apache Software Foundation.
@REM
@REM Licensed under the Apache License, Version 2.0 (the "License");
@REM you may not use this file except in compliance with the License.
@REM You may obtain a copy of the License at
@REM
@REM      http://www.apache.org/licenses/LICENSE-2.0
@REM
@REM Unless required by applicable law or agreed to in writing, software
@REM distributed under the License is distributed on an "AS IS" BASIS,
@REM WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
@REM See the License for the specific language governing permissions and
@REM limitations under the License.
@REM ----------------------------------------------------------------------------
@REM

@REM @echo off

set ERROR_CODE=0

:init
@REM Decide how to startup depending on the version of windows

@REM -- Win98ME
if NOT "%OS%"=="Windows_NT" goto Win9xArg

@REM set local scope for the variables with windows NT shell
if "%OS%"=="Windows_NT" @setlocal

@REM -- 4NT shell
if "%eval[2+2]" == "4" goto 4NTArgs

@REM -- Regular WinNT shell
set CMD_LINE_ARGS=%*
goto WinNTGetScriptDir

@REM The 4NT Shell from jp software
:4NTArgs
set CMD_LINE_ARGS=%$
goto WinNTGetScriptDir

:Win9xArg
@REM Slurp the command line arguments.  This loop allows for an unlimited number
@REM of arguments (up to the command line limit, anyway).
set CMD_LINE_ARGS=
:Win9xApp
if %1a==a goto Win9xGetScriptDir
set CMD_LINE_ARGS=%CMD_LINE_ARGS% %1
shift
goto Win9xApp

:Win9xGetScriptDir
set SAVEDIR=%CD%
%0\
cd %0\..\.. 
set BASEDIR=%CD%
cd %SAVEDIR%
set SAVE_DIR=
goto repoSetup

:WinNTGetScriptDir
set BASEDIR=%~dp0\..

:repoSetup

if "%JAVACMD%"=="" set JAVACMD=java

if "%REPO%"=="" set REPO=C:\zooinspector-pkg-tls1.2\repo\jar_files

set CLASSPATH="%BASEDIR%"\conf;"%REPO%"\log4j-1.2.17.jar;"%REPO%"\slf4j-api-1.7.30.jar;"%REPO%"\slf4j-log4j12-1.7.30.jar;"%REPO%"\zookeeper-3.7.0.jar;"%REPO%"\zookeeper-jute-3.7.0.jar;"%REPO%"\commons-lang-2.1.jar;"%REPO%"\netty-all-4.1.59.Final.jar;"%REPO%"\netty-handler-4.1.59.Final.jar;"%REPO%"\guava-18.0.jar;"%REPO%"\zookeeper-contrib-zooinspector-3.7.0.jar

set EXTRA_JVM_ARGUMENTS=-Xms512m -Xmx512m -Dzookeeper.clientCnxnSocket=org.apache.zookeeper.ClientCnxnSocketNetty -Dzookeeper.ssl.keyStore.location=../conf/stores/domain -Dzookeeper.ssl.keyStore.password=Travelport1StorePass -Dzookeeper.ssl.trustStore.location=../conf/stores/domainTrust -Dzookeeper.ssl.trustStore.password=Travelport1StorePass -Dzookeeper.ssl.keyStore.type=jks -Dzookeeper.ssl.trustStore.type=jks -Dzookeeper.ssl.hostnameVerification=false -Dzookeeper.ssl.quorum.hostnameVerification=false

@REM ========== This flag needed for SSL (set this to "true") to remote ZK servers (or) Non-SSL (set this to "false") to ZK servers on local machine ==========
set EXTRA_JVM_ARGUMENTS=%EXTRA_JVM_ARGUMENTS% -Dzookeeper.client.secure=false 

@REM Use these options: if connections are not established with ZK nodes or if failing to do a successful SSL handshake
@REM -Djavax.net.debug=ssl,handshake,all -Dhttp.keepAlive="true"
goto endInit

@REM Reaching here means variables are defined and arguments have been captured
:endInit

%JAVACMD% %JAVA_OPTS% %EXTRA_JVM_ARGUMENTS% -classpath %CLASSPATH_PREFIX%;%CLASSPATH% -Dapp.name="zooinspector" -Dapp.repo="%REPO%" -Dbasedir="%BASEDIR%" org.apache.zookeeper.inspector.ZooInspector %CMD_LINE_ARGS%
if ERRORLEVEL 1 goto error
goto end

:error
if "%OS%"=="Windows_NT" @endlocal
set ERROR_CODE=1

:end
@REM set local scope for the variables with windows NT shell
if "%OS%"=="Windows_NT" goto endNT

@REM For old DOS remove the set variables from ENV - we assume they were not set
@REM before we started - at least we don't leave any baggage around
set CMD_LINE_ARGS=
goto postExec

:endNT
@endlocal

:postExec

if "%FORCE_EXIT_ON_ERROR%" == "on" (
  if %ERROR_CODE% NEQ 0 exit %ERROR_CODE%
)

exit /B %ERROR_CODE%
