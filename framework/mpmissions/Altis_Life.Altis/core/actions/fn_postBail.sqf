#include "..\..\script_macros.hpp"
/*
    File: fn_postBail.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Called when the player attempts to post bail.
    Needs to be revised.
*/
private ["_unit"];
_unit = param [1,objNull,[objNull]];
if (life_bail_paid) exitWith {};
if (isNil "life_bail_amount") then {life_bail_amount = 3500;};
if (!life_canpay_bail) exitWith {hint localize "STR_NOTF_Bail_Post"};
if (life_var_bank < life_bail_amount) exitWith {hint format [localize "STR_NOTF_Bail_NotEnough",life_bail_amount];};

life_var_bank = life_var_bank - life_bail_amount;
life_bail_paid = true;
[1] call MPClient_fnc_updatePartial;
[0,"STR_NOTF_Bail_Bailed",true,[profileName]] remoteExecCall ["MPClient_fnc_broadcast",RCLIENT];