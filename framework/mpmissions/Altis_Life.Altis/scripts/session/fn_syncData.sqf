/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
    ## fn_syncData.sqf (Client)
*/
params [
    ["_force",false,[false]],
    ["_silent",false,[false]],
    ["_messages",[],[[]]]
]; 

_messages params [
    ["_onSuccses", "Syncing player information to Hive"],
    ["_onFailure", localize "STR_Session_SyncdAlready"]
]; 

private _syncNotReady = (time - life_var_lastSynced) < (getNumber(missionConfigFile >> "life_session" >> "manualSaveInterval") * 60);
private _syncOverride = _force OR (player call life_isdev);

if (_syncNotReady AND not(_syncOverride)) exitWith {
    hint _onFailure;
    false
};

[] call MPClient_fnc_updateRequest;
//life_var_lastSynced = time;

if !_silent then {
    hint format["%1\n\nPlease wait atleast 10 seconds before leaving",_onSuccses];
};

true