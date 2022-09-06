/*
	## Nikko Renolds
	## https://github.com/Ni1kko/Framework
*/

params [
    ["_var","",[""]],
    ["_player",objNull,[objNull]],
    ["_cash",0,[0]],
    ["_bank",0,[0]],
    ["_licenses",[],[[]]],
    ["_gear",[],[[]]],
    ["_stats",[],[[]]],
    ["_arrested",false,[false]],
    ["_alive",false,[false]],
    ["_position",[],[[]]]
];
 
private _uid = getPlayerUID _player;
private _name = name _player;
private _side = side _player;
private _dmg = damage _player;

private _BEGuid = ('BEGuid' callExtension ("get:"+_uid));
private _playtime = [];
private _sideflag = switch (_side) do {case west: {"cop"};case independent: {"med"};default {"civ"};};

//Get to those error checks.
if ((_uid isEqualTo "") || (_name isEqualTo "")) exitWith {};
 
//--- Playtime
{if ((_x#0) isEqualTo _uid) exitWith{_playtime =_x#1}} forEach life_var_playtimeValuesRequest;
_playtime set[(switch (_side) do {case west: {0};case independent: {1};case east: {2};default {3};}),([_uid] call MPServer_fnc_getPlayTime)];

//--- Licenses
_licenses = _licenses apply{
    [_x#0,["DB","BOOL", _x#1] call MPServer_fnc_database_parse]
};

//--- Gear
_gear params ['_loadout','_virtualitems'];


_stats pushBack _dmg;

//--- 
["UPDATE", "bankaccounts", [
    [
        ["funds",["DB","A2NET", _bank] call MPServer_fnc_database_parse]
    ],
    [
        ["BEGuid",str _BEGuid]
    ]
]]call MPServer_fnc_database_request;

//--- 
["UPDATE", "players", [
    [
        ["name", 			                ["DB","STRING", _name] call MPServer_fnc_database_parse],
        ["cash", 			                ["DB","A2NET", _cash] call MPServer_fnc_database_parse],
        [format["%1_licenses",_sideflag], 	["DB","ARRAY", _licenses] call MPServer_fnc_database_parse],
        [format["%1_gear",_sideflag], 		["DB","ARRAY", _loadout] call MPServer_fnc_database_parse],
        ["stats", 	                        ["DB","ARRAY", _stats] call MPServer_fnc_database_parse],
        ["virtualitems", 	                ["DB","ARRAY", _virtualitems] call MPServer_fnc_database_parse],
        ["arrested", 	                    ["DB","BOOL", _arrested] call MPServer_fnc_database_parse],
        ["alive", 	                        ["DB","BOOL", _alive] call MPServer_fnc_database_parse],
        ["position", 	                    ["DB","ARRAY", _position] call MPServer_fnc_database_parse],
        ["playtime", 	                    ["DB","ARRAY", _playtime] call MPServer_fnc_database_parse]
    ],
    [
        ["BEGuid",str _BEGuid],
        ["pid",_uid]
    ]
]]call MPServer_fnc_database_request;

[missionNameSource,[_var,true]] remoteExec ["setVariable",owner _player];