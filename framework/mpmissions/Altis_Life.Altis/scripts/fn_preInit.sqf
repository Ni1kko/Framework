#include "..\script_macros.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/
if !(canSuspend)exitWith{_this spawn MPClient_fnc_preInit; false};
if !(hasInterface)exitWith{false};

if (isFinal "life_var_preInitTime")exitWith{ 
    ["Hack Detected", "`life_var_preInitTime` already final, Client looping or hacker detected", "Antihack"] call MPClient_fnc_endMission;
    false;
};

["Loading client preInit"] call MPClient_fnc_log;
waitUntil{uiSleep 0.5;(getClientState isEqualTo "BRIEFING READ") && !isNull findDisplay 46};

private _threadsToMonitor = [];
private _variablesFlagged = [];
private _variableTooSet = [ 
    ["life_var_preInitTime", compileFinal str(diag_tickTime)],
    ["life_var_postInitTime", compile str(-1)],
    ["life_var_initTime", compile str(-1)],
    ["life_var_serverTimeout", 0],
    ["life_var_loadingScreenActive", false],
    ["life_action_delay", time],
    ["life_trunk_vehicle", objNull],
    ["life_session_completed", false],
    ["life_garage_store", false],
    ["life_var_session_attempts", 0],
    ["life_siren_active", false],
    ["life_clothing_filter", 0],
    ["life_redgull_effect", time],
    ["life_is_processing", false],
    ["life_bail_paid", false],
    ["life_impound_inuse", false],
    ["life_var_isBusy", false],
    ["life_spikestrip", objNull],
    ["life_knockout", false],
    ["life_interrupted", false],
    ["life_removeWanted", false],
    ["life_action_gathering", false],
    ["life_frozen", false],
    ["life_var_gearWhenDied", []],
    ["life_container_activeObj", objNull],
    ["life_disable_getIn", false],
    ["life_disable_getOut", false],
    ["life_admin_debug", false],
    ["life_position", []],
    ["life_markers", false],
    ["life_markers_active", false],
    ["life_canpay_bail", true],
    ["life_storagePlacing", scriptNull],
    ["life_firstSpawn", true],
    ["life_var_newlife", false],
    ["life_var_earplugs", false],
    ["life_var_autorun", false],
    ["life_var_combat", false],
    ["life_var_autorun_thread", scriptNull],
    ["life_var_autorun_inventoryOpened", false], 
    ["life_var_autorun_interrupt", false],
    ["life_var_lastSynced", time],
    ["life_var_weaponHolders", []],

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
    ["life_cellphone_contacts", []],
    ["life_cellphone_messages", []],
    ["life_cellphone_receiver", []],
    ["life_cellphone_filterWorking", false],

    //--- Settings
    ["life_settings_enableNewsBroadcast", profileNamespace getVariable ["life_enableNewsBroadcast", true]],
    ["life_settings_enableSidechannel", profileNamespace getVariable ["life_enableSidechannel", true]],
    ["life_settings_tagson", profileNamespace getVariable ["life_settings_tagson", true]],
    ["life_settings_revealObjects", profileNamespace getVariable ["life_settings_revealObjects", true]],
    ["life_settings_viewDistanceFoot", profileNamespace getVariable ["life_viewDistanceFoot", 1250]],
    ["life_settings_viewDistanceCar", profileNamespace getVariable ["life_viewDistanceCar", 1250]],
    ["life_settings_viewDistanceAir", profileNamespace getVariable ["life_viewDistanceAir", 1250]],

    //--- Uniform price (0),Hat Price (1),Glasses Price (2),Vest Price (3),Backpack Price (4)
    ["life_clothing_purchase", [-1, -1, -1, -1, -1]],
    
    //--- Weight Variables
    ["life_maxWeight", LIFE_SETTINGS(getNumber, "total_maxWeight")],
    ["life_var_carryWeight", 0], //Represents the players current inventory weight (MUST START AT 0).

    //--- Life Variables
    ["life_net_dropped", false],
    ["life_var_ATMEnabled", true],
    ["life_is_arrested", false],
    ["life_is_alive", false],
    ["life_delivery_in_progress", false], 
    ["life_var_cash", 0],
    ["life_istazed", false],
    ["life_isknocked", false],
    ["life_var_debtOwed", 0],
    ["life_var_lastBalance",[0,0,0]],
    ["life_var_bankrupt", false],

    //--- Owned house, vehicles are added to this array
    ["life_vehicles", []],

    //--- Settings EVH
    ["life_var_playerTagsEVH", -1],
    ["life_var_revealObjectsEVH", -1],

    //--- RemoteExec related
    ["life_var_serverRequest",false],
    
    //--- Shop related
    ["life_var_vehicleTraderData",["",[],"Undefined",true]],

    //-- Setup Gang hideouts
    ["life_hideoutBuildings", (LIFE_SETTINGS(getArray,"gang_area")) apply {nearestBuilding(getMarkerPos _x)}]
];

//-- Setup VirtualItems
_variableTooSet append (([player,false] call MPClient_fnc_getGear)#1);

//-- Setup Licenses
_variableTooSet append ([player,false] call MPClient_fnc_getLicenses);

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
    [0,format["[Antihack] Hacker Detected %1 Variables flagged",getPlayerUID player],true,[profileNameSteam, profileName]] remoteExecCall ["MPClient_fnc_broadcast",-2];
    [format ["[LIFE] %1 Variables flagged",count _variablesFlagged]] call MPClient_fnc_log;
    {[format ["[LIFE] %1 = %2;",_x#0,_x#1]] call MPClient_fnc_log; uiSleep 0.6}forEach _variablesFlagged;
    endMission "Antihack";
};

//-- Thread set 1 Monitor money vars TODO: handle this through anticheat 
_threadsToMonitor pushBackUnique (["bank"] spawn MPClient_fnc_checkMoney);
_threadsToMonitor pushBackUnique (["cash"] spawn MPClient_fnc_checkMoney);

//-- Start client
private _initThread = [serverName,missionName,worldName,worldSize] spawn MPClient_fnc_init;
waitUntil {scriptDone _initThread};

//-- Thread set 2
{_threadsToMonitor set [_forEachIndex, _x spawn {waitUntil {uiSleep floor(random 15);isNull _this};endMission "Antihack"}]}forEach _threadsToMonitor;

//-- Thread set 3
_threadsToMonitor spawn {uiSleep floor(random 30); {_x spawn {waitUntil {uiSleep floor(random 30);isNull _this};endMission "Antihack"}}forEach _this};_threadsToMonitor = nil;

[format["Client preInit completed! Took %1 seconds",diag_tickTime - (call life_var_preInitTime)]] call MPClient_fnc_log;

true