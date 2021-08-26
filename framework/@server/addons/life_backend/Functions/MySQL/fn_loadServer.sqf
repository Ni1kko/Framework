/*
	## Nikko Renolds
	## https://github.com/Ni1kko/Framework
*/

if(!isServer)exitwith{false};
if(isRemoteExecuted)exitwith{false};

private _hardwareID = 'BEGuid' callExtension "hwid";
private _serverQuery = ["READ", "servers",[
    [//What
        "serverID", "name", "world", "currentplayers", "maxplayercount", "restartcount", "runtime"
    ],
    [//Where
        ["hardwareID",str _hardwareID],
        ["world",["DB","STRING",worldName] call life_fnc_database_parse]
    ]
],true];


private _serverQueryResult = _serverQuery call life_fnc_database_request;
private _serverQueryMaxTries = 5;
private _serverQueryTries = 0;

//--- Server id not found, insert
if (count _serverQueryResult isEqualTo 0) then {
    private _inserted = false;
    private _checking = true;
    while {_checking} do {

        _serverQueryTries = _serverQueryTries + 1;

        if(!_inserted)then
        {
            //insert
            private _res = ["CREATE", "servers", 
                [//What 
                    ["hardwareID", 		["DB","STRING", _hardwareID] call life_fnc_database_parse], 
                    ["name", 			["DB","STRING", serverName] call life_fnc_database_parse],
                    ["world", 			["DB","STRING", worldName] call life_fnc_database_parse], 
                    ["currentplayers", 	["DB","ARRAY", []] call life_fnc_database_parse]
                ]
            ]call life_fnc_database_request;

            //check
            if(_res isEqualTo ["DB:Create:Task-completed",true])then{
                _inserted = true;
            };
        }else{
            //query database for result
            _serverQueryResult = _serverQuery call life_fnc_database_request;
        };

        //exit
        if(count _serverQueryResult isNotEqualTo 0 OR (_serverQueryTries >= _serverQueryMaxTries))exitWith{
            _checking = false;
        };
       
        uiSleep 3;
    };
};

//--- She fucked it
if(_serverQueryTries >= _serverQueryMaxTries)exitwith{
    diag_log "database `servers` error. @server\addons\life_backend\Functions\MySQL\fn_loadServer.sqf";
    '#shutdown' call life_fnc_rcon_sendCommand;
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
    diag_log "database `servers` column `serverID` @server\addons\life_backend\Functions\MySQL\fn_loadServer.sqf";
    '#shutdown' call life_fnc_rcon_sendCommand;
};

//--- Parse return
life_var_serverID = compileFinal str (["GAME","INT",_serverID] call life_fnc_database_parse);
life_var_serverMaxPlayers = (["GAME","INT",_maxplayercount] call life_fnc_database_parse);
life_var_serverRuntime = (["GAME","INT",_runtime] call life_fnc_database_parse);
life_var_serverRestarts = ((["GAME","INT",_restartcount] call life_fnc_database_parse) + 1);
life_var_serverCurrentPlayers = (["GAME","ARRAY",_currentplayers] call life_fnc_database_parse);

//--- Remove any players from last restart (mainly happens if server wasn't shut down correctly)
if(count life_var_serverCurrentPlayers > 0)then{
    private _res = ["CALL", "resetActivePlayerList"]call life_fnc_database_request;
    if(_res isEqualTo ["DB:Call:Task-completed",true])then{
        life_var_serverCurrentPlayers = [];
    };
};

//--- Add new restartcount to datbase query
private _updateServerQuery = [
    ["restartcount",["DB","INT", life_var_serverRestarts] call life_fnc_database_parse]
];

//--- World or Servername changed add new values to datbase query
if(serverName isNotEqualTo _name OR worldName isNotEqualTo _world)then{
   _updateServerQuery append [
        ["name",["DB","STRING", serverName] call life_fnc_database_parse],
        ["world",["DB","STRING", worldName] call life_fnc_database_parse]
    ];
};

//--- Send datbase query
if(count _updateServerQuery > 0)then{
    ["UPDATE", "servers", [_updateServerQuery,
        [//Where
            ["serverID",["DB","INT",_serverID] call life_fnc_database_parse]
        ]
    ]]call life_fnc_database_request;
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
                ["UPDATE", "servers", [
                    [
                        ["runtime",["DB","INT", life_var_serverRuntime] call life_fnc_database_parse]
                    ],
                    [//Where
                        ["serverID",["DB","INT",(call life_var_serverID)] call life_fnc_database_parse]
                    ]
                ]]call life_fnc_database_request;
            };
        };
        uiSleep 60;
    };
};