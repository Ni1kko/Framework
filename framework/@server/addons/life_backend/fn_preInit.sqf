/*
	## Nikko Renolds
	## https://github.com/Ni1kko/Framework
*/

if(!canSuspend)exitwith{_this spawn life_fnc_preInit; true};
 
life_var_serverLoaded = false;
life_var_severVehicles = [];
life_var_severScheduler = [];
life_var_playtimeValues = [];
life_var_playtimeValuesRequest = [];
life_var_radioChannels = [];
life_var_corpses = []; 
life_var_banksReady = {false};
life_var_banks = [];
life_var_atms = [];
life_var_spawndAnimals = [];

publicVariable "life_var_serverLoaded";
waitUntil {isFinal "extdb_var_database_key"};

//--- Server info
private _serverDatabaseInit = [] spawn DB_fnc_loadServer;
waitUntil{scriptDone _serverDatabaseInit};

//--- Mission Event handlers
life_var_clientConnected =      addMissionEventHandler ['PlayerConnected',      life_fnc_event_playerConnected,    []];
life_var_clientDisconnected =   addMissionEventHandler ["PlayerDisconnected",   life_fnc_event_playerDisconnected, []];
life_var_handleDisconnectEVH =  addMissionEventHandler ["HandleDisconnect",     {_this call TON_fnc_clientDisconnect; false;}];
life_var_entityRespawnedEVH =   addMissionEventHandler ["EntityRespawned",      TON_fnc_entityRespawned];

[] call TON_fnc_initHouses;
[] call TON_fnc_setupBanks;
[] call TON_fnc_setupHospitals;
[] call TON_fnc_stripNpcs;
[] call TON_fnc_setupRadioChannels;
[8,true,12] call LifeFSM_fnc_timeModule;
cleanupFSM = [] call LifeFSM_fnc_cleanup;

{life_var_severScheduler pushBack _x}forEach [ 
	//--- Every 10 seconds
	[10, 	  "TON_fnc_updateHuntingZone"],
	//--- Every 3 minutes
	[3 * 60,  "TON_fnc_cleanup", ["items"]],
	//--- Every 5 minutes
	[5 * 60,  "TON_fnc_cleanup", ["weapons"]],
	//--- Every 10 minutes
	[10 * 60, "TON_fnc_updateBanks", ["vault"]],
	//--- Every 20 minutes
	[20 * 60, "TON_fnc_updateBanks", ["bank"]],
	//--- Every 30 minutes
	[30 * 60, "TON_fnc_updateDealers"],
	//--- Every 45 minutes
	[45 * 60, "TON_fnc_updateBanks", ["atm"]],
	//--- Every 60 minutes
	[60 * 60, "TON_fnc_cleanup", ["vehicles"]]
];

//--- Remote exec
if(getNumber(configFile "CfgRemoteExec" >> "enabled") == 1)then
{
    //--- Add Remote exec to scheduler
    life_var_severScheduler pushBack [getNumber(configFile "CfgRemoteExec" >> "checkEveryXmins") * 60, "Life_fnc_remoteExecRun"];
    //--- Add Remote exec cleanup to scheduler
    life_var_severScheduler pushBack [25 * 60, "life_fnc_database_request", ["CALL", "deleteCompletedRemoteExecRequests"]];
};

//--- Variable Event handlers
"life_fnc_RequestClientId" addPublicVariableEventHandler {(_this select 1) setVariable ["life_clientID", owner (_this select 1), true];};
"money_log" addPublicVariableEventHandler {diag_log (_this select 1)};
"advanced_log" addPublicVariableEventHandler {diag_log (_this select 1)};


//--- Tell clients that the server is ready and is accepting queries
life_var_serverLoaded = true;

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
    "life_var_playtimeValuesRequest",
    "life_var_playtimeValues",
    "life_var_serverLoaded",
    "life_fnc_util_getSideString",
    "life_fnc_util_getPlayerObject"
];

true