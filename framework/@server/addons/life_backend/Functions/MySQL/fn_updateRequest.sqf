/*
    File: fn_updateRequest.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Updates ALL player information in the database.
    Information gets passed here from the client side file: core\session\fn_updateRequest.sqf
*/

params [
    ["_uid","",[""]],
    ["_name","",[""]],
    ["_side",sideUnknown,[sideUnknown]],
    ["_cash",0,[0]],
    ["_bank",0,[0]],
    ["_licenses",[],[[]]],
    ["_gear",[],[[]]],
    ["_stats",[],[[]]],
    ["_arrested",false,[false]],
    ["_alive",false,[false]],
    ["_position",[],[[]]]
];

private _BEGuid = ('BEGuid' callExtension ("get:"+_uid));
private _playtime = [];
private _sideflag = switch (_side) do {case west: {"cop"};case independent: {"med"};default {"civ"};};

//Get to those error checks.
if ((_uid isEqualTo "") || (_name isEqualTo "")) exitWith {};
 
//--- Playtime
{if ((_x#0) isEqualTo _uid) exitWith{_playtime =_x#1}} forEach TON_fnc_playtime_values_request;
_playtime set[(switch (_side) do {case west: {0};case independent: {1};default {2};}),([_uid] call TON_fnc_getPlayTime)];

//--- Licenses
_licenses = _licenses apply{
    [_x#0,["DB","BOOL", _x#1] call life_fnc_database_parse]
};

//--- Gear
_gear params ['_loadout','_virtualitems'];

//--- 
["UPDATE", "bankaccounts", [
    [
        ["funds",["DB","A2NET", _bank] call life_fnc_database_parse]
    ],
    [
        ["BEGuid",str _BEGuid]
    ]
]]call life_fnc_database_request;

//--- 
["UPDATE", "players", [
    [
        ["name", 			                ["DB","STRING", _name] call life_fnc_database_parse],
        ["cash", 			                ["DB","A2NET", _cash] call life_fnc_database_parse],
        [format["%1_licenses",_sideflag], 	["DB","ARRAY", _licenses] call life_fnc_database_parse],
        [format["%1_gear",_sideflag], 		["DB","ARRAY", _loadout] call life_fnc_database_parse],
        [format["%1_stats",_sideflag], 	    ["DB","ARRAY", _stats] call life_fnc_database_parse],
        ["virtualitems", 	                ["DB","ARRAY", _virtualitems] call life_fnc_database_parse],
        ["arrested", 	                    ["DB","BOOL", _arrested] call life_fnc_database_parse],
        ["alive", 	                        ["DB","BOOL", _alive] call life_fnc_database_parse],
        ["position", 	                    ["DB","ARRAY", _position] call life_fnc_database_parse],
        ["playtime", 	                    ["DB","ARRAY", _playtime] call life_fnc_database_parse]
    ],
    [
        ["BEGuid",str _BEGuid]
    ]
]]call life_fnc_database_request;