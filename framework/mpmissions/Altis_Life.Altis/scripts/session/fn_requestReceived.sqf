#include "..\..\script_macros.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

params [
    ["_userdata",[],[[]]], 
    ["_cash",0,[0]],
    ["_adminRank",0,[0]],
    ["_donatorRank",0,[0]],
    ["_jobRank",0,[0]],
    ["_rebelRank",0,[0]],
    ["_medicRank",0,[0]],
    ["_copRank",0,[0]],
    ["_licenses",[],[[]]],
    ["_gear",[],[[]]],
    ["_arrested",false,[false]],
    ["_blacklist",false,[false]],
    ["_alive",false,[false]],
    ["_stats",[],[[]]],
    ["_position",[],[[]]],
    ["_tents",[],[[]]],
    ["_houses",[],[[]]],
    ["_gang",[],[[]]],
    ["_keychain",[],[[]]]
];

if (life_session_completed) exitWith {
    diag_log "Framework: `fn_requestReceived` => Session already completed";
    false
};

//---
["Received request from server", "Validating..."] call MPClient_fnc_setLoadingText; uiSleep(random[0.5,3,6]);

//--- Timeout sanity check
life_var_session_attempts = life_var_session_attempts + 1;
if (life_var_session_attempts > MAX_ATTEMPTS_TOO_QUERY_DATA) exitWith {["There was an error in trying to setup your client"] call MPClient_fnc_setLoadingText;};
 
//--- Bad data
if (count _userdata isNotEqualTo 2) exitWith {[] call MPClient_fnc_insertPlayerInfo};

//-- parse data
_userdata params [["_steamID","",[""]],["_BEGuid","",[""]]];

//--- Wrong client
if (getPlayerUID player isNotEqualTo _steamID) exitWith {[] call MPClient_fnc_dataQuery};

life_BEGuid = compileFinal str(_BEGuid);
life_isdev = compileFinal "(getPlayerUID _this) in getArray(missionConfigFile >> ""enableDebugConsole"")";

//--- Cash
["ADD","CASH",_cash] call MPClient_fnc_handleMoney;

//--- Ranks 
life_adminlevel = compileFinal str(if !(player call life_isdev)then{_adminRank}else{99});
life_donorlevel = compileFinal str(_donatorRank);
life_joblevel = compileFinal str(_jobRank);
life_reblevel = compileFinal str(_rebelRank);
life_medLevel = compileFinal str(_medicRank);
life_coplevel = compileFinal str(_copRank);

//--- Licenses
if (count _licenses > 0) then {
    {missionNamespace setVariable [_x#0,_x#1]} forEach _licenses;
};

_gear params [
    ["_loadout",[],[[]]],
    ["_vItems",[],[[]]]
];

//--- Gear
life_var_loadout = _loadout;
//--- VirtualItems
life_var_vitems  = _vItems;
//--- Arrested
life_is_arrested = _arrested;
//--- Blacklist
life_blacklisted = _blacklist;
//--- Alive
life_is_alive = _alive;

_stats params [
    ["_hunger",100,[0]],
    ["_thirst",100,[0]],
    ["_health",100,[0]]
];

//--- Stats
life_var_hunger = _hunger;
life_var_thirst = _thirst;
player setDamage _health;

//--- Position
life_position = _position;
if (life_is_alive) then {
    if !(count life_position isEqualTo 3) then {diag_log format ["[requestReceived] Bad position received. Data: %1",life_position];life_is_alive =false;};
    if (life_position distance (getMarkerPos "respawn_civilian") < 300) then {life_is_alive = false;};
}; 

//--- Houses
["Loading houses", "Please wait..."] call MPClient_fnc_setLoadingText; uiSleep(random[0.5,3,6]);
life_houses = _houses;
{
    private _house = nearestObject [(call compile format ["%1",(_x select 0)]), "House"];
    life_vehicles pushBack _house;
} forEach life_houses;
[] spawn MPClient_fnc_initHouses;

//--- Gang
["Loading gangs", "Please wait..."] call MPClient_fnc_setLoadingText; uiSleep(random[0.5,3,6]);
life_gangData = _gang;
if (count life_gangData > 0) then {
    [] spawn MPClient_fnc_initGang;
};

//--- Tents
["Loading tents", "Please wait..."] call MPClient_fnc_setLoadingText; uiSleep(random[0.5,3,6]);
life_tents = _tents;
if(count _tents > 0) then {
    //[] spawn MPClient_fnc_initTents;
};

//-- Keychain
if (count _keychain > 0) then {
    {life_vehicles pushBackUnique _x} forEach _keychain;
};
  
life_isAdmin = compileFinal str ((call life_adminlevel) > 0);

[] call MPClient_fnc_loadGear;
 
life_session_completed = true;

true