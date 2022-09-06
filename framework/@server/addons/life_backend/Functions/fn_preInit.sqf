/*
	## Nikko Renolds
	## https://github.com/Ni1kko/Framework
*/

if(!canSuspend)exitwith{_this spawn MPServer_fnc_preInit; true};
 
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
life_var_severSchedulerStartUpQueue = {[]};

publicVariable "life_var_serverLoaded";
waitUntil {isFinal "extdb_var_database_key"};
life_var_currentDay = [] call MPServer_fnc_util_getCurrentDay;

//--- Server info
private _serverDatabaseInit = [] spawn MPServer_fnc_loadServer;
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

private _severSchedulerStartUpQueue = [ 
	//--- Every 10 seconds
	[10, 	  "MPServer_fnc_updateHuntingZone"],
	//--- Every 3 minutes
	[3 * 60,  "MPServer_fnc_cleanup", ["items"]],
	//--- Every 5 minutes
	[5 * 60,  "MPServer_fnc_cleanup", ["weapons"]],
	//--- Every 10 minutes
	[10 * 60, "MPServer_fnc_updateBanks", ["vault"]],
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
 
//--- Variable Event handlers
"MPServer_fnc_requestClientId" addPublicVariableEventHandler {(_this select 1) setVariable ["life_clientID", owner (_this select 1), true];};
"money_log" addPublicVariableEventHandler {diag_log (_this select 1)};
"advanced_log" addPublicVariableEventHandler {diag_log (_this select 1)};


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
    "MPServer_fnc_util_getPlayerObject",
	"life_var_currentDay"
];

true