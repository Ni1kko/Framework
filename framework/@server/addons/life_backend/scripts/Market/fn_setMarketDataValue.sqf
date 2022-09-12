/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

params [
	["_item","",[""]],
	["_newData",createHashMap,[createHashMap]],
	["_forceDatabaseUpdate",false,[false]],
	["_forceBroadcast",false,[false]]
];

private _cfgVirtualItems = missionConfigFile >> "VirtualItems";
private _cfgItem = _cfgVirtualItems >> _item;

if(not(isClass _cfgItem))exitWith {createHashMap};

private _oldData = life_var_marketConfig getOrDefault [_item,createHashMap];

_newData set ["buyPrice", 	_newData getOrDefault ["buyPrice", _oldData getOrDefault ["buyPrice",getNumber(_cfgItem >> "buyPrice")]]];
_newData set ["sellPrice",	_newData getOrDefault ["sellPrice", _oldData getOrDefault ["sellPrice", getNumber(_cfgItem >> "sellPrice")]]];
_newData set ["illegal", 	_newData getOrDefault ["illegal", _oldData getOrDefault ["illegal", getNumber(_cfgItem >> "illegal") isEqualTo 1]]];
_newData set ["stock",		_newData getOrDefault ["stock", _oldData getOrDefault ["stock", getNumber(_cfgItem >> "stock")]];

if _forceDatabaseUpdate then{
	["UPDATE", "market", [
		[
			["buyPrice", 		["DB","INT", _newData get "buyPrice"] call MPServer_fnc_database_parse],
			["sellPrice", 		["DB","INT", _newData get "sellPrice"] call MPServer_fnc_database_parse],
			["stock", 			["DB","INT", _newData get "stock"] call MPServer_fnc_database_parse],
			["illegal", 		["DB","BOOL", _newData get "illegal"] call MPServer_fnc_database_parse]
		],
		[
			["item",["DB","STRING", _item] call MPServer_fnc_database_parse]
		]
	]]call MPServer_fnc_database_request;

	[format["[Life Market] Updating item(%1) in database",_item]] call MPServer_fnc_log;
};

life_var_marketConfig set [_item, _newData];

if _forceBroadcast then {
	publicVariable "life_var_marketConfig";
};

_newData