#include "..\..\script_macros.hpp"
/*
    File: fn_updateRequest.sqf
    Author: Tonic

    Description:
    Passes ALL player information to the server to save player data to the database.
*/
 
private _alive = alive player;
private _position = getPosATL player;
private _sideflag = switch (playerSide) do {case west: {"cop"}; case civilian: {"civ"}; case independent: {"med"};};
private _licenses = format ["getText(_x >> 'side') isEqualTo '%1'",_sideflag] configClasses (missionConfigFile >> "Licenses");

[] call life_fnc_saveGear;

[
    getPlayerUID player,
    name player,
    side player,
    life_var_cash,
    life_var_bank,
    (_licenses apply{[LICENSE_VARNAME(configName _x,_sideflag),LICENSE_VALUE(configName _x,_sideflag)]}),
    [life_var_loadout,life_var_vitems],
    [life_hunger,life_thirst,(damage player)],
    life_is_arrested,
    _alive,
    _position
] remoteExecCall ["DB_fnc_updateRequest",2];