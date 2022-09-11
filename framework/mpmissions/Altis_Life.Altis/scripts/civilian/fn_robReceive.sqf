#include "..\..\script_macros.hpp"
/*
    File: fn_robReceive.sqf
    Author: Bryan "Tonic" Boardwine

    Description:

*/
params [
    ["_cash",0,[0]],
    ["_victim",objNull,[objNull]],
    ["_robber",objNull,[objNull]]
];

if (_robber == _victim) exitWith {};
if (_cash isEqualTo 0) exitWith {titleText[localize "STR_Civ_RobFail","PLAIN"]};
 
["ADD","CASH",_cash] call MPClient_fnc_handleMoney;
titleText[format [localize "STR_Civ_Robbed",[_cash] call MPClient_fnc_numberText],"PLAIN"];

if (LIFE_SETTINGS(getNumber,"player_moneyLog") isEqualTo 1) then {
    if (LIFE_SETTINGS(getNumber,"battlEye_friendlyLogging") isEqualTo 1) then {
        money_log = format [localize "STR_DL_ML_Robbed_BEF",[_cash] call MPClient_fnc_numberText,_victim,[life_var_bank] call MPClient_fnc_numberText,[life_var_cash] call MPClient_fnc_numberText];
    } else {
        money_log = format [localize "STR_DL_ML_Robbed",profileName,(getPlayerUID player),[_cash] call MPClient_fnc_numberText,_victim,[life_var_bank] call MPClient_fnc_numberText,[life_var_cash] call MPClient_fnc_numberText];
    };
    publicVariableServer "money_log";
};
