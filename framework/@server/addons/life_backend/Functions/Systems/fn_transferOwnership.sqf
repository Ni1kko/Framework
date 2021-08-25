#include "..\..\script_macros.hpp"
/*

    File: fn_transferOwnership.sqf
    Author: BoGuu

    Description:
    Transfer agent ownership to HC upon it's connection

*/

_which = param [0,false,[false]];

if (_which) then {

    if (!life_var_hc_connected) exitWith {diag_log "ERROR: Server is trying to give AI ownership to HC when life_var_hc_connected is false";};
    {
        if (!(isPlayer _x)) then {
            _x setOwner life_var_headlessClient;  //Move agents over to HC
        };
    } forEach animals;

} else {

    if (life_var_hc_connected) exitWith {diag_log "ERROR: Server is trying to give AI ownership to back to itself when life_var_hc_connected is true";};
    {
        if (!(isPlayer _x)) then {
            _x setOwner RSERV;  //Move agents over to Server
        };
    } forEach animals;

};
