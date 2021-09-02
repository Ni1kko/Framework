#include "..\..\script_macros.hpp"
/*
    File: fn_requestReceived.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Called by the server saying that we have a response so let's
    sort through the information, validate it and if all valid
    set the client up.
*/
private _count = count _this;
life_session_tries = life_session_tries + 1;
if (life_session_completed) exitWith {}; //Why did this get executed when the client already initialized? Fucking arma...
if (life_session_tries > 3) exitWith {cutText[localize "STR_Session_Error","BLACK FADED"]; 0 cutFadeOut 999999999;};

0 cutText [localize "STR_Session_Received","BLACK FADED"];
0 cutFadeOut 9999999;

//Error handling and junk..
if (isNil "_this") exitWith {[] call SOCK_fnc_insertPlayerInfo;};
if (_this isEqualType "") exitWith {[] call SOCK_fnc_insertPlayerInfo;};
if (count _this isEqualTo 0) exitWith {[] call SOCK_fnc_insertPlayerInfo;};
if ((_this select 0) isEqualTo "Error") exitWith {[] call SOCK_fnc_insertPlayerInfo;};
if (!(getPlayerUID player isEqualTo (_this select 0))) exitWith {[] call SOCK_fnc_dataQuery;};

life_isdev = compileFinal "(getPlayerUID _this) in getArray(missionConfigFile >> ""enableDebugConsole"")";

switch (playerSide) do {
    case west: {
        //--- Cash
        life_var_cash = _this#2;
        //--- Admin 
        if (player call life_isdev) then{
            life_adminlevel = compileFinal str(99);
        }else{
            life_adminlevel = compileFinal str(_this#3);
        };
        //--- Donator
        if (LIFE_SETTINGS(getNumber,"donor_level") isEqualTo 1) then {
            life_donorlevel = compileFinal str(_this#4);
        } else {
            life_donorlevel = compileFinal str(0);
        };
        //--- Licenses
        if (count (_this#5) > 0) then {
            {missionNamespace setVariable [_x#0,_x#1]} forEach (_this#5);
        };
        //--- Cop
        life_coplevel = compileFinal str(_this#6);
        life_medicLevel = compileFinal str(0);
        //--- Gear
        life_var_loadout = _this#7#0;
        //--- VirtualItems
        life_var_vitems  = _this#7#1;
        //--- Blacklist
        life_blacklisted = _this#8;
        //--- Stats
        if (LIFE_SETTINGS(getNumber,"save_playerStats") isEqualTo 1) then {
            life_hunger = ((_this#9)#0);
            life_thirst = ((_this#9)#1);
            player setDamage ((_this#9)#2);
        };
    };
    case independent: {
        //--- Cash
        life_var_cash = _this#2;
        //--- Admin 
        if (player call life_isdev) then{
            life_adminlevel = compileFinal str(99);
        }else{
            life_adminlevel = compileFinal str(_this#3);
        };
        //--- Donator
        if (LIFE_SETTINGS(getNumber,"donor_level") isEqualTo 1) then {
            life_donorlevel = compileFinal str(_this#4);
        } else {
            life_donorlevel = compileFinal str(0);
        };
        //--- Licenses
        if (count (_this#5) > 0) then {
            {missionNamespace setVariable [_x#0,_x#1]} forEach (_this#5);
        };
        //--- Medic 
        life_coplevel = compileFinal str(0);
        life_medicLevel = compileFinal str(_this#6);
        //--- Gear
        life_var_loadout = _this#7#0;
        //--- VirtualItems
        life_var_vitems  = _this#7#1;
        //--- Stats
        if (LIFE_SETTINGS(getNumber,"save_playerStats") isEqualTo 1) then {
            life_hunger = ((_this#8)#0);
            life_thirst = ((_this#8)#1);
            player setDamage ((_this#8)#2);
        };
    };
    default {
        //--- Cash
        life_var_cash = _this#2;
        //--- Admin 
        if (player call life_isdev) then{
            life_adminlevel = compileFinal str(99);
        }else{
            life_adminlevel = compileFinal str(_this#3);
        };
        //--- Donator
        if (LIFE_SETTINGS(getNumber,"donor_level") isEqualTo 1) then {
            life_donorlevel = compileFinal str(_this#4);
        } else {
            life_donorlevel = compileFinal str(0);
        };
        //--- Licenses
        if (count (_this#5) > 0) then {
            {missionNamespace setVariable [_x#0,_x#1]} forEach (_this#5);
        };
        //--- Arrested
        life_is_arrested = _this#6;
        life_coplevel = compileFinal str(0);
        life_medicLevel = compileFinal str(0);
        //--- Gear
        life_var_loadout = _this#7#0;
        //--- VirtualItems
        life_var_vitems  = _this#7#1;
        //--- Stats
        if (LIFE_SETTINGS(getNumber,"save_playerStats") isEqualTo 1) then {
            life_hunger = ((_this#8)#0);
            life_thirst = ((_this#8)#1);
            player setDamage ((_this#8)#2);
        };
        //--- Position
        if (LIFE_SETTINGS(getNumber,"save_civilian_position") isEqualTo 1) then {
            //--- Alive
            life_is_alive = _this#9;
            life_position = _this#10;
            if (life_is_alive) then {
                if !(count life_position isEqualTo 3) then {diag_log format ["[requestReceived] Bad position received. Data: %1",life_position];life_is_alive =false;};
                if (life_position distance (getMarkerPos "respawn_civilian") < 300) then {life_is_alive = false;};
            };
        };
       
        //--- Houses
        life_houses = _this select (_count - 3);
        {
            _house = nearestObject [(call compile format ["%1",(_x select 0)]), "House"];
            life_vehicles pushBack _house;
        } forEach life_houses;
        [] spawn life_fnc_initHouses;

        //--- Gang
        life_gangData = _this select (_count - 2);
        if !(count life_gangData isEqualTo 0) then {
            [] spawn life_fnc_initGang;
        };
    };
};

[] call life_fnc_loadGear;
 
if (count (_this select (_count - 1)) > 0) then {
    {life_vehicles pushBack _x;} forEach (_this select (_count - 1));
};

life_session_completed = true;