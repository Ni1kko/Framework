@echo off

set servername=Administrator
set serverexe=arma3server
set serverpath=E:\ExtremoServer
set servermod=@server


::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::current dir
cd %serverpath%

::stop
timeout 4
taskkill /f /fi "status eq not responding" /im %serverexe%.exe
taskkill /f /im %serverexe%.exe
timeout 6

::paths
set configbattleye=%serverpath%\%servermod%\battleye
set configpath=%serverpath%\%servermod%\server_configs
set configserver=%configpath%\A3_DedicatedServer.cfg
set configbasic=%configpath%\A3_Performance.cfg
set configprofile=%configpath%\ServerData

::if exist pack.bat call pack.bat

::launch
start %serverexe%.exe "-port=2302" "-config=%configserver%" "-cfg=%configbasic%" "-profiles=%configprofile%" "-name=%servername%" "-servermod=%servermod%" "-bepath=%configbattleye%" "-enableHT" "-hugepages" "-bandwidthAlg=2" "-autoinit"

::notify
echo ARMA 3 Server has started .
echo Exiting.
timeout 3

::close
exit