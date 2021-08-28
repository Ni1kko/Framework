#include "..\..\script_macros.hpp"
/*
    File: fn_wantedGrab.sqf
    Author: ColinM

    Description:
    Prepare the array to query the crimes.
*/
private ["_display","_tab","_criminal"];
disableSerialization;
_display = findDisplay 2400;
_tab = _display displayCtrl 2402;
_criminal = lbData[2401,(lbCurSel 2401)];
_criminal = call compile format ["%1", _criminal];
if (isNil "_criminal") exitWith {};

if (count extdb_var_database_headless_clients > 0) then {
    [player,_criminal] remoteExec ["HC_fnc_wantedCrimes",extdb_var_database_headless_client];
} else {
    [player,_criminal] remoteExec ["life_fnc_wantedCrimes",RSERV];
};
