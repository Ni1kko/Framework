#include "\life_backend\serverDefines.hpp"
/*
    File: fn_getVehicles.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Sends a request to query the database information and returns vehicles.
*/

private _pid = [_this,0,"",[""]] call BIS_fnc_param;
private _side = [_this,1,sideUnknown,[west]] call BIS_fnc_param;
private _type = [_this,2,"",[""]] call BIS_fnc_param;
private _unit = [_this,3,objNull,[objNull]] call BIS_fnc_param;

//Error checks
if (_pid isEqualTo "" || _side isEqualTo sideUnknown || _type isEqualTo "" || isNull _unit || remoteExecutedOwner < 3) exitWith {
    if (remoteExecutedOwner >= 3) then {
        [[]] remoteExec ["MPClient_fnc_garageMenu",remoteExecutedOwner];
    };
};

private _ownedVehicles = [_unit, _type] call MPServer_fnc_fetchVehicleDataRequest;

[_ownedVehicles] remoteExec ["MPClient_fnc_garageMenu",remoteExecutedOwner];

true