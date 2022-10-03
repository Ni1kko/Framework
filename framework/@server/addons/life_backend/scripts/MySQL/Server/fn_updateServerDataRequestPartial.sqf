#include "\life_backend\script_macros.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
    ## fn_updateServerDataRequestPartial.sqf (Server)
*/
RUN_SERVER_ONLY;
RUN_NO_REXEC;

params [
	["_mode", -1, [0]]
];

if(not(isFinal "life_var_serverID")) exitWith {
	[] spawn MPServer_fnc_fetchServerDataRequest;
	false
};

private _whereClause = [
	["serverID",["DB","INT",call life_var_serverID] call MPServer_fnc_database_parse]
];

switch _mode do
{
	case 0: 
	{ 
		["UPDATE", "servers", [
			[
				["name",["DB","STRING", serverName] call MPServer_fnc_database_parse],
        		["world",["DB","STRING", worldName] call MPServer_fnc_database_parse]
			],
			_whereClause
		]]call MPServer_fnc_database_request;
	};

	case 1: 
	{ 
		if(isNil "life_var_serverRuntime") exitWith {[] spawn MPServer_fnc_fetchServerDataRequest};
		if(not(life_var_serverRuntime isEqualType 0)) exitWith {[] spawn MPServer_fnc_fetchServerDataRequest};

		["UPDATE", "servers", [
			[
				["runtime",["DB","INT", life_var_serverRuntime] call MPServer_fnc_database_parse]
			],
			_whereClause
		]]call MPServer_fnc_database_request;
	};

	case 2: 
	{ 
		if(isNil "life_var_serverCurrentPlayers") then {life_var_serverCurrentPlayers = []};
		if(isNil "life_var_serverMaxPlayers") then {life_var_serverMaxPlayers = 0};
		if(typeName life_var_serverCurrentPlayers isNotEqualTo "ARRAY") then {life_var_serverCurrentPlayers = []};
		if(typeName life_var_serverMaxPlayers isNotEqualTo "SCALAR") then {life_var_serverMaxPlayers = 0};

		//--- Update max players
		private _totalPlayerCount = life_var_serverMaxPlayers + (count allPlayers);
		if(_totalPlayerCount > life_var_serverMaxPlayers)then{
			life_var_serverMaxPlayers = _totalPlayerCount; 
		};

		["UPDATE", "servers", [
            [
				["maxplayercount", ["DB","INT", life_var_serverMaxPlayers] call MPServer_fnc_database_parse],
                ["currentplayers", ["DB","ARRAY",life_var_serverCurrentPlayers] call MPServer_fnc_database_parse]
            ],
            _whereClause
        ]]call MPServer_fnc_database_request;
	}; 
};

true