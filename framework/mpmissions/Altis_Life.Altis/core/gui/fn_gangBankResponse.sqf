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
if (remoteExecutedOwner != ([2,extdb_var_database_headless_client] select (count extdb_var_database_headless_clients > 0))) exitWith {};
if (_value isEqualTo -1) exitWith {};

hint format [localize "STR_ATM_WithdrawSuccessG",[_value] call MPClient_fnc_numberText];
life_var_cash = life_var_cash + _value;
[] call MPClient_fnc_atmMenu;