#include "\life_backend\script_macros.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
    ## fn_insertServerDataRequest.sqf (Server)
*/
RUN_SERVER_ONLY;
RUN_NO_REXEC;

private _hardwareID = GET_HWID;
private _serverColmuns = param [0, ["serverID"], [[]]];
private _serverQuery = ["READ", "servers",[
    _serverColmuns,
    [
        ["hardwareID",str _hardwareID],
        ["name",["DB","STRING", serverName] call MPServer_fnc_database_parse],
        ["world",["DB","STRING",worldName] call MPServer_fnc_database_parse]
    ]
],true];

private _serverQueryResult = _serverQuery call MPServer_fnc_database_request;
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
                    ["hardwareID", 		str _hardwareID], 
                    ["name", 			["DB","STRING", serverName] call MPServer_fnc_database_parse],
                    ["world", 			["DB","STRING", worldName] call MPServer_fnc_database_parse], 
                    ["currentplayers", 	["DB","ARRAY", []] call MPServer_fnc_database_parse]
                ]
            ]call MPServer_fnc_database_request;

            //check
            if(_res isEqualTo ["DB:Create:Task-completed",true])then{
                _inserted = true;
            };
        }else{
            //query database for result
            _serverQueryResult = _serverQuery call MPServer_fnc_database_request;
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
    []
};

_serverQueryResult