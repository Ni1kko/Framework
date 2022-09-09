/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

if (life_session_completed) exitWith {
    diag_log "Framework: `fn_insertPlayerInfo` => Session already completed";
    false
};

if(life_var_loadingScreenActive)then{
    ["New Player! Who Dis?", "The server didn't find a database record matching your BEGuid, attempting to add player into our database."] call MPClient_fnc_setLoadingText; 
    uiSleep(random[0.5,3,6]);
};

[player] remoteExecCall ["MPServer_fnc_insertRequest",2];