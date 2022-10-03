#include "..\script_macros.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

RUN_CLIENT_ONLY;
FORCE_SUSPEND("MPClient_fnc_preInit");
AH_CHECK_FINAL("life_var_preInitTime");

private _threadsToMonitor = [];
private _variablesFlagged = [];
private _playerVariables = [
    [GET_CASH_VAR, 0,true],
    ['restrained', false, true],
    ['Escorting', false, true],
    ['transporting', false, true],
    ['playerSurrender', false, true],
    ['realname', profileName, true],
    ['lifeState','HEALTHY',true]
];
private _missionVariables = [ 
    ["life_var_preInitTime", compileFinal str(diag_tickTime)],
    ["life_var_postInitTime", compile str(-1)],
    ["life_var_initTime", compile str(-1)],
    ["life_var_serverTimeout", 0],
    ["life_var_loadingScreenActive", false],
    ["life_var_actionDelay", time],
    ["life_var_vehicleTrunk", objNull],
    ["life_var_sirenActive", false],
    ["life_var_effectEnergyDrink", time],
    ["life_var_processingResource", false],
    ["life_var_gatheringResource", false],
    ["life_var_bailPaid", false],
    ["life_var_isBusy", false],
    ["life_var_vehicleStinger", objNull],
    ["life_var_knockoutBusy", false],
    ["life_var_interrupted", false],
    ["life_var_removeWanted", false],
    ["life_var_adminFrozen", false],
    ["life_var_gearWhenDied", []],
    ["life_var_activeContaineObject", objNull],
    ["life_var_preventGetIn", false],
    ["life_var_preventGetOut", false],
    ["life_var_position", []],
    ["life_var_markers", false],
    ["life_var_markers_active", false],
    ["life_var_canAffordBail", true],
    ["life_var_storagePlacing", scriptNull],
    ["life_var_firstSpawn", true],
    ["life_var_newlife", false],
    ["life_var_earplugs", false],
    ["life_var_autorun", false],
    ["life_var_combat", false],
    ["life_var_autorun_thread", scriptNull],
    ["life_var_autorun_inventoryOpened", false], 
    ["life_var_autorun_interrupt", false],
    ["life_var_lastSynced", time],
    ["life_var_weaponHolders", []],

    //--- Session
    ["life_var_sessionAttempts", 0],
    ["life_var_sessionDone", false],
    ["life_var_sessionGarageRequest", false],
    ["life_var_sessionGarageImpoundRequest", false],

    //--- Hud
    ["life_var_hud_threads", nil],
    ["life_var_hud_layer1shown", false],
    ["life_var_hud_layer1mode", 0],
    ["life_var_hud_partyespmode", 0],
    ["life_var_hud_eventhandle", -1],
    ["life_var_hud_lastgrprendered_at", diag_tickTime],
    ["life_var_hud_laststatsrendered_at", diag_tickTime],
    ["life_var_hud_lastvehrendered_at", diag_tickTime],
    ["life_var_hud_lastrendered_muzzle", ""],
    ["life_var_hud_lastrendered_grenadeclassname", ""],
    ["life_var_hud_lastrendered_vehclassname", ""],
    ["life_var_hud_lastrendered_vehfueltanksize", 0],
    ["life_var_hud_activelayer", 1],
    ["life_var_hud_thirst_lastval", 100],
    ["life_var_hud_hunger_lastval", 100],
    ["life_var_hud_lastlocation", ""],
    ["life_var_hud_waypoints", []],

    //--- Death system
    ["life_var_medicstatus", -1],
    ["life_var_medicstatusby", ""],
     
    //-- Hypothalamus
    ["life_var_thirst", 100],
    ["life_var_hunger", 100],
    ["life_var_bleeding", false],
    ["life_var_bleedingRunning", false],
    ["life_var_painShock", false],
    ["life_var_painShockRunning",false],
    ["life_var_critHit", false],
    ["life_var_critHitRunning",false],

    //--- cellphone
    ["life_var_phoneContacts", []],
    ["life_var_phoneMessages", []],
    ["life_var_phoneTarget", []],
    ["life_var_phoneFilter", false],

    //--- Settings
    ["life_var_enableNewsBroadcast", profileNamespace getVariable ["life_var_enableNewsBroadcast", true]],
    ["life_var_enableSidechannel", profileNamespace getVariable ["life_var_enableSidechannel", true]],
    ["life_var_enablePlayerTags", profileNamespace getVariable ["life_var_enablePlayerTags", true]],
    ["life_var_enableRevealObjects", profileNamespace getVariable ["life_var_enableRevealObjects", true]],
    ["life_var_viewDistanceFoot", profileNamespace getVariable ["life_var_viewDistanceFoot", 1250]],
    ["life_var_viewDistanceCar", profileNamespace getVariable ["life_var_viewDistanceCar", 1250]],
    ["life_var_viewDistanceAir", profileNamespace getVariable ["life_var_viewDistanceAir", 1250]],
    
    //--- Weight Variables
    ["life_var_maxCarryWeight", LIFE_SETTINGS(getNumber, "total_maxWeight")],
    ["life_var_carryWeight", 0], //Represents the players current inventory weight (MUST START AT 0).

    //--- Life Variables
    ["life_var_fishingNetOut", false],
    ["life_var_ATMEnabled", true],
    ["life_var_arrested", false],
    ["life_var_alive", false],
    ["life_var_deliveringPackage", false],
    ["life_var_tazed", false],
    ["life_var_unconscious", false],
    ["life_var_lastBalance",[0,0,0,0]],
    ["life_var_bankrupt", false],
    ["life_var_bankruptTime", nil],
 
    //--- Owned house, vehicles are added to this array
    ["life_var_vehicles", []],

    //--- Settings EVH
    ["life_var_playerTagsEVH", -1],
    ["life_var_revealObjectsEVH", -1],

    //--- RemoteExec related
    ["life_var_serverRequest",false],
    
    //--- Shop related
    ["life_var_clothingTraderData", [-1, -1, -1, -1, -1]],
    ["life_var_clothingTraderFilter", 0],
    ["life_var_vehicleTraderData",["",[],"Undefined",true]],
    ["life_var_marketConfig",createHashMap],
    ["life_var_adminShop",false],

    //
    ["life_var_licenses",createHashMap],

    //--- Money related
    [GET_BANK_VAR(player), 0],
    [GET_DEBT_VAR(player), 0],

    //-- Setup Gangs
    ["life_var_gangData", []],
    ["life_var_gangHideoutBuildings", (LIFE_SETTINGS(getArray,"gang_area")) apply {nearestBuilding(getMarkerPos _x)}]
];
private _parserVariables = [
    
];
private _profileVariables = [
    
];
private _uiVariables = [
    
];

//-- Setup VirtualItems
_missionVariables append (([objNull,false] call MPClient_fnc_getGear)#1);

//-- Setup Licenses
_missionVariables append ([objNull,false,false,false,false] call MPClient_fnc_getLicenses);

["Loading client preInit"] call MPClient_fnc_log;
["Life_var_initBlackout"] call BIS_fnc_blackOut;//fail safe for loading screen

//-- init Variables
{
    _x params ["_namespace", "_verifyIsNil", "_varlist"];

    {
        private _varName = _x param [0, ""];
        private _varValue =  _namespace getVariable [_varName,nil];
        private _varPublic =  _x param [2, false];

        if(isNil {_varValue} OR not(_verifyIsNil))then{
            _varValue =  _x param [1, nil];
            if(!isNil {_varValue})then{
                _namespace setVariable [_varName,_varValue,_varPublic];
            }else{
                _namespace setVariable [_varName,nil,_varPublic];
            };
        }else{
            _variablesFlagged pushBackUnique [_varName,_varValue];
        };
    }forEach _varlist;
} forEach [
    [missionNamespace,true,_missionVariables],
    [uiNamespace,true,_uiVariables],
    [profileNamespace,false,_profileVariables],
    [parsingNamespace,true,_parserVariables],
    [player,true,_playerVariables]
];

//-- flagged variable found. TODO: handle this through anticheat on server once detected
if(count _variablesFlagged > 0)exitWith{ 
    [0,format["[Antihack] Hacker Detected %1 Variables flagged",getPlayerUID player],true,[profileNameSteam, profileName]] remoteExecCall ["MPClient_fnc_broadcast",-2];
    [format ["[LIFE] %1 Variables flagged",count _variablesFlagged]] call MPClient_fnc_log;
    {[format ["[LIFE] %1 = %2;",_x#0,_x#1]] call MPClient_fnc_log; uiSleep 0.6}forEach _variablesFlagged;
    endMission "Antihack";
};

//-- save proflie vars
if(count _profileVariables > 0)then{
    saveProfileNamespace;
};

//-- Thread set 1 Monitor money vars TODO: handle this through anticheat 
_threadsToMonitor pushBackUnique (["bank"] spawn MPClient_fnc_checkMoney);
_threadsToMonitor pushBackUnique (["cash"] spawn MPClient_fnc_checkMoney);
_threadsToMonitor pushBackUnique (["gang"] spawn MPClient_fnc_checkMoney);
_threadsToMonitor pushBackUnique (["debt"] spawn MPClient_fnc_checkMoney);

//-- Load main init
[serverName,missionName,worldName,worldSize] spawn MPClient_fnc_init;

//-- Thread set 2
{_threadsToMonitor set [_forEachIndex, _x spawn {waitUntil {uiSleep floor(random 15);isNull _this};endMission "Antihack"}]}forEach _threadsToMonitor;

//-- Thread set 3
_threadsToMonitor spawn {uiSleep floor(random 30); {_x spawn {waitUntil {uiSleep floor(random 30);isNull _this};endMission "Antihack"}}forEach _this};_threadsToMonitor = nil;

//-- Check Client function are final
{
    private _cfgClientFunctions = missionConfigFile >> "cfgFunctions" >> _x;
    private _clientFunctions = [];
    for "_currentIndex" from 0 to (count(_cfgClientFunctions) - 1) do 
    {
        private _functionClassList = (_cfgClientFunctions >> configName (_cfgClientFunctions select _currentIndex));
        for "_currentInnerIndex" from 0 to (count(_functionClassList) - 1) do 
        {
            private _currentInnerItem = _functionClassList select _currentInnerIndex;
            _clientFunctions pushBackUnique (format ["%1_fnc_%2",_x,configName _currentInnerItem]);
        };
    };

    //-- Check all client function are final
    if ({isFinal (missionNamespace getVariable [_x, {}])} count _clientFunctions isNotEqualTo count _clientFunctions)then{
        for "_i" from 0 to 10 do{
            uiSleep 0.2;
            ["Warning Client Functions Not Final, Major Security Risk!",false,true] call MPClient_fnc_log;
        };
    };
}forEach [
    "MPClient"
];

//--
[format["Client preInit completed! Took %1 seconds",diag_tickTime - (call life_var_preInitTime)]] call MPClient_fnc_log;

//-- Preinit complete
true