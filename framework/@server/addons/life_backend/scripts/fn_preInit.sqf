/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

if (hasInterface)exitWith{false};
if !(canSuspend)exitWith{_this spawn MPServer_fnc_preInit; false};
if (isFinal "life_var_preInitTime")exitWith{false};

["Loading server preInit"] call MPServer_fnc_log;

private _variablesFlagged = [];
private _variableTooSet = [
    ["life_var_preInitTime", compileFinal str(diag_tickTime)],
    ["life_var_postInitTime", compile str(-1)],
    ["life_var_initTime", compile str(-1)],
	["life_var_serverLoaded", false],
	["life_var_severVehicles", []],
	["life_var_severScheduler", []],
	["life_var_playtimeValues", []],
	["life_var_playtimeValuesRequest", []],
	["life_var_radioChannels", []],
	["life_var_corpses", []],
	["life_var_banksReady", {false}],
	["life_var_banks", []],
	["life_var_atms", []],
	["life_var_spawndAnimals", []],
	["life_var_severSchedulerStartUpQueue", {[]}],
	["life_var_clientConnected", -1],
	["life_var_clientDisconnected", -1],
	["life_var_handleDisconnectEVH", -1],
	["life_var_entityRespawnedEVH", -1]
];

//-- init Variables
{
    private _varName = _x param [0, ""];
    private _varValue =  missionNamespace getVariable [_varName,nil];

    if(isNil {_varValue})then{
        _varValue =  _x param [1, nil];
        if(!isNil {_varValue})then{
            missionNamespace setVariable [_varName,_varValue];
        };
    }else{
        _variablesFlagged pushBackUnique [_varName,_varValue];
    };
} forEach _variableTooSet;
 
//-- flagged variable found. TODO: handle this through anticheat on server once detected
if(count _variablesFlagged > 0)exitWith{ 
   [format ["[LIFE] %1 Variables flagged during preInit",count _variablesFlagged]] call MPServer_fnc_log;
    {[format ["[LIFE] %1 = %2;",_x#0,_x#1]] call MPServer_fnc_log; uiSleep 0.6}forEach _variablesFlagged;
    endMission "END1";
};

private _initThread = [serverName,missionName,worldName,worldSize] spawn MPServer_fnc_init;
waitUntil {scriptDone _initThread};

[format["Server preInit completed! Took %1 seconds",diag_tickTime - (call life_var_preInitTime)]] call MPServer_fnc_log;

true