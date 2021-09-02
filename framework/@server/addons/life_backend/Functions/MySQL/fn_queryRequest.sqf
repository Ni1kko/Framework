#include "\life_backend\script_macros.hpp"
/*
    File: fn_queryRequest.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Handles the incoming request and sends an asynchronous query
    request to the database.

    Return:
    ARRAY - If array has 0 elements it should be handled as an error in client-side files.
    STRING - The request had invalid handles or an unknown error and is logged to the RPT.
*/
params [
    ["_player",objNull,[objNull]]
];

if (isNull _player) exitWith {};

if (LIFE_SETTINGS(getNumber,"player_deathLog") isEqualTo 1) then {
    _player addMPEventHandler ["MPKilled", {_this call TON_fnc_whoDoneIt}];
};
 
private _uid = getPlayerUID _player;
private _side = side _player;
private _ownerID = owner _player;
private _netID = netId _player;
private _BEGuid = ('BEGuid' callExtension ("get:"+_uid));
private _queryBankResult = ["READ", "bankaccounts", [["funds"],[["BEGuid",str _BEGuid]]],true]call life_fnc_database_request;
private _queryResult = ["READ", "players", [
    (switch (_side) do { 
        case west:        {["pid", "name", "cash", "adminlevel", "donorlevel", "virtualitems", "cop_licenses", "coplevel", "cop_gear", "blacklist", "cop_stats", "playtime"]};
        case independent: {["pid", "name", "cash", "adminlevel", "donorlevel", "virtualitems", "med_licenses", "mediclevel", "med_gear", "med_stats, playtime"]};
        default           {["pid", "name", "cash", "adminlevel", "donorlevel", "virtualitems", "civ_licenses", "arrested", "civ_gear", "civ_stats", "alive", "position", "playtime"]};
    }),
    [
        ["BEGuid",str _BEGuid],
        ["pid",_uid]
    ]
],true]call life_fnc_database_request;

if (_queryResult isEqualTo ["DB:Read:Task-failure",false]) exitWith {
    diag_log format ["Error reading player: %1",_BEGuid];
};

if (_queryBankResult isEqualTo ["DB:Read:Task-failure",false]) exitWith {
    diag_log format ["Error reading player-bank: %1",_BEGuid];
};

if (count _queryResult isEqualTo 0 || count _queryBankResult isEqualTo 0) exitWith {
    [] remoteExecCall ["SOCK_fnc_insertPlayerInfo",_ownerID];
}; 

private _return = _queryResult select [0,2];
switch (_side) do {
    case west: {
        //--- Cash
        _return pushBack (["GAME","A2NET", (_queryResult#2)] call life_fnc_database_parse);
        //--- Admin 
        _return pushBack (["GAME","INT", (_queryResult#3)] call life_fnc_database_parse);
        //--- Donator
        _return pushBack (["GAME","INT", (_queryResult#4)] call life_fnc_database_parse);
        //--- Licenses
        _return pushBack ((["GAME","ARRAY", _queryResult#6] call life_fnc_database_parse) apply{[_x#0,["GAME","BOOL", _x#1] call life_fnc_database_parse]});
        //--- Cop 
        _return pushBack (["GAME","INT", (_queryResult#7)] call life_fnc_database_parse);
        //--- Gear
        _return pushBack [(["GAME","ARRAY", (_queryResult#8)] call life_fnc_database_parse),["GAME","ARRAY", (_queryResult#5)] call life_fnc_database_parse];
        //--- Blacklist
        _return pushBack (["GAME","BOOL", (_queryResult#9)] call life_fnc_database_parse);
        //--- Stats
        _return pushBack (["GAME","ARRAY", (_queryResult#10)] call life_fnc_database_parse);

        //--- Playtime
        private _playtimenew = ["GAME","ARRAY", (_queryResult#11)] call life_fnc_database_parse;
        private _playtimeindex = TON_fnc_playtime_values_request find [_uid, _playtimenew];
        if (_playtimeindex != -1) then {
            TON_fnc_playtime_values_request set[_playtimeindex,-1];
            TON_fnc_playtime_values_request = TON_fnc_playtime_values_request - [-1];
            TON_fnc_playtime_values_request pushBack [_uid, _playtimenew];
        } else {
            TON_fnc_playtime_values_request pushBack [_uid, _playtimenew];
        };
        [_uid,_playtimenew#0] call TON_fnc_setPlayTime;
    };
    case independent: {
        //--- Cash
        _return pushBack (["GAME","A2NET", (_queryResult#2)] call life_fnc_database_parse);
        //--- Admin 
        _return pushBack (["GAME","INT", (_queryResult#3)] call life_fnc_database_parse);
        //--- Donator
        _return pushBack (["GAME","INT", (_queryResult#4)] call life_fnc_database_parse);
        //--- Licenses
        _return pushBack ((["GAME","ARRAY", _queryResult#6] call life_fnc_database_parse) apply{[_x#0,["GAME","BOOL", _x#1] call life_fnc_database_parse]});
        //--- Medic 
        _return pushBack (["GAME","INT", (_queryResult#7)] call life_fnc_database_parse);
        //--- Gear
        _return pushBack [(["GAME","ARRAY", (_queryResult#8)] call life_fnc_database_parse),["GAME","ARRAY", (_queryResult#5)] call life_fnc_database_parse];
        //--- Stats
        _return pushBack (["GAME","ARRAY", (_queryResult#9)] call life_fnc_database_parse);
        
        //--- Playtime
        private _playtimenew = ["GAME","ARRAY", (_queryResult#10)] call life_fnc_database_parse;
        private _playtimeindex = TON_fnc_playtime_values_request find [_uid, _playtimenew];
        if !(_playtimeindex isEqualTo -1) then {
            TON_fnc_playtime_values_request set[_playtimeindex,-1];
            TON_fnc_playtime_values_request = TON_fnc_playtime_values_request - [-1];
            TON_fnc_playtime_values_request pushBack [_uid, _playtimenew];
        } else {
            TON_fnc_playtime_values_request pushBack [_uid, _playtimenew];
        };
        [_uid,_playtimenew#1] call TON_fnc_setPlayTime;
    };
    default {
        //--- Cash
        _return pushBack (["GAME","A2NET", (_queryResult#2)] call life_fnc_database_parse);
        //--- Admin 
        _return pushBack (["GAME","INT", (_queryResult#3)] call life_fnc_database_parse);
        //--- Donator
        _return pushBack (["GAME","INT", (_queryResult#4)] call life_fnc_database_parse);
        //--- Licenses
        _return pushBack ((["GAME","ARRAY", _queryResult#6] call life_fnc_database_parse) apply{[_x#0,["GAME","BOOL", _x#1] call life_fnc_database_parse]});
        //--- Arrested
        _return pushBack (["GAME","BOOL", (_queryResult#7)] call life_fnc_database_parse);
        //--- Gear
        _return pushBack [(["GAME","ARRAY", (_queryResult#8)] call life_fnc_database_parse),["GAME","ARRAY", (_queryResult#5)] call life_fnc_database_parse];
        //--- Stats
        _return pushBack (["GAME","ARRAY", (_queryResult#9)] call life_fnc_database_parse);
        //--- Alive
        _return pushBack (["GAME","BOOL", (_queryResult#10)] call life_fnc_database_parse);
        //--- Position
        _return pushBack (["GAME","POSITION", (_queryResult#11)] call life_fnc_database_parse);
        //--- Playtime
        private _playtimenew = ["GAME","ARRAY", (_queryResult#12)] call life_fnc_database_parse; 
        private _playtimeindex = TON_fnc_playtime_values_request find [_uid, _playtimenew];
        if (_playtimeindex != -1) then {
            TON_fnc_playtime_values_request set[_playtimeindex,-1];
            TON_fnc_playtime_values_request = TON_fnc_playtime_values_request - [-1];
            TON_fnc_playtime_values_request pushBack [_uid, _playtimenew];
        } else {
            TON_fnc_playtime_values_request pushBack [_uid, _playtimenew];
        };
        [_uid,_playtimenew#2] call TON_fnc_setPlayTime;

        //--- Houses
        private _houseData = _uid spawn TON_fnc_fetchPlayerHouses;
        waitUntil {scriptDone _houseData};
        _return pushBack (missionNamespace getVariable [format ["houses_%1",_uid],[]]);
        
        //--- Gang
        private _gangData = _uid spawn TON_fnc_queryPlayerGang;
        waitUntil{scriptDone _gangData};
        _return pushBack (missionNamespace getVariable [format ["gang_%1",_uid],[]]);
    };
};

//--- Keychain
_return pushBack (missionNamespace getVariable [format ["%1_KEYS_%2",_uid,_side],[]]);

//--- Bank 
[missionNamespace,["life_var_bank",(["GAME","A2NET", (_queryBankResult#0)] call life_fnc_database_parse)]] remoteExec ["setVariable",_ownerID];

//--- Broadcast playtime
publicVariable "TON_fnc_playtime_values_request";

//--- Return
_return remoteExec ["SOCK_fnc_requestReceived",_ownerID];