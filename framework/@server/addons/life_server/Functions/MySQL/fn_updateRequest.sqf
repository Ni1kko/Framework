/*
    File: fn_updateRequest.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Updates ALL player information in the database.
    Information gets passed here from the client side file: core\session\fn_updateRequest.sqf
*/
 
private _uid = [_this,0,"",[""]] call BIS_fnc_param;
private _name = [_this,1,"",[""]] call BIS_fnc_param;
private _side = [_this,2,sideUnknown,[civilian]] call BIS_fnc_param;
private _cash = [_this,3,0,[0]] call BIS_fnc_param;
private _bank = [_this,4,5000,[0]] call BIS_fnc_param;
private _licenses = [_this,5,[],[[]]] call BIS_fnc_param;
private _gear = [_this,6,[],[[]]] call BIS_fnc_param;
private _stats = [_this,7,[100,100],[[]]] call BIS_fnc_param;
private _alive = [_this,9,false,[true]] call BIS_fnc_param;
private _position = [_this,10,[],[[]]] call BIS_fnc_param;
private _BEGuid = ('BEGuid' callExtension ("get:"+_uid));

//Get to those error checks.
if ((_uid isEqualTo "") || (_name isEqualTo "")) exitWith {};
 
//--- Playtime
private _playtime = [];
{if ((_x#0) isEqualTo _uid) exitWith{_playtime =_x#1}} forEach TON_fnc_playtime_values_request;
_playtime set[(switch (_side) do {case west: {0};case independent: {1};default {2};}),([_uid] call TON_fnc_getPlayTime)];

//--- Licenses
_licenses = _licenses apply{
    [_x#0,["DB","BOOL", _x#1] call life_fnc_database_parse]
};

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
["UPDATE", "players", [(switch (_side) do {
        case west: { 
            [
                ["name", 			["DB","STRING", _name] call life_fnc_database_parse],
                ["cash", 			["DB","A2NET", _cash] call life_fnc_database_parse],
                ["cop_licenses", 	["DB","ARRAY", _licenses] call life_fnc_database_parse],
                ["cop_gear", 		["DB","ARRAY", _gear] call life_fnc_database_parse],
                ["cop_stats", 	    ["DB","ARRAY", _stats] call life_fnc_database_parse],
                ["playtime", 	    ["DB","ARRAY", _playtime_update] call life_fnc_database_parse]
            ]
        };
        case independent: { 
            [
                ["name", 			["DB","STRING", _name] call life_fnc_database_parse],
                ["cash", 			["DB","A2NET", _cash] call life_fnc_database_parse],
                ["med_licenses", 	["DB","ARRAY", _licenses] call life_fnc_database_parse],
                ["med_gear", 		["DB","ARRAY", _gear] call life_fnc_database_parse],
                ["med_stats", 	    ["DB","ARRAY", _stats] call life_fnc_database_parse],
                ["playtime", 	    ["DB","ARRAY", _playtime_update] call life_fnc_database_parse]
            ]
        };
        default {
            [
                ["name", 			["DB","STRING", _name] call life_fnc_database_parse],
                ["cash", 			["DB","A2NET", _cash] call life_fnc_database_parse],
                ["civ_licenses", 	["DB","ARRAY", _licenses] call life_fnc_database_parse],
                ["civ_gear", 		["DB","ARRAY", _gear] call life_fnc_database_parse],
                ["arrested", 	    ["DB","BOOL", _this#8] call life_fnc_database_parse],
                ["civ_stats", 	    ["DB","ARRAY", _stats] call life_fnc_database_parse],
                ["civ_alive", 	    ["DB","BOOL", _alive] call life_fnc_database_parse],
                ["civ_position", 	["DB","ARRAY", _position] call life_fnc_database_parse],
                ["playtime", 	    ["DB","ARRAY", _playtime_update] call life_fnc_database_parse]
            ]
        };
    }),
    [
        ["BEGuid",str _BEGuid],
        ["pid",str _uid]
    ]
]]call life_fnc_database_request;