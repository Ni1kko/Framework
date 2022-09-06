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
private _var = format["Sync_%1_Completed_%2",round(random[1000,5000,9999]),round diag_tickTime];

[] call life_fnc_saveGear;

[
    _var,
    player,
    life_var_cash,
    life_var_bank,
    (_licenses apply{[LICENSE_VARNAME(configName _x,_sideflag),LICENSE_VALUE(configName _x,_sideflag)]}),
    [life_var_loadout,life_var_vitems],
    [life_var_hunger,life_var_thirst],
    life_is_arrested,
    _alive,
    _position
] remoteExecCall ["MPServer_fnc_updateRequest",2];

_var