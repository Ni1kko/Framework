#include "\life_backend\serverDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2

	## File not used in the framework, but can be used to create a client side function but i cant see why you would want to do that.
*/

params [
	["_target", 2, [0,objNull,sideUnknown]],
	["_expression", "", ["",{}]]
];

private _ownerID = switch (typeName _target) do {
	case "OBJECT": {owner (_target)};
	case "SIDE":   {switch (_target) do {
		case west: {SIDE_TARGET_COP};
		case east: {SIDE_TARGET_REB}; 
		case independent: {SIDE_TARGET_MED};
		default {SIDE_TARGET_CIV};
	}};
	default {_target};
};

if(typeName _expression isEqualTo "CODE")then{
	_expression = [_expression] call MPServer_fnc_util_tooExpression;
};

["CREATE", "remoteexec", 
	[
		["serverID",		["DB","INT",call life_var_serverID] call MPServer_fnc_database_parse],
		["expression", 		["DB","STRING", _expression] call MPServer_fnc_database_parse],
		["targets",			["DB","INT", _ownerID] call MPServer_fnc_database_parse]
	]
] call MPServer_fnc_database_request;

true