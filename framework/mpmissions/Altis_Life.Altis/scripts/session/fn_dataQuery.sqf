/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

if (life_session_completed) exitWith {
    diag_log "Framework: `fn_dataQuery` => Session already completed";
    false
};

if(life_var_loadingScreenActive)then{
    ["Data Request", "Sending request to server for your data...."] call MPClient_fnc_setLoadingText; 
    uiSleep(random[0.5,3,6]);
};

diag_log "Framework: Session sending request to server for data!";
[player] remoteExec ["MPServer_fnc_queryRequest",2];

true