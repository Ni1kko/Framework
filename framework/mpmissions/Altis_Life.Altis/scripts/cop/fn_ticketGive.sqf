#include "..\..\clientDefines.hpp"
/*
    File: fn_ticketGive.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Gives a ticket to the targeted player.
*/
if (isNil "life_ticket_unit") exitWith {hint localize "STR_Cop_TicketNil"};
if (isNull life_ticket_unit) exitWith {hint localize "STR_Cop_TicketExist"};

private _val = ctrlText 2652;

if (!([_val] call MPServer_fnc_isNumber)) exitWith {hint localize "STR_Cop_TicketNum"};
if ((parseNumber _val) > 200000) exitWith {hint localize "STR_Cop_TicketOver100"};

[0,"STR_Cop_TicketGive",true,[profileName,[(parseNumber _val)] call MPClient_fnc_numberText,life_ticket_unit getVariable ["realname",name life_ticket_unit]]] remoteExecCall ["MPClient_fnc_broadcast",RE_CLIENT];
[player,(parseNumber _val)] remoteExec ["MPClient_fnc_ticketPrompt",life_ticket_unit];
closeDialog 0;
