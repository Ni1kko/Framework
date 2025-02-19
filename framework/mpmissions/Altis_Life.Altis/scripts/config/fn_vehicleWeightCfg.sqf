#include "..\..\clientDefines.hpp"
/*
    File: fn_vehicleWeightCfg.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Master configuration for vehicle weight.
*/
private ["_className","_classNameLife","_weight"];
_className = [_this,0,"",[""]] call BIS_fnc_param;
_classNameLife = _className;
if (!isClass (missionConfigFile >> "cfgVehicleArsenal" >> _classNameLife)) then {
    _classNameLife = "Default"; //Use Default class if it doesn't exist
    [format ["%1: cfgVehicleArsenal class doesn't exist",_className],true,true] call MPClient_fnc_log;
};
_weight = M_CONFIG(getNumber,"cfgVehicleArsenal",_classNameLife,"vItemSpace");

if (isNil "_weight") then {_weight = -1;};
_weight;