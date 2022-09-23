#include "..\..\script_macros.hpp"
/*
    File: fn_bankDeposit.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Figure it out.
*/
private ["_value"];
_value = parseNumber(ctrlText 2702);

//Series of stupid checks
if (_value > 999999) exitWith {hint localize "STR_ATM_GreaterThan";};
if (_value < 0) exitWith {};
if (!([str(_value)] call MPServer_fnc_isNumber)) exitWith {hint localize "STR_ATM_notnumeric"};
if (_value > MONEY_CASH) exitWith {hint localize "STR_ATM_NotEnoughCash"};

["SUB","CASH",_value] call MPClient_fnc_handleMoney;
["ADD","BANK",_value] call MPClient_fnc_handleMoney;

hint format [localize "STR_ATM_DepositSuccess",[_value] call MPClient_fnc_numberText];
[] call MPClient_fnc_atmMenu;
[6] call MPClient_fnc_updatePartial;

if (LIFE_SETTINGS(getNumber,"player_moneyLog") isEqualTo 1) then {
    if (LIFE_SETTINGS(getNumber,"battlEye_friendlyLogging") isEqualTo 1) then {
        money_log = format [localize "STR_DL_ML_depositedBank_BEF",_value,[life_var_bank] call MPClient_fnc_numberText,[MONEY_CASH] call MPClient_fnc_numberText];
    } else {
        money_log = format [localize "STR_DL_ML_depositedBank",profileName,(getPlayerUID player),_value,[life_var_bank] call MPClient_fnc_numberText,[MONEY_CASH] call MPClient_fnc_numberText];
    };
    publicVariableServer "money_log";
};
