#include "..\..\script_macros.hpp"
/*
    File: fn_gangWithdraw.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Withdraws money from the gang bank.
*/
params [
    ["_deposit",false,[false]]
];

private _value = parseNumber(ctrlText 2702);
private _gFund = MONEY_GANG;
if ((time - life_var_actionDelay) < 0.5) exitWith {hint localize "STR_NOTF_ActionDelay"};

//Series of stupid checks
if (isNil {(group player) getVariable "gang_name"}) exitWith {hint localize "STR_ATM_NotInGang"}; // Checks if player isn't in a gang
if (_value > 999999) exitWith {hint localize "STR_ATM_WithdrawMax";};
if (_value < 1) exitWith {};
if (!([str(_value)] call MPServer_fnc_isNumber)) exitWith {hint localize "STR_ATM_notnumeric"};
if (_deposit && _value > MONEY_CASH) exitWith {hint localize "STR_ATM_NotEnoughCash"};
if (!_deposit && _value > _gFund) exitWith {hint localize "STR_ATM_NotEnoughFundsG"};

if (_deposit) then {
    ["SUB","CASH",_value] call MPClient_fnc_handleMoney;
    [] call MPClient_fnc_atmMenu;
};

[1,group player,_deposit,_value,player,MONEY_CASH] remoteExec ["MPServer_fnc_updateGangDataRequestPartial",RE_SERVER];

life_var_actionDelay = time;