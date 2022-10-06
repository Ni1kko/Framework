#include "..\..\clientDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
    ## fn_insertPlayerData.sqf (Client)
*/

FORCE_SUSPEND("MPClient_fnc_insertPlayerData");

if (life_var_sessionDone) exitWith { 
    ["`MPClient_fnc_insertPlayerData` => Session already completed"] call MPClient_fnc_log;
    false
};

if(life_var_loadingScreenActive)then{
    ["New Player! Who Dis?", "The server didn't find a database record matching your BEGuid, attempting to add player into our database."] call MPClient_fnc_setLoadingText; 
    uiSleep(random[0.5,3,6]);
};

["Session sending request to server to create your profile!"] call MPClient_fnc_log;
[player] remoteExecCall ["MPServer_fnc_insertPlayerDataRequest",2];