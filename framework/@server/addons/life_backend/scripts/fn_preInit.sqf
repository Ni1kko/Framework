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
    
];

private _masterGroup = group(missionNamespace getVariable ["mastergroup",objNull]);
private _nameTagCount = (count(missionConfigFile >> "RscTitles" >> "RscTitleNameTags" >> "controls") - 1);
private _playableSlots = (playableSlotsNumber west + playableSlotsNumber east + playableSlotsNumber independent + playableSlotsNumber civilian);
private _variablesFlagged = [/*DON'T EDIT*/];

//-- setup sides
serverSide = createcenter sidelogic;
clientSide = sideEmpty;
AISide = createcenter resistance;
wildLifeSide = sideAmbientLife;

//-- setup groups
serverGroup = creategroup [serverSide,false];
clientGroup = creategroup [clientSide,false];
bankGroup = creategroup [serverSide,false];
AIGroup = creategroup [AISide,false];
wildLifeGroup = creategroup [wildLifeSide,false];

//-- Setup GroupIDs
serverGroup setGroupIdGlobal ["Server", GROUP_COLOR_BLACK];
clientGroup setGroupIdGlobal ["Client", GROUP_COLOR_BLACK];
wildLifeGroup setGroupIdGlobal ["wildLife", GROUP_COLOR_YELLOW];
AIGroup setGroupIdGlobal ["Traders", GROUP_COLOR_GREEN];
bankGroup setGroupIdGlobal ["Bank", GROUP_COLOR_GREEN];

//-- setup logic
serverLogicNameSpace =  serverGroup createunit ["Logic",[0,0,0],[],0,"none"];
clientLogicNameSpace =  clientGroup createunit ["Logic",[1,1,1],[],0,"none"];
bankNameSpace =         bankGroup createunit ["Logic",[2,2,2],[],0,"none"];
AINameSpace =           AIGroup createunit ["Logic",[3,3,3],[],0,"none"];
wildlifeNameSpace =     wildLifeGroup createunit ["Logic",[3,3,3],[],0,"none"];
virtualNamespace =      serverGroup createunit ["Logic",[4,4,4],[],0,"none"];

//-- Attach groups to protection zone
serverLogicNameSpace attachTo[serverProtectionZone,[0,0,0]];
clientLogicNameSpace attachTo[serverLogicNameSpace,[0,0,0]];
bankNameSpace attachTo[serverLogicNameSpace,[0,0,0]];
AINameSpace attachTo[serverLogicNameSpace,[0,0,0]];
wildlifeNameSpace attachTo[serverLogicNameSpace,[0,0,0]];
virtualNamespace attachTo[serverLogicNameSpace,[0,0,0]];

//-- Transfer NPC group
if not(isNull _masterGroup) then {
    (units _masterGroup) joinSilent AIGroup;
    deleteGroup _masterGroup;
    mastergroup = objNull;
    publicVariable "mastergroup";
};

//-- Make all sides netural against NPCs and NPCs netural against all sides
{
    _x setFriend [AISide,1];
    AISide setFriend [_x,1];
}forEach [
    civilian,
    independent,
    west,
    east
];

//-- Save NPCs that were created/loaded at game start
serverLogicNameSpace setvariable ["TrustedTraders",units serverGroup, true];

//-- Setup vitual inventory
virtualNamespace setvariable ["allvitems",[],true];
virtualNamespace setvariable ["maxspace",1000,true];

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
                serverLogicNameSpace setvariable [_varName,_x param [1, nil],true];
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
	[bankNameSpace, _bankVariables]
];

//-- flagged variable found. TODO: handle this through anticheat on server once detected
if(count _variablesFlagged > 0)exitWith{ 
    RPT_FILE_LB;
    [format ["[LIFE] %1 Variables flagged during preInit",count _variablesFlagged]] call MPServer_fnc_log;
    {[format ["[LIFE] %1 = %2;",_x#0,_x#1]] call MPServer_fnc_log; uiSleep 0.6}forEach _variablesFlagged;
	life_var_endMissionServerJIP = ["","","Antihack"] remoteExec ["MPClient_fnc_endMission", -2, true];
	life_var_endMissionClientJIP = ["Antihack"] remoteExec ["BIS_fnc_endMissionServer", 2, true];
	false
};

//-- Send clients from setting up client to waiting for server
waitUntil {not(isNil "life_var_serverLoaded")};
publicVariable "life_var_serverLoaded";

//-- setup logic across all servers, clients 
{publicVariable _x} forEach ["serverLogicNameSpace","clientLogicNameSpace","bankNameSpace","wildlifeNameSpace","virtualNamespace"];

//-- save proflie vars
if(count _profileVariables > 0)then{
    saveProfileNamespace;
};

//-- save mission proflie vars
if(count _missionProfileVariables > 0)then{
    saveMissionProfileNamespace;
};

//-- setup name tags
if(_playableSlots > _nameTagCount)then{
    RPT_FILE_LB;
    [format ["[LIFE] %1 playable slots detected. But only %2 name tags available. Please add name tags in config",_playableSlots,_nameTagCount]] call MPServer_fnc_log;
};

private _initThread = [serverName,missionName,worldName,worldSize] spawn MPServer_fnc_init;
waitUntil {scriptDone _initThread};

[format["Server preInit completed! Took %1 seconds",diag_tickTime - (call life_var_preInitTime)]] call MPServer_fnc_log;

true