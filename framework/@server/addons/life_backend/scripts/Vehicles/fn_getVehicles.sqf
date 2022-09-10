#include "\life_backend\script_macros.hpp"
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
private _sideVar = [_side,true] call MPServer_fnc_util_getSideString;

//Error checks
if (_pid isEqualTo "" || _side isEqualTo sideUnknown || _type isEqualTo "" || isNull _unit) exitWith {
    if (!isNull _unit) then {
        [[]] remoteExec ["MPClient_fnc_garageMenu",(owner _unit)];
    };
};

private _queryResult = [format ["SELECT id, side, classname, type, pid, alive, active, plate, color FROM vehicles WHERE pid='%1' AND alive='1' AND active='0' AND side='%2' AND type='%3' AND impounded='0'",_pid,_sideVar,_type],2,true] call MPServer_fnc_database_rawasync_request;

if (_queryResult isEqualType "") exitWith {
    [[]] remoteExec ["MPClient_fnc_garageMenu",(owner _unit)];
};

[_queryResult] remoteExec ["MPClient_fnc_garageMenu",owner _unit];

true