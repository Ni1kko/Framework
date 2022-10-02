#include "\life_backend\script_macros.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
    ## fn_updatePlayerDataRequest.sqf (Server)
*/

params [
    ["_var","",[""]],
    ["_player",objNull,[objNull]],
    ["_cash",0,[0]],
    ["_bank",0,[0]],
    ["_debt",0,[0]],
    ["_licenses",[],[[]]],
    ["_gear",[],[[]]],
    ["_stats",[],[[]]],
    ["_arrested",false,[false]],
    ["_alive",false,[false]]
];

if (isNull _player) exitWith {false};

private _uid = getPlayerUID _player;
private _name = name _player;
private _side = side _player;
private _damage = damage _player;
private _position = getPosATL _player;

 
private _BEGuid = GET_BEGUID(_player);
private _playtime = [];
private _sideflag = [_side,true] call MPServer_fnc_util_getSideString;

//Get to those error checks.
if (_BEGuid isEqualTo "" OR _uid isEqualTo "" OR _name isEqualTo "") exitWith {false};
 
//--- Playtime
{if ((_x#0) isEqualTo _uid) exitWith{_playtime =_x#1}} forEach life_var_playtimeValuesRequest;
_playtime set[(switch (_side) do {case west: {0};case independent: {1};case east: {2};default {3};}),([_uid] call MPServer_fnc_getPlayTime)];

//--- Damage
_stats set [2, _damage];

//--- Players
["UPDATE", "players", [
    [
        ["name", 			                ["DB","STRING", _name] call MPServer_fnc_database_parse],
        ["cash", 			                ["DB","A2NET", _cash] call MPServer_fnc_database_parse],
        [format["%1_licenses",_sideflag], 	["DB","LICENSES", _licenses] call MPServer_fnc_database_parse],
        [format["%1_gear",_sideflag], 		["DB","ARRAY", _gear#0] call MPServer_fnc_database_parse],
        ["virtualitems", 	                ["DB","ARRAY", _gear#1] call MPServer_fnc_database_parse],
        ["stats", 	                        ["DB","ARRAY", _stats] call MPServer_fnc_database_parse],
        ["arrested", 	                    ["DB","BOOL", _arrested] call MPServer_fnc_database_parse],
        ["alive", 	                        ["DB","BOOL", _alive] call MPServer_fnc_database_parse],
        ["position", 	                    ["DB","POSITION", _position] call MPServer_fnc_database_parse],
        ["playtime", 	                    ["DB","ARRAY", _playtime] call MPServer_fnc_database_parse]
    ],
    [
        ["BEGuid",str _BEGuid],
        ["pid",_uid]
    ]
]]call MPServer_fnc_database_request;

//--- Bank
if(not([_player] call MPServer_fnc_updateBankDataRequest))then{
    [format ["Error updating bank: %1",_BEGuid]] call MPServer_fnc_log;
};

[missionNameSource,[_var,true]] remoteExec ["setVariable",owner _player];

true