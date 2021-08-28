/*
	## Nikko Renolds
	## https://github.com/Ni1kko/Framework
*/
 
params [
	["_mode",""],
	["_table",""], 
	["_params",[]],
	["_single",false]
];

private _qstring = "";
private _res = ["DB:Task-failure", false];
 
//--- Build Query
switch (_mode) do {
	case "CREATE": 
	{ 
		private _columns = [];
		private _values = [];
		{
			_columns pushBack (_x#0);
			_values pushBack (_x#1);
		} forEach _params; 
		_qstring = ("1:" + str(call extdb_var_database_key) + ":INSERT INTO " + _table + " (" + (_columns joinString ",") + ")VALUES(" + (_values joinString ",") + ")");
		_res = ["DB:Create:Task-completed",true];
		//"1:464:INSERT INTO players (name,aliases,playerid,cash,safe)VALUES(Nikko2,""[``test``]"",76561198276956558,0,10000)"
	};
	case "READ": 
	{
		private _columns = (_params#0) joinString ",";
		private _clauses = [];{_clauses pushBack (_x joinString "=")} forEach (_params#1);
		_qstring = ("2:" + str(call extdb_var_database_key) + ":SELECT " + _columns + " FROM " + _table);
		if(count _clauses > 0)then{_qstring = _qstring + (" WHERE " + (_clauses joinString " AND "));};
		//"2:464:SELECT name,cash,safe FROM players WHERE playerid=76561199109931625"
	};
	case "UPDATE": 
	{ 
		private _columns = [];{_columns pushBack (_x joinString "=")} forEach (_params#0);
		private _clauses = [];{_clauses pushBack (_x joinString "=")} forEach (_params#1);
		_qstring = ("1:" + str(call extdb_var_database_key) + ":UPDATE " + _table + " SET " + (_columns joinString ","));
		if(count _clauses > 0)then{_qstring = _qstring + (" WHERE " + (_clauses joinString " AND "));};
		_res = ["DB:Update:Task-completed",true];
		//"1:464:UPDATE players SET cash=500,safe=99999 WHERE playerid=76561199109931625"
	};
	case "DELETE": 
	{  
		private _clauses = [];{_clauses pushBack (_x joinString "=")} forEach (_params#0);
		_qstring = ("1:" + str(call extdb_var_database_key) + ":DELETE FROM " + _table);
		if(count _clauses > 0)then{_qstring = _qstring + (" WHERE " + (_clauses joinString " AND "));};
		_res = ["DB:Delete:Task-completed",true];
		//"1:464:DELETE FROM vehicles WHERE id=1"
	};
	case "CALL": 
	{  
		_qstring = ("1:" + str(call extdb_var_database_key) + ":CALL " + _table);
		_res = ["DB:Call:Task-completed",true];
		//"1:464:CALL deleteOldGangs"
	};
	default
	{
		_qstring = ("2:" + str(call extdb_var_database_key) + ":" + _mode);
	};
};

//--- Send Request to extension
private _messageID = "extDB3" callExtension _qstring;

//--- No Database Return... Task Completed
if(_mode in ["UPDATE","CREATE","DELETE","CALL"])exitWith{_res};

//--- Query Message Key
private _key = (call compile format["%1",_messageID])#1;

//--- Send Request for message
private _extRes = "extDB3" callExtension format["4:%1", _key];

//--- Check if message is complete
if (_extRes isEqualTo "[3]") then {
	for "_i" from 0 to 1 step 0 do {
		if !(_extRes isEqualTo "[3]") exitWith {};
		_extRes = "extDB3" callExtension format["4:%1", _key];
	};
};

//--- Check if multi-part message
if (_extRes isEqualTo "[5]") then {
	private _loop = true;
	for "_i" from 0 to 1 step 0 do {
		_extRes = "";
		for "_i" from 0 to 1 step 0 do {
			private _pipe = "extDB3" callExtension format["5:%1", _key];
			if (_pipe isEqualTo "") exitWith {_loop = false};
			_extRes = _extRes + _pipe;
		};
		if (!_loop) exitWith {};
	};
};

//--- Pull Result out string
_extRes = call compile _extRes;

//--- Bad Result
if ((_extRes#0) isEqualTo 0) exitWith {
	_res = ["DB:Read:Task-failure",false];
	diag_log format ["%1: Protocol Error: %2", _res#0, _extRes];
	_res
};

//--- All Results
_res = (_extRes#1);

//--- Single Result
if (_single && count _res > 0) then {
	_res = (_res#0);
};

_res

/* 
	["CREATE", "players", 
		[//What
			["serverID", 		["DB","INT", (call life_var_serverID)] call life_fnc_database_parse],
			["BEGuid", 			["DB","STRING", "092dd37cc6d0e2781ea42ee334debd28"] call life_fnc_database_parse],
			["pid", 			["DB","STRING", "76561198276956558"] call life_fnc_database_parse],
			["name", 			["DB","STRING", "nikko test"] call life_fnc_database_parse],
			["cash", 			["DB","A2NET", 0] call life_fnc_database_parse],
			["aliases", 		["DB","ARRAY", ["nikko test"]] call life_fnc_database_parse],
			["cop_licenses", 	["DB","ARRAY", []] call life_fnc_database_parse],
			["med_licenses", 	["DB","ARRAY", []] call life_fnc_database_parse],
			["civ_licenses", 	["DB","ARRAY", []] call life_fnc_database_parse],
			["civ_gear", 		["DB","ARRAY", []] call life_fnc_database_parse],
			["cop_gear", 		["DB","ARRAY", []] call life_fnc_database_parse],
			["med_gear", 		["DB","ARRAY", []] call life_fnc_database_parse]
		]
	]call life_fnc_database_request;

	["READ", "players", [
		[//What
			"serverID", "BEGuid", "pid", "name", "cash"
		],
		[//Where
			["BEGuid",str("092dd37cc6d0e2781ea42ee334debd28")]
		]
	],true]call life_fnc_database_request;

	["UPDATE", "players", [
		[//What
			["cash",["DB","A2NET", 500] call life_fnc_database_parse]
		],
		[//Where
			["BEGuid",str("092dd37cc6d0e2781ea42ee334debd28")]
		]
	]]call life_fnc_database_request;
	
	["DELETE", "players", [
		[//Where
			["BEGuid",str("092dd37cc6d0e2781ea42ee334debd28")]
		]
	],true]call life_fnc_database_request;

	["CALL", "deleteOldGangs"]call life_fnc_database_request;

*/