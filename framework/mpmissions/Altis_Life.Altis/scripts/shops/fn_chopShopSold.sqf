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
    ["ADD","CASH",_price] call MPClient_fnc_handleMoney;
    titleText [format[(localize "STR_NOTF_ChopSoldCar"),_displayName,[_price] call MPClient_fnc_numberText],"PLAIN",1];
};