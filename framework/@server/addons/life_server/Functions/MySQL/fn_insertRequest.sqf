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
    ["_player",objNull,[objNull]]
];

//--- Player data
private _uid = getPlayerUID _player;
private _name = name _player;
private _ownerID = owner _player;
private _BEGuid = ('BEGuid' callExtension ("get:"+_uid));

//--- Error checks
if (isNull _player) exitWith {systemChat "ReturnToSender is Null!";};
if (_uid isEqualTo "") exitWith {systemChat "Bad UID";};
if (_name isEqualTo "") exitWith {systemChat "Bad name";};
if (_ownerID <= 3) exitWith {systemChat "Not vaild player!";};
if (_BEGuid isEqualTo "") exitWith {systemChat "Bad BEGuid";};

//--- read database
private _queryResult = ["READ", "players", [["pid","serverID"], [["BEGuid",str _BEGuid]]], true]call life_fnc_database_request;
private _queryBankResult = ["READ", "bankaccounts", [["funds"],[["BEGuid",str _BEGuid]]],true]call life_fnc_database_request;

//--- Bad.. fail safe
if (typeName _queryResult isNotEqualTo "ARRAY" || typeName _queryBankResult isNotEqualTo "ARRAY") exitWith{[] remoteExecCall ["SOCK_fnc_dataQuery",_ownerID]};

//--- Check for inserts
private _insertBank = (count _queryBankResult isEqualTo 0);
private _insertPlayer = (count _queryResult isEqualTo 0);

//--- Double check to make sure the client isn't in the database... 
if (!_insertBank AND !_insertPlayer) exitWith {[] remoteExecCall ["SOCK_fnc_dataQuery",_ownerID]};

//--- Add new player to database
if(_insertPlayer)then{ 
    ["CREATE", "players", 
        [//What
            ["serverID", 		["DB","INT", (call life_var_serverID)] call life_fnc_database_parse],
            ["BEGuid", 			["DB","STRING", _BEGuid] call life_fnc_database_parse],
            ["pid", 			["DB","STRING", _uid] call life_fnc_database_parse],
            ["name", 			["DB","STRING", _name] call life_fnc_database_parse],
            ["cash", 			["DB","A2NET", 0] call life_fnc_database_parse],
            ["aliases", 		["DB","ARRAY", [_name]] call life_fnc_database_parse],
            ["cop_licenses", 	["DB","ARRAY", []] call life_fnc_database_parse],
            ["med_licenses", 	["DB","ARRAY", []] call life_fnc_database_parse],
            ["civ_licenses", 	["DB","ARRAY", []] call life_fnc_database_parse],
            ["civ_gear", 		["DB","ARRAY", []] call life_fnc_database_parse],
            ["cop_gear", 		["DB","ARRAY", []] call life_fnc_database_parse],
            ["med_gear", 		["DB","ARRAY", []] call life_fnc_database_parse]
        ]
    ] call life_fnc_database_request;
};

//--- Add new player bankaccount to database
if(_insertBank)then{
    private _funds = getNumber(missionConfigFile >> "Life_Settings" >> (
        switch (side _player) do {
            case independent: {"bank_med"};
            case west: {"bank_cop"};
            default {"bank_civ"}
        }
    ));
    ["CREATE", "bankaccounts", 
        [
            ["BEGuid", 			["DB","STRING", _BEGuid] call life_fnc_database_parse],
            ["funds", 			["DB","A2NET", _funds] call life_fnc_database_parse]
        ]
    ] call life_fnc_database_request;
};


//--- Tell client to re query for new data
[] remoteExecCall ["SOCK_fnc_dataQuery",_ownerID];