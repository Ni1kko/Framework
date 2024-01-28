#include "hc_macros.hpp"
/*
    File: fn_initHC.sqf
    Author: Nanou

    Description:
    Initialize the headless client.
*/
if (EXTDB_SETTING(getNumber,"HeadlessSupport") isEqualTo 0) exitWith {};
life_save_civilian_position = if (LIFE_SETTINGS(getNumber,"save_civilian_position") isEqualTo 0) then {false} else {true};

private _databaseLoaded = false;

//--- Random strings
private _keyLength = random [6,9,12];
private _protocolName = uiNamespace getVariable ["life_protocolName",""];
private _databaseLock = uiNamespace getVariable ["life_databaseLock",""];

//--
if (_protocolName isEqualTo "") then {
    try {
        //--- Loaded
        if(isNil compile "getDatabaseVersion") throw "Error plugin is not loaded!";

        //--- Version
        if(parseNumber(getDatabaseVersion) < 1.001) throw "Error plugin is outdated!";

        //--- Gen Random strings
        _protocolName = getDatabaseRandomString _keyLength;
        _databaseLock = getDatabaseRandomString _keyLength;

        //-- Connects to profile inside (extdb4-conf.ini) defined in cfgServer >> "DatabaseName"
        private _profileName = EXTDB_SETTING(getText,"DatabaseName");

        //--- Connect to Profile
        if(not(setDatabaseProfile _profileName)) throw "Error with Database Profile";

        //--- Add Protocol to Profile
        if(not(_profileName setDatabaseProfileProtocol ["SQL",_protocolName,"TEXT2"])) throw "Error with Database Protocol";

        //--- Lock database
        if(not(_databaseLock setDatabaseLock true) or {not(getDatabaseLock)}) throw "Error Locking Database Profile";
    } catch {
        //-- Clear local variables
        _databaseLoaded = false;
        _protocolName = "";
        _databaseLock = "";
        
        //-- Log exception
        diag_log format ["ExtDB4: %1", _exception];

        //-- Broadcast that extdb4 has an error to all clients
        life_server_extDB_notLoaded = true;
        publicVariable "life_server_extDB_notLoaded";
    };

    //-- Store keys in the uiNamespace so if mission restarts without a server reboot we still have random keys to accses already setup connection
    uiNamespace setVariable ["life_protocolName", compileFinal str(_protocolName)];
    uiNamespace setVariable ["life_databaseLock", compileFinal str(_databaseLock)];
};

if(not(_databaseLoaded)) exitWith {false};
if(not(isFinal "life_sql_id"))then{life_sql_id = compileFinal str(_protocolName)};
if(not(isFinal "life_db_lock"))then{life_db_lock = compileFinal str(_databaseLock)};
diag_log "extDB4: Connected to Database";
life_server_extDB_notLoaded = false;
publicVariable "life_server_extDB_notLoaded";

/* Run stored procedures for SQL side cleanup */
_protocolName databaseFireAndForget "CALL resetLifeVehicles";
_protocolName databaseFireAndForget "CALL deleteDeadVehicles";
_protocolName databaseFireAndForget "CALL deleteOldHouses";
_protocolName databaseFireAndForget "CALL deleteOldGangs";

private _timeStamp = diag_tickTime;
diag_log "----------------------------------------------------------------------------------------------------";
diag_log "------------------------------------ Starting Altis Life HC Init -----------------------------------";
diag_log format["-------------------------------------------- Version %1 -----------------------------------------",(LIFE_SETTINGS(getText,"framework_version"))];
diag_log "----------------------------------------------------------------------------------------------------";

[] execFSM "\life_hc\FSM\cleanup.fsm";

[] spawn HC_fnc_cleanup;

/* Initialize hunting zone(s) */
["hunting_zone",30] spawn HC_fnc_huntingZone;

// A list of allowed funcs to be passed on the hc (by external sources)
// Have to be written in only lower capitals
HC_MPAllowedFuncs = [
    "hc_fnc_insertrequest",
    "hc_fnc_insertvehicle",
    "hc_fnc_queryrequest",
    "hc_fnc_updatepartial",
    "hc_fnc_updaterequest",
    "hc_fnc_cleanup",
    "hc_fnc_huntingzone",
    "hc_fnc_setplaytime",
    "hc_fnc_getplaytime",
    "hc_fnc_insertgang",
    "hc_fnc_queryplayergang",
    "hc_fnc_removegang",
    "hc_fnc_updategang",
    "hc_fnc_addcontainer",
    "hc_fnc_addhouse",
    "hc_fnc_deletedbcontainer",
    "hc_fnc_fetchplayerhouses",
    "hc_fnc_housecleanup",
    "hc_fnc_sellhouse",
    "hc_fnc_sellhousecontainer",
    "hc_fnc_updatehousecontainers",
    "hc_fnc_updatehousetrunk",
    "hc_fnc_keymanagement",
    "hc_fnc_vehiclecreate",
    "hc_fnc_spawnvehicle",
    "hc_fnc_vehiclestore",
    "hc_fnc_chopshopsell",
    "hc_fnc_getvehicles",
    "hc_fnc_vehicledelete",
    "hc_fnc_vehicleupdate",
    "hc_fnc_jailsys",
    "hc_fnc_spikestrip",
    "hc_fnc_wantedadd",
    "hc_fnc_wantedbounty",
    "hc_fnc_wantedcrimes",
    "hc_fnc_wantedfetch",
    "hc_fnc_wantedperson",
    "hc_fnc_wantedprofupdate",
    "hc_fnc_wantedremove"
];

CONSTVAR(HC_MPAllowedFuncs);

[] spawn {
    for "_i" from 0 to 1 step 0 do {
        uiSleep 60;
        publicVariableServer "serv_sv_use";
    };
};

life_HC_isActive = true;
publicVariable "life_HC_isActive";
diag_log "----------------------------------------------------------------------------------------------------";
diag_log format ["                 End of Altis Life HC Init :: Total Execution Time %1 seconds ",(diag_tickTime) - _timeStamp];
diag_log "----------------------------------------------------------------------------------------------------";
