#include "..\..\script_macros.hpp"
/*
    File: fn_inventoryClosed.sqf
    Author: Bryan "Tonic" Boardwine
    Modified : NiiRoZz

    Description:
    1 : Used for syncing house container data but when the inventory menu
    is closed a sync request is sent off to the server.
    2 : Used for syncing vehicle inventory when save vehicle gear are activated
*/
params [
    "",
    ["_container", objNull, [objNull]]
];
if (isNull _container) exitWith {};

if ((typeOf _container) in ["Box_IND_Grenades_F", "B_supplyCrate_F"]) exitWith {
    if (count extdb_var_database_headless_clients > 0) then {
        [_container] remoteExecCall ["HC_fnc_updateHouseContainers", extdb_var_database_headless_client];
    } else {
        [_container] remoteExecCall ["MPServer_fnc_updateHouseContainers", 2];
    };

    [3] call SOCK_fnc_updatePartial;
};
 
if (_container isKindOf "Car" || {_container isKindOf "Air"} || {_container isKindOf "Ship"}) exitWith {
    if (count extdb_var_database_headless_clients > 0) then {
        [_container, 1] remoteExecCall ["HC_fnc_vehicleUpdate", extdb_var_database_headless_client];
    } else {
        [_container, 1] remoteExecCall ["MPServer_fnc_vehicleUpdate", 2];
    };

    [3] call SOCK_fnc_updatePartial;
};
