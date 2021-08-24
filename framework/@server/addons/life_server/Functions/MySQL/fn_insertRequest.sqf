#include "\life_server\script_macros.hpp"
/*
    File: fn_insertRequest.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Adds a player to the database upon first joining of the server.
    Recieves information from core\sesison\fn_insertPlayerInfo.sqf

    Edits by:
    ## Nikko Renolds
	## https://github.com/Ni1kko/Framework
*/
 
params [
    ["_uid","",[""]],
    ["_name","",[""]],
    ["_money",-1,[0]],
    ["_bank",-1,[0]],
    ["_returnToSender",objNull,[objNull]]
];

//--- Error checks
if (_uid isEqualTo "") exitWith {systemChat "Bad UID";};
if (_name isEqualTo "") exitWith {systemChat "Bad name";};
if (isNull _returnToSender) exitWith {systemChat "ReturnToSender is Null!";}; //No one to send this to!

//--- 
private _BEGuid = ('BEGuid' callExtension ("get:"+_uid));
if (_BEGuid isEqualTo "") exitWith {systemChat "Bad BEGuid";};

//--- 
private _queryResult = ["READ", "players", [["pid","serverID"], [["BEGuid",str _BEGuid]]], true]call life_fnc_database_request;
 
//--- Double check to make sure the client isn't in the database...
if (_queryResult isEqualType "") exitWith {[] remoteExecCall ["SOCK_fnc_dataQuery",(owner _returnToSender)];}; //There was an entry!
if (count _queryResult > 0 AND (_queryResult#0) isNotEqualTo "DB:Read:Task-failure") exitWith {[] remoteExecCall ["SOCK_fnc_dataQuery",(owner _returnToSender)];};

//--- 
["CREATE", "players", 
    [//What
        ["serverID", 		["DB","INT", (call life_var_serverID)] call life_fnc_database_parse],
        ["BEGuid", 			["DB","STRING", _BEGuid] call life_fnc_database_parse],
        ["pid", 			["DB","STRING", _uid] call life_fnc_database_parse],
        ["name", 			["DB","STRING", _name] call life_fnc_database_parse],
        ["cash", 			["DB","A2NET", _money] call life_fnc_database_parse],
        ["bankacc", 		["DB","A2NET", _bank] call life_fnc_database_parse],
        ["aliases", 		["DB","ARRAY", [_name]] call life_fnc_database_parse],
        ["cop_licenses", 	["DB","ARRAY", []] call life_fnc_database_parse],
        ["med_licenses", 	["DB","ARRAY", []] call life_fnc_database_parse],
        ["civ_licenses", 	["DB","ARRAY", []] call life_fnc_database_parse],
        ["civ_gear", 		["DB","ARRAY", []] call life_fnc_database_parse],
        ["cop_gear", 		["DB","ARRAY", []] call life_fnc_database_parse],
        ["med_gear", 		["DB","ARRAY", []] call life_fnc_database_parse]
    ]
] call life_fnc_database_request;

[] remoteExecCall ["SOCK_fnc_dataQuery",(owner _returnToSender)];
