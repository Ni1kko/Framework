#include "\life_backend\serverDefines.hpp"
/*

    File: fn_transferOwnership.sqf
    Author: BoGuu

    Description:
    Transfer agent ownership to HC upon it's connection

*/

_which = param [0,false,[false]];

if (_which) then {

    if (count extdb_var_database_headless_clients < 1) exitWith {
        ["ERROR: Server is trying to give AI ownership to HC when HC is disconected"] call MPServer_fnc_log;
    };

    {
        if (!(isPlayer _x)) then {
            _x setOwner extdb_var_database_headless_client;  //Move agents over to HC
        };
    } forEach life_var_spawndAnimals;

} else {

    if (count extdb_var_database_headless_clients > 0) exitWith {
        [ "ERROR: Server is trying to give AI ownership to back to itself when HC is connected"] call MPServer_fnc_log; 
    };
    
    {
        if (!(isPlayer _x)) then {
            _x setOwner 2;  //Move agents over to Server
        };
    } forEach life_var_spawndAnimals;

};
