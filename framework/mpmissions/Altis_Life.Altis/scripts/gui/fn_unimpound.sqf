#include "..\..\script_macros.hpp"
/*
    File: fn_unimpound.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Yeah... Gets the vehicle from the garage.
*/
private ["_vehicle","_vehicleLife","_vid","_pid","_unit","_price","_price","_storageFee","_purchasePrice"];
disableSerialization;
if ((lbCurSel 2802) isEqualTo -1) exitWith {hint localize "STR_Global_NoSelection"};
_vehicle = lbData[2802,(lbCurSel 2802)];
_vehicle = (call compile format ["%1",_vehicle]) select 0;
_vehicleLife = _vehicle;
_vid = lbValue[2802,(lbCurSel 2802)];
_pid = getPlayerUID player;
_unit = player;
_spawntext = localize "STR_Garage_spawn_Success";
if (isNil "_vehicle") exitWith {hint localize "STR_Garage_Selection_Error"};
if (!isClass (missionConfigFile >> "cfgVehicleArsenal" >> _vehicleLife)) then {
    _vehicleLife = "Default"; //Use Default class if it doesn't exist
    diag_log format ["%1: cfgVehicleArsenal class doesn't exist",_vehicle];
};

_price = M_CONFIG(getNumber,"cfgVehicleArsenal",_vehicleLife,"price");
_storageFee = LIFE_SETTINGS(getNumber,"vehicle_storage_fee_multiplier");

switch (playerSide) do {
    case civilian: {_purchasePrice = _price * LIFE_SETTINGS(getNumber,"vehicle_purchase_multiplier_CIVILIAN");};
    case west: {_purchasePrice = _price * LIFE_SETTINGS(getNumber,"vehicle_purchase_multiplier_COP");};
    case independent: {_purchasePrice = _price * LIFE_SETTINGS(getNumber,"vehicle_purchase_multiplier_MEDIC");};
    case east: {_purchasePrice = _price * LIFE_SETTINGS(getNumber,"vehicle_purchase_multiplier_OPFOR");};
};
_price = _purchasePrice * _storageFee;

if (!(_price isEqualType 0) || _price < 1) then {_price = 500;};
if (life_var_bank < _price) exitWith {hint format [(localize "STR_Garage_CashError"),[_price] call MPClient_fnc_numberText];};

if (life_garage_sp isEqualType []) then {
    if (count extdb_var_database_headless_clients > 0) then {
        [_vid,_pid,(life_garage_sp select 0),_unit,_price,(life_garage_sp select 1),_spawntext] remoteExec ["HC_fnc_spawnVehicle",extdb_var_database_headless_client];
    } else {
        [_vid,_pid,(life_garage_sp select 0),_unit,_price,(life_garage_sp select 1),_spawntext] remoteExec ["MPServer_fnc_spawnVehicle",RSERV];
    };
} else {
    if (life_garage_sp in ["medic_spawn_1","medic_spawn_2","medic_spawn_3"]) then {
        if (count extdb_var_database_headless_clients > 0) then {
            [_vid,_pid,life_garage_sp,_unit,_price,0,_spawntext] remoteExec ["HC_fnc_spawnVehicle",extdb_var_database_headless_client];
        } else {
            [_vid,_pid,life_garage_sp,_unit,_price,0,_spawntext] remoteExec ["MPServer_fnc_spawnVehicle",RSERV];
        };
    } else {
        if (count extdb_var_database_headless_clients > 0) then {
            [_vid,_pid,(getMarkerPos life_garage_sp),_unit,_price,markerDir life_garage_sp,_spawntext] remoteExec ["HC_fnc_spawnVehicle",extdb_var_database_headless_client];
        } else {
            [_vid,_pid,(getMarkerPos life_garage_sp),_unit,_price,markerDir life_garage_sp,_spawntext] remoteExec ["MPServer_fnc_spawnVehicle",RSERV];
        };
    };
};

hint localize "STR_Garage_SpawningVeh";
["SUB","BANK",_price] call MPClient_fnc_handleMoney;
closeDialog 0;
