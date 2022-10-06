#include "..\..\clientDefines.hpp"
/*
    File: fn_gangCreated.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Tells the player that the gang is created and throws him into it.
*/
private "_group";
life_action_gangInUse = nil;

if (MONEY_BANK < (CFG_MASTER(getNumber,"gang_price"))) exitWith {
    hint format [localize "STR_GNOTF_NotEnoughMoney",[((CFG_MASTER(getNumber,"gang_price"))-MONEY_BANK)] call MPClient_fnc_numberText];
    {group player setVariable [_x,nil,true];} forEach ["gang_id","gang_owner","gang_name","gang_members","gang_maxmembers",GET_GANG_MONEY_VAR];
};

["SUB","BANK",CFG_MASTER(getNumber,"gang_price")] call MPClient_fnc_handleMoney;

hint format [localize "STR_GNOTF_CreateSuccess",(group player) getVariable "gang_name",[(CFG_MASTER(getNumber,"gang_price"))] call MPClient_fnc_numberText];