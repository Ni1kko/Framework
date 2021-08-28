#include "..\..\script_macros.hpp"
/*
    File: fn_robPerson.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Robs a person.
*/
params [
    ["_robber",objNull,[objNull]]
];
if (isNull _robber) exitWith {}; //No one to return it to?

if (life_var_cash > 0) then {
    [life_var_cash,player,_robber] remoteExecCall ["life_fnc_robReceive",_robber];

    if (count extdb_var_database_headless_clients > 0) then {
        [getPlayerUID _robber,_robber getVariable ["realname",name _robber],"211"] remoteExecCall ["HC_fnc_wantedAdd",extdb_var_database_headless_client];
    } else {
        [getPlayerUID _robber,_robber getVariable ["realname",name _robber],"211"] remoteExecCall ["life_fnc_wantedAdd",RSERV];
    };

    [1,"STR_NOTF_Robbed",true,[_robber getVariable ["realname",name _robber],profileName,[life_var_cash] call life_fnc_numberText]] remoteExecCall ["life_fnc_broadcast",RCLIENT];
    life_var_cash = 0;
    [0] call SOCK_fnc_updatePartial;
} else {
    [2,"STR_NOTF_RobFail",true,[profileName]] remoteExecCall ["life_fnc_broadcast",_robber];
};
