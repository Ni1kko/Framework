#include "\life_backend\script_macros.hpp"
/*
    File: fn_vehicleCreate.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Answers the query request to create the vehicle in the database.
*/
private _uid = [_this,0,"",[""]] call BIS_fnc_param;
private _side = [_this,1,sideUnknown,[west]] call BIS_fnc_param;
private _vehicle = [_this,2,objNull,[objNull]] call BIS_fnc_param;
private _color = [_this,3,-1,[0]] call BIS_fnc_param;
private _className = typeOf _vehicle;
private _sideVar = [_side,true] call MPServer_fnc_util_getSideString;
private _type = [_vehicle] call  MPServer_fnc_util_getTypeString;

//Error checks
if (_uid isEqualTo "" || _side isEqualTo sideUnknown || isNull _vehicle || _type isEqualTo "Bad") exitWith {};
if !(isClass (missionConfigFile >> "cfgVehicleArsenal" >> _className)) exitWith {};
if !(_type in ["Air","Ship","Car"]) exitWith {};
if !(alive _vehicle) exitWith {};

private _VIN = [_sideVar,_type] call MPServer_fnc_vehicle_generateVIN;
private _plate = round(random(1000000));//To be replace with above function

[_uid,_sideVar,_type,_classname,_color,_plate] call MPServer_fnc_insertVehicleDataRequest;
_vehicle setVariable ["oUUID",_uid,true];
_vehicle setVariable ["dbInfo",[_uid,_plate],true];