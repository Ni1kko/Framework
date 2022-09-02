/*
	## Nikko Renolds
	## https://github.com/Ni1kko/Framework
*/

if (life_session_completed) exitWith {}; 
if(!canSuspend)exitWith{_this spawn SOCK_fnc_requestReceived};
 
life_session_tries = life_session_tries + 1;
if (life_session_tries > 3) exitWith {["There was an error in trying to setup your client"] call life_fnc_setLoadingText; uiSleep(random[0.5,3,6]); uiSleep 5; endLoadingScreen; endMission "END1";};

["Received request from server... Validating..."] call life_fnc_setLoadingText; uiSleep(random[0.5,3,6]);

//Error handling and junk..
if (isNil "_this") exitWith {[] call SOCK_fnc_insertPlayerInfo;};
if (_this isEqualType "") exitWith {[] call SOCK_fnc_insertPlayerInfo;};
if (count _this isEqualTo 0) exitWith {[] call SOCK_fnc_insertPlayerInfo;};
if ((_this select 0) isEqualTo "Error") exitWith {[] call SOCK_fnc_insertPlayerInfo;};
if (!(getPlayerUID player isEqualTo (_this select 0))) exitWith {[] call SOCK_fnc_dataQuery;};

life_BEGuid = compileFinal str(_this#0);
life_isdev = compileFinal "(getPlayerUID _this) in getArray(missionConfigFile >> ""enableDebugConsole"")";

//--- Cash
life_var_cash = _this#2;

//--- Ranks 
life_adminlevel = compileFinal str(if !(player call life_isdev)then{this#3}else{99});
life_donorlevel = compileFinal str(_this#4);
life_joblevel = compileFinal str(_this#5);
life_reblevel = compileFinal str(_this#6);
life_medicLevel = compileFinal str(_this#7);
life_coplevel = compileFinal str(_this#8);

//--- Licenses
if (count (_this#9) > 0) then {
    {missionNamespace setVariable [_x#0,_x#1]} forEach (_this#9);
};
//--- Gear
life_var_loadout = _this#10#0;
//--- VirtualItems
life_var_vitems  = _this#10#1;
//--- Arrested
life_is_arrested = _this#11;
//--- Blacklist
life_blacklisted = _this#12;
//--- Alive
life_is_alive = _this#13;

//--- Stats
life_var_hunger = ((_this#14)#0);
life_var_thirst = ((_this#14)#1);
player setDamage ((_this#14)#2);

//--- Position
life_position = _this#15;
if (life_is_alive) then {
    if !(count life_position isEqualTo 3) then {diag_log format ["[requestReceived] Bad position received. Data: %1",life_position];life_is_alive =false;};
    if (life_position distance (getMarkerPos "respawn_civilian") < 300) then {life_is_alive = false;};
};

private _keychain = _this call BIS_fnc_arrayPop;
private _gang = _this call BIS_fnc_arrayPop;
private _houses = _this call BIS_fnc_arrayPop;
private _tents = _this call BIS_fnc_arrayPop;
 
//--- Houses
["Loading houses"] call life_fnc_setLoadingText; uiSleep(random[0.5,3,6]);
life_houses = _houses;
{
    private _house = nearestObject [(call compile format ["%1",(_x select 0)]), "House"];
    life_vehicles pushBack _house;
} forEach life_houses;
[] spawn life_fnc_initHouses;

//--- Gang
["Loading gangs"] call life_fnc_setLoadingText; uiSleep(random[0.5,3,6]);
life_gangData = _gang;
if (count life_gangData > 0) then {
    [] spawn life_fnc_initGang;
};

//--- Tents
["Loading tents"] call life_fnc_setLoadingText; uiSleep(random[0.5,3,6]);
life_tents = _tents;
if(count _tents > 0) then {
    //[] spawn life_fnc_initTents;
};

//-- Keychain
if (count _keychain > 0) then {
    {life_vehicles pushBackUnique _x} forEach _keychain;
};
  
life_isAdmin = compileFinal str ((call life_adminlevel) > 0);

[] call life_fnc_loadGear;
 
life_session_completed = true;

true