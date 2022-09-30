#include "..\..\script_macros.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
    ## fn_dataQuery.sqf (Client)
*/

FORCE_SUSPEND("MPClient_fnc_dataQuery");

if (life_session_completed) exitWith {
    ["`MPClient_fnc_dataQuery` => Session already completed"] call MPClient_fnc_log;
    false
};

if(life_var_loadingScreenActive)then{
    ["Data Request", "Sending request to server for your data...."] call MPClient_fnc_setLoadingText; 
    uiSleep(random[0.5,3,6]);
};

["Session sending request to server for data!"] call MPClient_fnc_log;
[player] remoteExec ["MPServer_fnc_queryRequest",2];

true