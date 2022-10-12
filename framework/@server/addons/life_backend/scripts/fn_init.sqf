#include "\life_backend\serverDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

params ["_serverName","_missionName","_worldName","_worldSize"];

if (isFinal "life_var_initTime")exitWith{false};

life_var_initTime = compileFinal str(diag_tickTime);

["Loading server init"] call MPServer_fnc_log;

waitUntil {isFinal "extdb_var_database_key"};
life_var_currentDay = [] call MPServer_fnc_util_getCurrentDay;

//--- Server info
private _serverDatabaseInit = [] spawn MPServer_fnc_fetchServerDataRequest;
waitUntil{scriptDone _serverDatabaseInit};

//--- Mission Event handlers
life_var_clientConnected =      addMissionEventHandler ['PlayerConnected',      MPServer_fnc_event_playerConnected,    []];
life_var_clientDisconnected =   addMissionEventHandler ["PlayerDisconnected",   MPServer_fnc_event_playerDisconnected, []];
life_var_handleDisconnectEVH =  addMissionEventHandler ["HandleDisconnect",     {_this call MPServer_fnc_clientDisconnect; false;}];
life_var_entityRespawnedEVH =   addMissionEventHandler ["EntityRespawned",      MPServer_fnc_entityRespawned];

[] call MPServer_fnc_initHouses;
[] call MPServer_fnc_setupBanks;
[] call MPServer_fnc_setupHospitals;
[] call MPServer_fnc_stripNpcs;
[] call MPServer_fnc_setupRadioChannels;
[8,true,12] call MPServerFSM_fnc_timeModule;
cleanupFSM = [] call MPServerFSM_fnc_cleanup;

life_var_animalTypesRestricted append (getArray(missionConfigFile >> "cfgMaster" >> "animaltypes_fish") select {not(_x in life_var_animalTypesRestricted)});
life_var_animalTypesRestricted append (getArray(missionConfigFile >> "cfgMaster" >> "animaltypes_hunting") select {not(_x in life_var_animalTypesRestricted)});
life_var_animalTypesRestricted append ((getArray(configFile >> "CfgEnviroment" >> "wildLife" >> "animaltypes")#0) select {not(_x in life_var_animalTypesRestricted)});

private _severSchedulerStartUpQueue = [ 
	//--- Every 5 seconds
 	[5 , 	  "MPServer_fnc_rcon_queuedMessages"],
	//--- Every 10 seconds
	[10, 	  "MPServer_fnc_initWildlife"],
	[10, 	  "MPServer_fnc_cleanUpWildlife"],
	//--- Every 5 minutes
	[3 * 60,  "MPServer_fnc_cleanup", ["items"]],
	//--- Every 10 minutes
	[10 * 60, "MPServer_fnc_updateBanks", ["vault"]],
	//--- Every 15 minutes
	[15 * 60,  "MPServer_fnc_cleanup", ["weapons"]],
	//--- Every 20 minutes
	[20 * 60, "MPServer_fnc_updateBanks", ["bank"]],
	//--- Every 30 minutes
	[30 * 60, "MPServer_fnc_updateDealers"],
	//--- Every 45 minutes
	[45 * 60, "MPServer_fnc_updateBanks", ["atm"]],
	//--- Every 60 minutes
	[60 * 60, "MPServer_fnc_cleanup", ["vehicles"]]
];

//--- Remote exec
if(getNumber(configFile >> "CfgRemoteExec" >> "enabled") isEqualTo 1)then
{
	private _checkEveryXmins = getNumber(configFile >>"CfgRemoteExec" >> "checkEveryXmins"); 
    //--- Add Remote exec to scheduler
    _severSchedulerStartUpQueue pushBack [_checkEveryXmins * 60, "MPServer_fnc_remoteExecRun"];
    //--- Add Remote exec cleanup to scheduler
    _severSchedulerStartUpQueue pushBack [25 * 60, "MPServer_fnc_database_request", ["CALL", "deleteCompletedRemoteExecRequests"]];
};

//--- Add queue too scheduler
life_var_severSchedulerStartUpQueue = compileFinal str _severSchedulerStartUpQueue;
{life_var_severScheduler pushBack _x}forEach _severSchedulerStartUpQueue;

//-- Wait till market has loaded
waitUntil {!isNil "life_var_marketConfig"};

//--- Tell clients that the server is ready and is accepting queries
life_var_serverLoaded = true;

//--- 
{publicVariable _x}forEach[
    "MPServer_fnc_terrainSort",
    "MPServer_fnc_index",
    "MPServer_fnc_isNumber",
    "MPServer_fnc_clientGangKick",
    "MPServer_fnc_clientGetKey",
    "MPServer_fnc_clientGangLeader",
    "MPServer_fnc_clientGangLeft",
    "life_var_playtimeValuesRequest",
    "life_var_playtimeValues",
    "life_var_serverLoaded",
    "MPServer_fnc_util_getSideString",
	"MPServer_fnc_util_getTypeString",
    "MPServer_fnc_util_getPlayerObject",
	"life_var_currentDay",
	"life_var_animalTypes",
	"life_var_animalTypesRestricted"
];

[format["Server init completed! Took %1 seconds",diag_tickTime - (call life_var_initTime)]] call MPServer_fnc_log;

true