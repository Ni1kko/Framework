#include "..\..\script_macros.hpp"
/*
	File: fn_chopShopSold.sqf
	Author: Casperento
	
	Description:
	Finish chopshop sell process properly
*/
params [
    ["_price",-1,[-1]],
    ["_displayName","",[""]]
];

life_var_isBusy = false;

if (_price > 0) then {
    life_var_cash = life_var_cash + _price;
    [0] call SOCK_fnc_updatePartial;
    titleText [format[(localize "STR_NOTF_ChopSoldCar"),_displayName,[_price] call life_fnc_numberText],"PLAIN",1];
};