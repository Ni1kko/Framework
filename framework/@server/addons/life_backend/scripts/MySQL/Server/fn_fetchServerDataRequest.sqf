#include "\life_backend\script_macros.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
    ## fn_fetchServerDataRequest.sqf (Server)
*/

RUN_SERVER_ONLY;
RUN_NO_REXEC;
FORCE_SUSPEND("MPServer_fnc_fetchServerDataRequest");

private _serverQueryColumns = ["serverID", "name", "world", "currentplayers", "maxplayercount", "restartcount", "runtime"];

//-- Gets data if none it will create a new entry then return the new data
private _serverQueryResult = [_serverQueryColumns] call MPServer_fnc_insertServerDataRequest;

//--- She fucked it
if(count _serverQueryResult isEqualTo 0)exitwith{
    ["database `servers` error no results. MPServer_fnc_fetchServerDataRequest"] call MPServer_fnc_log;
    '#shutdown' call MPServer_fnc_rcon_sendCommand;
    false
};

//--- Database return
_serverQueryResult params [
    ["_serverID",-1], 
    ["_name",serverName], 
    ["_world",worldName],
    ["_currentplayers","[]"], 
    ["_maxplayercount",0], 
    ["_restartcount",0], 
    ["_runtime",0]
];

//--- Bad return
if(_serverID isEqualTo -1)exitwith{
    ["database `servers` column `serverID` error. MPServer_fnc_fetchServerDataRequest"] call MPServer_fnc_log;
    '#shutdown' call MPServer_fnc_rcon_sendCommand;
};

//--- Parse return
life_var_serverID = compileFinal str (["GAME","INT",_serverID] call MPServer_fnc_database_parse);
life_var_serverMaxPlayers = (["GAME","INT",_maxplayercount] call MPServer_fnc_database_parse);
life_var_serverRuntime = (["GAME","INT",_runtime] call MPServer_fnc_database_parse);
life_var_serverRestarts = (["GAME","INT",_restartcount] call MPServer_fnc_database_parse);
life_var_serverCurrentPlayers = [];

//--- World or Servername changed add new values to datbase query
if(serverName isNotEqualTo _name OR worldName isNotEqualTo _world)then{
   [0] call MPServer_fnc_updateServerDataRequestPartial;
};

//--- Thread to update servers runtime
terminate (missionNamespace getVariable ["life_var_runtime_thread",scriptNull]);
life_var_runtime_thread = []spawn{ 
    while {true} do {
        private _serveruptime = round(call compile("extDB3" callExtension "9:UPTIME:MINUTES"));
        if(_serveruptime > 0)then{
            private _scale = ([10,1] select (life_var_rcon_RestartMode isEqualTo 1));
           if(_serveruptime mod _scale isEqualTo 0)then{
                life_var_serverRuntime = (life_var_serverRuntime + _scale);
                [1] call MPServer_fnc_updateServerDataRequestPartial;
            };
        };
        uiSleep 60;
    };
};