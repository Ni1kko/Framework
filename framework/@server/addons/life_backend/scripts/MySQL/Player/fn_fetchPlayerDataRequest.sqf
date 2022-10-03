#include "\life_backend\script_macros.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
    ## fn_fetchPlayerDataRequest.sqf (Server)
*/

params [
    ["_player",objNull,[objNull]]
];

if (isNull _player) exitWith {};

private _playerData = createHashMapFromArray [
    ["SteamID", getPlayerUID _player],
    ["OwnerID", owner _player],
    ["NetID", netId _player],
    ["Side", side _player],
    ["Name", name _player]
]; 

_playerData set ["SideVar", [_playerData get "Side",true] call MPServer_fnc_util_getSideString];
_playerData set ["BEGuid", 'BEGuid' callExtension (["get", _playerData get "SteamID"] joinString ":")];

private _queryClause = [["BEGuid",str(_playerData get "BEGuid")]];
private _queryParams = [
    /* _queryResult#0  */ "pid", 
    /* _queryResult#1  */ "name", 
    /* _queryResult#2  */ "cash", 
    /* _queryResult#3  */ "adminlevel", 
    /* _queryResult#4  */ "donorlevel", 
    /* _queryResult#5  */ "joblevel", 
    /* _queryResult#6  */ "reblevel", 
    /* _queryResult#7  */ "mediclevel", 
    /* _queryResult#8  */ "coplevel",
    /* _queryResult#9  */ format ["%1_licenses",_playerData get "SideVar"],
    /* _queryResult#10 */ format ["%1_gear",_playerData get "SideVar"], 
    /* _queryResult#11 */ "virtualitems", 
    /* _queryResult#12 */ "arrested", 
    /* _queryResult#13 */ "blacklist", 
    /* _queryResult#14 */ "alive", 
    /* _queryResult#15 */ "stats", 
    /* _queryResult#16 */ "position", 
    /* _queryResult#17 */ "playtime"
];

private _queryResult = ["READ", "players", [_queryParams,_queryClause],true]call MPServer_fnc_database_request;
if (_queryResult isEqualTo ["DB:Read:Task-failure",false]) exitWith {[format ["Error reading player: %1",_playerData get "BEGuid"]] call MPServer_fnc_log};
if (count _queryResult isEqualTo 0) exitWith {[] remoteExec ["MPClient_fnc_insertPlayerData",_playerData get "OwnerID"]};
if (not([_player] call MPServer_fnc_fetchBankDataRequest)) exitWith {[] remoteExec ["MPClient_fnc_insertPlayerData",_playerData get "OwnerID"]};

//--- UserData (2)
_playerData set ["UserData",        [_queryResult#0,_playerData get "BEGuid"]];
_playerData set ["Cash",            ["GAME","A2NET", _queryResult#2] call MPServer_fnc_database_parse];
_playerData set ["AdminRank",       ["GAME","INT", _queryResult#3] call MPServer_fnc_database_parse];
_playerData set ["DonatorRank",     ["GAME","INT", _queryResult#4] call MPServer_fnc_database_parse];
_playerData set ["JobRank",         ["GAME","INT", _queryResult#5] call MPServer_fnc_database_parse];
_playerData set ["RebelRank",       ["GAME","INT", _queryResult#6] call MPServer_fnc_database_parse];
_playerData set ["MedicRank",       ["GAME","INT", _queryResult#7] call MPServer_fnc_database_parse];
_playerData set ["PoliceRank",      ["GAME","INT", _queryResult#8] call MPServer_fnc_database_parse];
_playerData set ["Licenses",        ["GAME","LICENSES", _queryResult#9] call MPServer_fnc_database_parse];
_playerData set ["Gear",            ["GAME","ARRAY", _queryResult#10] call MPServer_fnc_database_parse];
_playerData set ["VItems",          ["GAME","ARRAY", _queryResult#11] call MPServer_fnc_database_parse];
_playerData set ["Arrested",        ["GAME","BOOL", _queryResult#12] call MPServer_fnc_database_parse];
_playerData set ["Blacklist",       ["GAME","BOOL", _queryResult#13] call MPServer_fnc_database_parse];
_playerData set ["Alive",           ["GAME","BOOL", _queryResult#14] call MPServer_fnc_database_parse];
_playerData set ["Stats",           ["GAME","ARRAY", _queryResult#15] call MPServer_fnc_database_parse];
_playerData set ["Position",        ["GAME","POSITION", _queryResult#16] call MPServer_fnc_database_parse];
_playerData set ["PlayTime",        ["GAME","ARRAY", _queryResult#17] call MPServer_fnc_database_parse];

//--- Player Stats
{
    if(count(_playerData getOrDefault ["Stats",[]]) >= _forEachIndex)then{
        _playerData set [_x, (_playerData get "Stats")#_forEachIndex]; 
    };
}forEach[
    "Hunger",
    "Thirst",
    "Damage"
];

//         
[_playerData get "SteamID", _playerData get "PlayTime"] call MPServer_fnc_registerPlayTime;

//--- Tents
//private _tentsData = [_playerData get "SteamID"] spawn MPServer_fnc_fetchPlayerTents;
//waitUntil {scriptDone _tentsData};
_playerData set ["TentData", missionNamespace getVariable [format ["tents_%1",_playerData get "SteamID"],[]]];
 
//--- Houses
private _houseData = [_playerData get "SteamID"] spawn MPServer_fnc_fetchPlayerHouses;
waitUntil {scriptDone _houseData};
_playerData set ["HouseData", missionNamespace getVariable [format ["houses_%1",_playerData get "SteamID"],[]]];
        
//--- Gang
_playerData set ["GangData", [_playerData get "SteamID"] call MPServer_fnc_fetchGangDataRequest];
         
//--- Keychain
_playerData set ["Keychain", missionNamespace getVariable [format ["%1_KEYS_%2",_playerData get "SteamID",_playerData get "Side"],[]]];
    
//--- EventHandler for logging
if (LIFE_SETTINGS(getNumber,"player_deathLog") isEqualTo 1) then {
    _player setVariable ["MPKilledIndex",_player addMPEventHandler ["MPKilled", {_this call MPServer_fnc_whoDoneIt}],true];
};

//--- Send to client
[_playerData] remoteExec ["MPClient_fnc_receivePlayerData",_playerData get "OwnerID"];

//--- Return 
true