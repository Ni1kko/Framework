#include "..\..\clientDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
    ## fn_fetchPlayerData.sqf (Client)
*/

FORCE_SUSPEND("MPClient_fnc_fetchPlayerData");

if (life_var_sessionDone) exitWith {
    ["`MPClient_fnc_fetchPlayerData` => Session already completed"] call MPClient_fnc_log;
    false
};

if(life_var_loadingScreenActive)then{
    ["Data Request", "Sending request to server for your data...."] call MPClient_fnc_setLoadingText; 
    sleep(random[0.5,3,6]);
};

["Session sending request to server for data!"] call MPClient_fnc_log;
[player] remoteExec ["MPServer_fnc_fetchPlayerDataRequest",2];

true