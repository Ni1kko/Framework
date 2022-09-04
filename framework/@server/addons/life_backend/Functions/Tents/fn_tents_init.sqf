/*
	## Nikko Renolds
	## https://github.com/Ni1kko/Framework
*/

if(!canSuspend)exitWith{_this spawn life_fnc_tents_init};

waitUntil {isFinal "extdb_var_database_key"}; 

diag_log "[Life Tents] Initializing...";

life_var_tent_config = compileFinal str [
	getNumber(configFile >> "CfgTents" >> "oneTimeUse") isEqualTo 1,
	getNumber(configFile >> "CfgTents" >> "garages") isEqualTo 1
];

publicVariable "life_var_tent_config";

//-- Get tents from database
private _queryTents = ["READ", "tents", 
	[
		["type", "position", "vitems", "BEGuid", "tentID"],
		[["alive", ["DB","BOOL", true] call life_fnc_database_parse]]
	]
] call life_fnc_database_request;

//-- ReSpawn tents
{ 
	private _type = ["DB","STRING", _x param [0, ""]] call life_fnc_database_parse;
	private _position = ["DB","ARRAY", _x param [1, []]] call life_fnc_database_parse;
	private _vitems = ["DB","ARRAY", _x param [2, []]] call life_fnc_database_parse;
	private _BEGuid = ["DB","STRING", _x param [3, ""]] call life_fnc_database_parse;
	private _tentID = ["DB","STRING", _x param [4, ""]] call life_fnc_database_parse;
	private _tent = [_type,_position,_BEGuid,_tentID,_vitems] call life_fnc_tents_build;
	
} foreach _queryTents;

publicVariable "life_var_allTents";

diag_log "[Life Tents] Initialized!";