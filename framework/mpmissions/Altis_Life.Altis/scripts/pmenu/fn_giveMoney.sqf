#include "..\..\script_macros.hpp"
/*
    File: fn_giveMoney.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Gives the selected amount of money to the selected player.
*/
private ["_unit","_amount"];
_amount = ctrlText 105;
ctrlShow[106,false];
if ((lbCurSel 107) isEqualTo -1) exitWith {hint localize "STR_NOTF_noOneSelected";ctrlShow[106,true];};
_unit = lbData [107,lbCurSel 107];
_unit = call compile format ["%1",_unit];
if (isNil "_unit") exitWith {ctrlShow[106,true];};
if (_unit == player) exitWith {ctrlShow[106,true];};
if (isNull _unit) exitWith {ctrlShow[106,true];};

//A series of checks *ugh*
if (!life_var_ATMEnabled) exitWith {hint localize "STR_NOTF_recentlyRobbedBank";ctrlShow[106,true];};
if (!([_amount] call MPServer_fnc_isNumber)) exitWith {hint localize "STR_NOTF_notNumberFormat";ctrlShow[106,true];};
if (parseNumber(_amount) <= 0) exitWith {hint localize "STR_NOTF_enterAmount";ctrlShow[106,true];};
if (parseNumber(_amount) > life_var_cash) exitWith {hint localize "STR_NOTF_notEnoughtToGive";ctrlShow[106,true];};
if (isNull _unit) exitWith {ctrlShow[106,true];};
if (isNil "_unit") exitWith {ctrlShow[106,true]; hint localize "STR_NOTF_notWithinRange";};

hint format [localize "STR_NOTF_youGaveMoney",[(parseNumber(_amount))] call MPClient_fnc_numberText,_unit getVariable ["realname",name _unit]];

["SUB","CASH",parseNumber _amount] call MPClient_fnc_handleMoney;

[_unit,_amount,player] remoteExecCall ["MPClient_fnc_receiveMoney",_unit];
[] call MPClient_fnc_p_updateMenu;

ctrlShow[106,true];