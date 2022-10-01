/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
    ## fn_syncData.sqf (Client)
*/
params [
    ["_force",false,[false]],
    ["_silent",false,[false]],
    ["_messages",[],[[]]],
    ["_savePNS",true,[false]]
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

//-- Sync data to the server
[] call MPClient_fnc_updateRequest;

//-- Saves the variables stored in profileNamespace to the persistent active user profile
if _savePNS then {saveProfileNamespace};

if !_silent then {
    hint format["%1\n\nPlease wait atleast 10 seconds before leaving",_onSuccses];
};

true