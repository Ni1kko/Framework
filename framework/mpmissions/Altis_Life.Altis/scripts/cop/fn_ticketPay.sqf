#include "..\..\script_macros.hpp"
/*
    File: fn_ticketPay.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Pays the ticket.
*/
if (isNil "life_ticket_val" || isNil "life_ticket_cop") exitWith {};
if (MONEY_CASH < life_ticket_val) exitWith {
    if (MONEY_BANK < life_ticket_val) exitWith {
        hint localize "STR_Cop_Ticket_NotEnough";
        [1,"STR_Cop_Ticket_NotEnoughNOTF",true,[profileName]] remoteExecCall ["MPClient_fnc_broadcast",life_ticket_cop];
        closeDialog 0;
    };

    hint format [localize "STR_Cop_Ticket_Paid",[life_ticket_val] call MPClient_fnc_numberText];
    ["ADD","BANK",life_ticket_val] call MPClient_fnc_handleMoney;
    life_ticket_paid = true;

    [0,"STR_Cop_Ticket_PaidNOTF",true,[profileName,[life_ticket_val] call MPClient_fnc_numberText]] remoteExecCall ["MPClient_fnc_broadcast",west];
    [1,"STR_Cop_Ticket_PaidNOTF_2",true,[profileName]] remoteExecCall ["MPClient_fnc_broadcast",life_ticket_cop];
    [life_ticket_val,player,life_ticket_cop] remoteExecCall ["MPClient_fnc_ticketPaid",life_ticket_cop];

    if (count extdb_var_database_headless_clients > 0) then {
        [getPlayerUID player] remoteExecCall ["HC_fnc_wantedRemove",extdb_var_database_headless_client];
    } else {
        [getPlayerUID player] remoteExecCall ["MPServer_fnc_wantedRemove",RE_SERVER];
    };
    closeDialog 0;
};

["SUB","CASH",life_ticket_val] call MPClient_fnc_handleMoney;
life_ticket_paid = true;

if (count extdb_var_database_headless_clients > 0) then {
    [getPlayerUID player] remoteExecCall ["HC_fnc_wantedRemove",extdb_var_database_headless_client];
} else {
    [getPlayerUID player] remoteExecCall ["MPServer_fnc_wantedRemove",RE_SERVER];
};

[0,"STR_Cop_Ticket_PaidNOTF",true,[profileName,[life_ticket_val] call MPClient_fnc_numberText]] remoteExecCall ["MPClient_fnc_broadcast",west];
closeDialog 0;
[1,"STR_Cop_Ticket_PaidNOTF_2",true,[profileName]] remoteExecCall ["MPClient_fnc_broadcast",life_ticket_cop];
[life_ticket_val,player,life_ticket_cop] remoteExecCall ["MPClient_fnc_ticketPaid",life_ticket_cop];