#include "..\..\script_macros.hpp"
/*
    File: fn_garageRefund.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    I don't know?
*/
_price = _this select 0;
_unit = _this select 1;
if !(_unit isEqualTo player) exitWith {};
life_var_bank = life_var_bank + _price;
[1] call MPClient_fnc_updatePartial;
