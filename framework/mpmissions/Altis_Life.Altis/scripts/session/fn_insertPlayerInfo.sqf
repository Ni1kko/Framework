/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

if (life_session_completed) exitWith { 
    ["`MPClient_fnc_insertPlayerInfo` => Session already completed"] call MPClient_fnc_log;
    false
};

if(life_var_loadingScreenActive)then{
    ["New Player! Who Dis?", "The server didn't find a database record matching your BEGuid, attempting to add player into our database."] call MPClient_fnc_setLoadingText; 
    uiSleep(random[0.5,3,6]);
};

["Session sending request to server to create your profile!"] call MPClient_fnc_log;
[player] remoteExecCall ["MPServer_fnc_insertRequest",2];