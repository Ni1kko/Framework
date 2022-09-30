#include "..\..\script_macros.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
    ## fn_requestReceived.sqf (Client)
*/

FORCE_SUSPEND("MPClient_fnc_requestReceived");

params [
    ["_playerData",createHashMap,[createHashMap]]
];

if (life_session_completed) exitWith {
    ["`MPClient_fnc_requestReceived` => Session already completed"] call MPClient_fnc_log;
    false
};

//---
["Received request from server", "Validating..."] call MPClient_fnc_setLoadingText; uiSleep(random[0.5,3,6]);

//--- Timeout sanity check
life_var_session_attempts = life_var_session_attempts + 1;
if (life_var_session_attempts > MAX_ATTEMPTS_TOO_QUERY_DATA) exitWith {
    ["An Error Occured", "There was an error in trying to setup your client"] call MPClient_fnc_endMission;
};
 
//--- Bad data
if (count (_playerData getOrDefault ["UserData",[]]) isNotEqualTo 2) exitWith {[] call MPClient_fnc_insertPlayerInfo};

//-- parse data
(_playerData get "UserData") params [["_steamID","",[""]],["_BEGuid","",[""]]];

//--- Wrong client
if (getPlayerUID player isNotEqualTo _steamID) exitWith {[] call MPClient_fnc_dataQuery};

//--- Prevent BEGuid from being changed
[]spawn {
    private _lastBEGuid = "";
    waitUntil {isFinal "life_BEGuid"};
    ["Session Object BEGuid Loading!"] call MPClient_fnc_log;
    while{true}do{
        waitUntil {
            uiSleep round(random 3);
            (player getVariable ["BEGUID",{""}]) isNotEqualTo life_BEGuid
        };
        player setVariable ["BEGUID",life_BEGuid,true];

        if(count _lastBEGuid > 0 AND count (call (player getVariable ["BEGUID",{""}])) > 0)then{
            [format["Session Object BEGuid(%1) Changed Too BEGuid(%2)!",_lastBEGuid,call (player getVariable ["BEGUID",{""}])]] call MPClient_fnc_log;
        }else{
            [format["Session Object BEGuid(%1) Set!",call (player getVariable ["BEGUID",{""}])]] call MPClient_fnc_log;
        };

        _lastBEGuid = call (player getVariable ["BEGUID",{""}]);
    };
};

life_BEGuid =       compileFinal str(_playerData getOrDefault ["BEGuid",_BEGuid]);
life_isdev =        compileFinal "(getPlayerUID _this) in getArray(missionConfigFile >> ""enableDebugConsole"")";
life_adminlevel =   compileFinal str(if !(player call life_isdev)then{_playerData getOrDefault ["AdminRank",-1]}else{99});
life_isAdmin =      compileFinal str((call life_adminlevel) > 0);
life_donorlevel =   compileFinal str(_playerData getOrDefault ["DonatorRank",-1]);
life_joblevel =     compileFinal str(_playerData getOrDefault ["JobRank",-1]);
life_reblevel =     compileFinal str(_playerData getOrDefault ["RebelRank",-1]);
life_medLevel =     compileFinal str(_playerData getOrDefault ["MedicRank",-1]);
life_coplevel =     compileFinal str(_playerData getOrDefault ["PoliceRank",-1]);
life_is_arrested =  _playerData getOrDefault ["Arrested",false];
life_blacklisted =  _playerData getOrDefault ["Blacklist",false];
life_is_alive =     _playerData getOrDefault ["Alive",false];

//--- Cash
["SET","CASH",_playerData getOrDefault ["Cash",0]] call MPClient_fnc_handleMoney;
 
//--- Licenses
if (count (_playerData getOrDefault ["Licenses",[]]) > 0) then {
    {[player, _x#0, _x#1, false] call MPClient_fnc_setLicenses} forEach (_playerData get "Licenses");
};

//--- Gear & VirtualItems
[player, [
    _playerData getOrDefault ["Gear",[]], 
    _playerData getOrDefault ["VItems",[]]
]] call MPClient_fnc_loadGear;

//--- Stats
life_var_hunger = _playerData getOrDefault ["Hunger",100];
life_var_thirst = _playerData getOrDefault ["Thirst",100];
player setDamage (_playerData getOrDefault ["Damage",0]);

//--- Position
life_position = _playerData getOrDefault ["Position",[]];
if (life_is_alive) then {
    if !(count life_position isEqualTo 3) then { 
        [format ["[Bad position received. Data: %1",life_position],true,true] call MPClient_fnc_log;
        life_position = getMarkerPos "respawn_civilian";
    };
    if (life_position distance (getMarkerPos "respawn_civilian") < 700) then {life_is_alive = false;life_position = [];};
};

//--- Houses
["Loading houses", "Please wait..."] call MPClient_fnc_setLoadingText; uiSleep(random[0.5,3,6]);
life_houses = _playerData getOrDefault ["HouseData",[]];
{
    private _house = nearestObject [(call compile format ["%1",(_x select 0)]), "House"];
    life_vehicles pushBack _house;
} forEach life_houses;
[] spawn MPClient_fnc_initHouses;

//--- Gang
["Loading gangs", "Please wait..."] call MPClient_fnc_setLoadingText; uiSleep(random[0.5,3,6]);
life_gangData = _playerData getOrDefault ["GangData",[]];
if (count life_gangData > 0) then {
    [] spawn MPClient_fnc_initGang;
};

//--- Tents
["Loading tents", "Please wait..."] call MPClient_fnc_setLoadingText; uiSleep(random[0.5,3,6]);
life_tents = _playerData getOrDefault ["TentData",[]];
if (count life_tents > 0) then {
    //[] spawn MPClient_fnc_initTents;
};

//-- Keychain
if (count (_playerData getOrDefault ["Keychain",[]]) > 0) then {
    {life_vehicles pushBackUnique _x} forEach (_playerData get "Keychain");
};
 
life_session_completed = true;

true