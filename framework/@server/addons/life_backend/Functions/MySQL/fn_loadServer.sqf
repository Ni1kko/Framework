/*
	## Nikko Renolds
	## https://github.com/Ni1kko/Framework
*/

if(!isServer)exitwith{false};
if(isRemoteExecuted)exitwith{false};

private _hardwareID = 'BEGuid' callExtension "hwid";
private _serverQuery = format ["SELECT serverID, name, world, maxplayercount, restartcount, runtime FROM servers WHERE hardwareID='%1' AND world='%2'",_hardwareID,worldName];
private _serverQueryResult = [_serverQuery,2] call DB_fnc_asyncCall;

//--- no server id found, insert
private _serverQueryMaxTries = 5;
private _serverQueryTries = 0;
if (count _serverQueryResult isEqualTo 0) then {
    [format ["INSERT INTO servers (hardwareID, name, world) VALUES('%1', '%2', '%3')",_hardwareID, serverName,worldName],1] call DB_fnc_asyncCall;
    
    while {count _serverQueryResult isEqualTo 0 && (_serverQueryMaxTries <= _serverQueryTries)} do {
        _serverQueryResult = [_serverQuery,2] call DB_fnc_asyncCall;
        _serverQueryTries = _serverQueryTries + 1;
        uiSleep 3;
    };
};
if(_serverQueryTries >= _serverQueryMaxTries)exitwith{
    diag_log "database `servers` error. life_backend/fn_preInit.sqf";
    '#shutdown' call life_fnc_rcon_sendCommand;
};

_serverQueryResult params [
    ["_serverID",-1], 
    ["_name",serverName], 
    ["_world",worldName], 
    ["_maxplayercount",0], 
    ["_restartcount",0], 
    ["_runtime",0]
];

if(_serverID isEqualTo -1)exitwith{
    diag_log "database `servers` column `serverID` error. life_backend/fn_preInit.sqf";
    '#shutdown' call life_fnc_rcon_sendCommand;
};

life_var_serverID = compileFinal str _serverID;
life_var_serverMaxPlayers = _maxplayercount;
life_var_serverRuntime = _runtime;
life_var_serverRestarts = (_restartcount + 1);

private _updateServerQuery = format["UPDATE servers SET restartcount='%1' WHERE serverID='%2'",life_var_serverRestarts,_serverID];

if(serverName isNotEqualTo _name OR worldName isNotEqualTo _world)then{
   _updateServerQuery = format["UPDATE servers SET name='%1', world='%2', restartcount='%3'  WHERE serverID='%4'",serverName,worldName,life_var_serverRestarts,_serverID];
};

[_updateServerQuery,1] call DB_fnc_asyncCall;
 
terminate (missionNamespace getVariable ["life_var_runtime_thread",scriptNull]);
life_var_runtime_thread = []spawn{ 
    while {true} do {
        private _serveruptime = round(call compile("extDB3" callExtension "9:UPTIME:MINUTES"));
        if(_serveruptime > 0)then{
            private _scale = ([10,1] select (life_var_rcon_RestartMode isEqualTo 1));
           if(_serveruptime mod _scale isEqualTo 0)then{
                life_var_serverRuntime = (life_var_serverRuntime + _scale);
                [format["UPDATE servers SET runtime='%1' WHERE serverID='%2'",life_var_serverRuntime,(call life_var_serverID)],1] call DB_fnc_asyncCall;
            };
        };
        uiSleep 60;
    };
};