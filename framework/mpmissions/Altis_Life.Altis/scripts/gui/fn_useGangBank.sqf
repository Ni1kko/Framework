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
private _gFund = GANG_FUNDS;
if ((time - life_action_delay) < 0.5) exitWith {hint localize "STR_NOTF_ActionDelay"};

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

if (count extdb_var_database_headless_clients > 0) then {
    [1,group player,_deposit,_value,player,MONEY_CASH] remoteExecCall ["HC_fnc_updateGang",extdb_var_database_headless_client]; //Update the database.
} else {
    [1,group player,_deposit,_value,player,MONEY_CASH] remoteExecCall ["MPServer_fnc_updateGang",RE_SERVER]; //Update the database.
};

life_action_delay = time;