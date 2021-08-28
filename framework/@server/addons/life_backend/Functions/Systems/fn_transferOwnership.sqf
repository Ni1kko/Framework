#include "..\..\script_macros.hpp"
/*

    File: fn_transferOwnership.sqf
    Author: BoGuu

    Description:
    Transfer agent ownership to HC upon it's connection

*/

_which = param [0,false,[false]];

if (_which) then {

    if (count extdb_var_database_headless_clients < 1) exitWith {diag_log "ERROR: Server is trying to give AI ownership to HC when HC is disconected";};
    {
        if (!(isPlayer _x)) then {
            _x setOwner extdb_var_database_headless_client;  //Move agents over to HC
        };
    } forEach animals;

} else {

    if (count extdb_var_database_headless_clients > 0) exitWith {diag_log "ERROR: Server is trying to give AI ownership to back to itself when HC is connected";};
    {
        if (!(isPlayer _x)) then {
            _x setOwner 2;  //Move agents over to Server
        };
    } forEach animals;

};
