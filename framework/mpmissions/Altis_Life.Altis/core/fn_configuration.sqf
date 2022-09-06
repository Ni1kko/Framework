#include "..\script_macros.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/Framework
*/
private _variablesFlagged = [];
private _variableTooSet = [

    ["life_action_delay", time],
    ["life_trunk_vehicle", objNull],
    ["life_session_completed", false],
    ["life_garage_store", false],
    ["life_session_tries", 0],
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
    ["life_var_respawned", false],
    ["life_removeWanted", false],
    ["life_action_gathering", false],
    ["life_god", false],
    ["life_frozen", false],
    ["life_save_gear", []],
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
    ["life_var_bleeding", false],
    ["life_var_pain_shock", false],
    ["life_var_critHit", false],

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
    ["life_var_thirst", 100],
    ["life_var_hunger", 100],
    ["life_var_cash", 0],

    ["life_istazed", false],
    ["life_isknocked", false],
    ["life_vehicles", []],

    //-- Setup Gang hideouts
    ["life_hideoutBuildings", (LIFE_SETTINGS(getArray,"gang_area")) apply {nearestBuilding(getMarkerPos _x)}]
];

//-- Setup VirtualItems
{_variableTooSet pushBackUnique [ITEM_VARNAME(configName _x),0]} forEach ("true" configClasses (missionConfigFile >> "VirtualItems"));

//-- Setup Licenses
{ _variableTooSet pushBackUnique [LICENSE_VARNAME(getText(_x >> "variable"),getText(_x >> "side")),false]} forEach ("true" configClasses (missionConfigFile >> "Licenses"));

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
    diag_log format ["[LIFE] %1 Variables flagged",count _variablesFlagged];
    {diag_log (format ["[LIFE] %1 = %2;"] + _x)}forEach _variablesFlagged;
    endMission "Antihack";
};

true