#include "\life_backend\serverDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

RUN_DEDI_SERVER_ONLY;
FORCE_SUSPEND("MPServer_fnc_preInit");
AH_CHECK_FINAL("life_var_preInitTime");

["Loading server preInit"] call MPServer_fnc_log;

//-- missionNamespace
private _missionVariables = [
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
	["life_var_entityRespawnedEVH", -1],
    ["life_var_animalTypes",[
        "Snake_random_F",
        "Sheep_random_F", 
        "Goat_random_F", 
        "Hen_random_F", 
        "Cock_random_F", 
        "Rabbit_F",
        "Salema_F", 
        "Ornate_random_F", 
        "Mackerel_F", 
        "Tuna_F", 
        "Mullet_F", 
        "CatShark_F", 
        "Turtle_F"
    ]],
    ["life_var_animalTypesRestricted", []]
];
//-- parsingNamespace
private _parserVariables = [
    
];
//-- profileNamespace
private _profileVariables = [
    
];
//-- missionProfileNamespace
private _missionProfileVariables = [
    
];
//-- localNamespace
private _localVariables = [

];
//-- uiNamespace
private _uiVariables = [

];
//-- serverNamespace
private _serverVariables = [

];
//-- Bank Object vars
private _bankVariables = [
	["TrustedTraders",[], true]
];

//-- Setup Restricted animals
{{life_var_animalTypesRestricted pushBackUnique toLower _x}forEach (getArray _x)}ForEach [
    missionConfigFile >> "cfgMaster" >> "animaltypes_fish",
    missionConfigFile >> "cfgMaster" >> "animaltypes_hunting",
    configFile >> "CfgEnviroment" >> "wildLife"
];

private _bankObject = missionNamespace getVariable ["bank_obj",objNull];
private _variablesFlagged = [/*DON'T EDIT*/];

//-- init Variables
{
    _x params ["_namespace", "_varlist"];
    
    if(count _varlist > 0)then 
    {
        private _broadcast = false;
        private _checkNil = false;
        
        switch (true) do
        {
            //--- Object 
            case (typeName _namespace isEqualTo "OBJECT"):
            {
                _broadcast = true;
                _checkNil = true;
            };
            //--- Namespace 
            case (typeName _namespace isEqualTo "NAMESPACE"):
            {
                _broadcast = _namespace isEqualTo missionNamespace;
                _checkNil = not(_namespace in [profileNamespace, missionProfileNamespace, uiNamespace]);
            };
            //--- Invalid namespace 
            default {_varlist resize 0};
        };
    
        {
            private _varName = _x param [0, ""];

            if(count _varName > 0)then
            {
                private _varValue =  _namespace getVariable [_varName,nil];
                private _data = [_varName, _x param [1, nil], _x param [2, false]];

                //-- Flag variable
                if(not(isNil {_varValue}) AND _checkNil)then{ 
                    _variablesFlagged pushBackUnique [_varName,_varValue];
                };

                //-- can namespace can broadcast
                if !_broadcast then {_data resize 2};

                //-- Set variable
                _namespace setVariable _data;
            };
        }forEach _varlist;
    };
} forEach [
    [missionNamespace,_missionVariables],
    [uiNamespace,_uiVariables],
    [profileNamespace,_profileVariables],
    [missionProfileNamespace,_missionProfileVariables],
    [parsingNamespace,_parserVariables],
    [localNamespace,_localVariables],
    [serverNamespace,_serverVariables],
	[_bankObject, _bankVariables]
];

//-- flagged variable found. TODO: handle this through anticheat on server once detected
if(count _variablesFlagged > 0)exitWith{ 
   [format ["[LIFE] %1 Variables flagged during preInit",count _variablesFlagged]] call MPServer_fnc_log;
    {[format ["[LIFE] %1 = %2;",_x#0,_x#1]] call MPServer_fnc_log; uiSleep 0.6}forEach _variablesFlagged;
	life_var_endMissionServerJIP = ["","","Antihack"] remoteExec ["MPClient_fnc_endMission", -2, true];
	life_var_endMissionClientJIP = ["Antihack"] remoteExec ["BIS_fnc_endMissionServer", 2, true];
	false
};

//-- save proflie vars
if(count _profileVariables > 0)then{
    saveProfileNamespace;
};

//-- save mission proflie vars
if(count _missionProfileVariables > 0)then{
    saveMissionProfileNamespace;
};

private _initThread = [serverName,missionName,worldName,worldSize] spawn MPServer_fnc_init;
waitUntil {scriptDone _initThread};

[format["Server preInit completed! Took %1 seconds",diag_tickTime - (call life_var_preInitTime)]] call MPServer_fnc_log;

true