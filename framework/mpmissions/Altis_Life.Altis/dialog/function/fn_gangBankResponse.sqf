#include "..\..\script_macros.hpp"
/*
    File: fn_gankBankResponse.sqf
    Author: DomT602
    Description:
    Receives response from the server.
*/
params [
    ["_value",-1,[0]]
];
if (remoteExecutedOwner != ([2,life_var_headlessClient] select life_var_hc_connected)) exitWith {};
if (_value isEqualTo -1) exitWith {};

hint format [localize "STR_ATM_WithdrawSuccessG",[_value] call life_fnc_numberText];
CASH = CASH + _value;
[] call life_fnc_atmMenu;