#include "script_macros.hpp"
/*
    File: init.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Initialize the server and required systems.
    
    Edits by:
    ## Nanou - HeadlessClient optimization.
    ## Nikko Renolds - https://github.com/Ni1kko/Framework
*/

if(!canSuspend)exitwith{_this spawn life_fnc_preInit; true};
 
private _timeStamp = diag_tickTime;
diag_log "----------------------------------------------------------------------------------------------------";
diag_log "---------------------------------- Starting Altis Life Server Init ---------------------------------";
diag_log format["------------------------------------------ Version %1 -------------------------------------------",(LIFE_SETTINGS(getText,"framework_version"))];
diag_log "----------------------------------------------------------------------------------------------------";

life_var_serverLoaded = false;
life_var_hc_connected = false;
life_var_headlessClient = false;
life_var_saveCivPos = (LIFE_SETTINGS(getNumber,"save_civilian_position") isEqualTo 1);
life_var_severVehicles = [];
TON_fnc_playtime_values = [];
TON_fnc_playtime_values_request = [];
life_var_corpses = [];
publicVariable "life_var_serverLoaded";

if (EXTDB_SETTING(getNumber,"HeadlessSupport") isEqualTo 1) then {
    [] spawn TON_fnc_setupHeadlessClient;
};

if!(call life_fnc_rcon_initialize)exitwith{};
if!(call life_fnc_database_initialize)exitwith{};

private _serverDatabaseInit = [] spawn DB_fnc_loadServer;
waitUntil{scriptDone _serverDatabaseInit};

//--- Connection Event Handlers
life_var_clientConnected =    addMissionEventHandler ['PlayerConnected',    life_fnc_event_playerConnected,    []];
life_var_clientDisconnected = addMissionEventHandler ["PlayerDisconnected", life_fnc_event_playerDisconnected, []];

/* Map-based server side initialization. */
master_group attachTo[bank_obj,[0,0,0]];

{
    _hs = createVehicle ["Land_Hospital_main_F", [0,0,0], [], 0, "NONE"];
    _hs setDir (markerDir _x);
    _hs setPosATL (getMarkerPos _x);
    _var = createVehicle ["Land_Hospital_side1_F", [0,0,0], [], 0, "NONE"];
    _var attachTo [_hs, [4.69775,32.6045,-0.1125]];
    detach _var;
    _var = createVehicle ["Land_Hospital_side2_F", [0,0,0], [], 0, "NONE"];
    _var attachTo [_hs, [-28.0336,-10.0317,0.0889387]];
    detach _var;
    if (worldName isEqualTo "Tanoa") then {
        if (_forEachIndex isEqualTo 0) then {
            atm_hospital_2 setPos (_var modelToWorld [4.48633,0.438477,-8.25683]);
            vendor_hospital_2 setPos (_var modelToWorld [4.48633,0.438477,-8.25683]);
            "medic_spawn_3" setMarkerPos (_var modelToWorld [8.01172,-5.47852,-8.20022]);
            "med_car_2" setMarkerPos (_var modelToWorld [8.01172,-5.47852,-8.20022]);
            hospital_assis_2 setPos (_hs modelToWorld [0.0175781,0.0234375,-0.231956]);
        } else {
            atm_hospital_3 setPos (_var modelToWorld [4.48633,0.438477,-8.25683]);
            vendor_hospital_3 setPos (_var modelToWorld [4.48633,0.438477,-8.25683]);
            "medic_spawn_1" setMarkerPos (_var modelToWorld [-1.85181,-6.07715,-8.24944]);
            "med_car_1" setMarkerPos (_var modelToWorld [5.9624,11.8799,-8.28493]);
            hospital_assis_2 setPos (_hs modelToWorld [0.0175781,0.0234375,-0.231956]);
        };
    };
} forEach ["hospital_2","hospital_3"];

{
    if (!isPlayer _x) then {
        _npc = _x;
        {
            if (_x != "") then {
                _npc removeWeapon _x;
            };
        } forEach [primaryWeapon _npc,secondaryWeapon _npc,handgunWeapon _npc];
    };
} forEach allUnits;

[8,true,12] call LifeFSM_fnc_timeModule;

life_adminLevel = {0};
life_medicLevel = {0};
life_copLevel = {0};
CONST(JxMxE_PublishVehicle,"false");

/* Setup radio channels for west/independent/civilian */
life_radio_west = radioChannelCreate [[0, 0.95, 1, 0.8], "Side Channel", "%UNIT_NAME", []];
life_radio_civ = radioChannelCreate [[0, 0.95, 1, 0.8], "Side Channel", "%UNIT_NAME", []];
life_radio_indep = radioChannelCreate [[0, 0.95, 1, 0.8], "Side Channel", "%UNIT_NAME", []];

/* Set the amount of gold in the federal reserve at mission start */
fed_bank setVariable ["safe",count playableUnits,true];
[] spawn TON_fnc_federalUpdate;

/* Event handler for disconnecting players */
addMissionEventHandler ["HandleDisconnect",{_this call TON_fnc_clientDisconnect; false;}];

/* Set OwnerID players for Headless Client */
TON_fnc_requestClientID =
{
    (_this select 1) setVariable ["life_clientID", owner (_this select 1), true];
};
"life_fnc_RequestClientId" addPublicVariableEventHandler TON_fnc_requestClientID;

/* Event handler for logs */
"money_log" addPublicVariableEventHandler {diag_log (_this select 1)};
"advanced_log" addPublicVariableEventHandler {diag_log (_this select 1)};

/* Miscellaneous mission-required stuff */
life_wanted_list = [];

cleanupFSM = [] call LifeFSM_fnc_cleanup;

[] spawn {
    for "_i" from 0 to 1 step 0 do {
        uiSleep (30 * 60);
        {
            _x setVariable ["sellers",[],true];
        } forEach [Dealer_1,Dealer_2,Dealer_3];
    };
};

[] spawn TON_fnc_initHouses;
cleanup = [] spawn TON_fnc_cleanup;

//--- 
{publicVariable _x}forEach[
    "TON_fnc_terrainSort",
    "TON_fnc_player_query",
    "TON_fnc_index",
    "TON_fnc_isNumber",
    "TON_fnc_clientGangKick",
    "TON_fnc_clientGetKey",
    "TON_fnc_clientGangLeader",
    "TON_fnc_clientGangLeft",
    "TON_fnc_cell_textmsg",
    "TON_fnc_cell_textcop",
    "TON_fnc_cell_textadmin",
    "TON_fnc_cell_adminmsg",
    "TON_fnc_cell_adminmsgall",
    "TON_fnc_cell_emsrequest",
    "TON_fnc_clientMessage",
    "TON_fnc_playtime_values_request",
    "TON_fnc_playtime_values",
    "life_var_hc_connected",
    "life_var_headlessClient"
];

/* Setup the federal reserve building(s) */
private _vaultHouse = [[["Altis", "Land_Research_house_V1_F"], ["Tanoa", "Land_Medevac_house_V1_F"]]] call TON_fnc_terrainSort;
private _altisArray = [16019.5,16952.9,0];
private _tanoaArray = [11074.2,11501.5,0.00137329];
private _pos = [[["Altis", _altisArray], ["Tanoa", _tanoaArray]]] call TON_fnc_terrainSort;

private _dome = nearestObject [_pos,"Land_Dome_Big_F"];
private _rsb = nearestObject [_pos,_vaultHouse];

for "_i" from 1 to 3 do {_dome setVariable [format ["bis_disabled_Door_%1",_i],1,true]; _dome animateSource [format ["Door_%1_source", _i], 0];};
_dome setVariable ["locked",true,true];
_rsb setVariable ["locked",true,true];
_rsb setVariable ["bis_disabled_Door_1",1,true];
_dome allowDamage false;
_rsb allowDamage false;

/* Tell clients that the server is ready and is accepting queries */
life_var_serverLoaded = true;
publicVariable "life_var_serverLoaded";

/* Initialize hunting zone(s) */
aiSpawn = ["hunting_zone",30] spawn TON_fnc_huntingZone;

addMissionEventHandler ["EntityRespawned", {_this call TON_fnc_entityRespawned}];

diag_log "----------------------------------------------------------------------------------------------------";
diag_log format ["               End of Altis Life Server Init :: Total Execution Time %1 seconds ",(diag_tickTime) - _timeStamp];
diag_log "----------------------------------------------------------------------------------------------------";
