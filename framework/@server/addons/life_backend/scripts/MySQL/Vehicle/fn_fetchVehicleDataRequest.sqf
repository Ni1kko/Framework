#include "\life_backend\serverDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
    ## fn_fetchVehicleDataRequest.sqf (Server)
*/

params [
	["_unit", objNull, [objNull]],
	["_type", "", [""]]
];

if(isNull _unit OR not(isPlayer _unit) OR count _type isEqualTo 0) exitWith {[]};

private _steamID = getPlayerUID _unit;
private _sideVar = [side _unit,true] call MPServer_fnc_util_getSideString;

private _vehiclesQuery = ["READ", "vehicles",[
    [//What
         "id", "side", "classname", "type", "pid", "alive", "active", "plate", "color"
    ],
    [//Where
        ["pid",			["DB","STRING", _steamID] call MPServer_fnc_database_parse],
        ["type",		["DB","STRING", _type] call MPServer_fnc_database_parse],
        ["side",		["DB","STRING", _sideVar] call MPServer_fnc_database_parse],
        ["alive",		["DB","BOOL",	true] call MPServer_fnc_database_parse],
        ["active",		["DB","BOOL",	false] call MPServer_fnc_database_parse],
        ["impounded",	["DB","BOOL",	false] call MPServer_fnc_database_parse]
    ]
],false];

_vehiclesQuery