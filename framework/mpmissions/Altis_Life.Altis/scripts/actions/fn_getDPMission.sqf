#include "..\..\script_macros.hpp"
/*
    File: fn_getDPMission.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Selects a random DP point for a delivery mission.
    Needs to be revised.
*/
params [
    ["_target",objNull,[objNull]]
];
if (isNull _target) exitWith {};

private "_dp";
if (str(_target) in CFG_MASTER(getArray,"delivery_points")) then {
    private _point = CFG_MASTER(getArray,"delivery_points");
    _point deleteAt (_point find (str(_target)));
    _dp = selectRandom _point;
} else {
    _dp = selectRandom (CFG_MASTER(getArray,"delivery_points"));
};

life_dp_start = _target;
life_var_deliveringPackage = true;

life_dp_point = call compile format ["%1",_dp];
_dp = toUpper((_dp splitString "_") joinString " ");

life_cur_task = player createSimpleTask [format ["Delivery_%1",life_dp_point]];
life_cur_task setSimpleTaskDescription [format [localize "STR_NOTF_DPStart",_dp],"Delivery Job",""];
life_cur_task setTaskState "Assigned";
player setCurrentTask life_cur_task;

["DeliveryAssigned",[format [localize "STR_NOTF_DPTask",_dp]]] call bis_fnc_showNotification;

[] spawn {
    waitUntil {!life_var_deliveringPackage || !alive player};
    if (!alive player) then {
        life_cur_task setTaskState "Failed";
        player removeSimpleTask life_cur_task;
        ["DeliveryFailed",[localize "STR_NOTF_DPFailed"]] call BIS_fnc_showNotification;
        life_var_deliveringPackage = false;
        life_dp_point = nil;
    };
};