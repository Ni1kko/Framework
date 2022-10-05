#include "..\..\script_macros.hpp"
/*
    File: fn_vehicleGarage.sqf
    Author: Bryan "Tonic" Boardwine
    Updated to Housing/Garage Configs - BoGuu

    Description:
    Vehicle Garage, why did I spawn this in an action its self?
*/
params [
    ["_building",objNull,[objNull]],
    ["_vehicleType","",[""]]
];

disableSerialization;

if(not((toUpper _vehicleType) in ["CAR","AIR","SHIP"])) exitWith {
    diag_log format ["Invalid Vehicle Type: %2 | Trader GridPos: %1",mapGridPosition _building,_vehicleType];
    false
};

private _className = typeOf _building;
private _config = [missionConfigFile >> "cfgHouses" >> worldName >> _className, missionConfigFile >> "cfgGarages" >> worldName >> _className] select {isClass _x};

if (count _config isEqualTo 0) exitWith {
    diag_log format ["Garage Config Not Found For Classname: %2 | Trader GridPos: %1",mapGridPosition _building,_className];
    false
};

_config = _config#0;
private _dir = getNumber(_config >> "garageSpawnDir");
private _mTwPos = getArray(_config >> "garageSpawnPos");
private _sp = [(_building modelToWorld _mTwPos),((getDir _building) + _dir)];

private _display = [objNull, nil, nil, [_vehicleType,_sp]] call MPClient_fnc_vehicleGarageOpen;

true
