#include "..\..\clientDefines.hpp"
/*
    File: fn_colorVehicle.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Reskins the vehicle.
*/
params [
    ["_vehicle",objNull,[objNull]],
    ["_index",-1,[0]]
];

private _className = typeOf _vehicle;

if (isNull _vehicle || {!alive _vehicle} || {_index isEqualTo -1}) exitWith {};
//Does the vehicle already have random styles? Halt till it's set.

if (local _vehicle) then {
    private _colorIndex = 1;
    if (_className isEqualTo "C_Offroad_01_F") then {_colorIndex = 3};
    _vehicle setVariable ["color",_colorIndex,true];
};

if (!isClass (missionConfigFile >> "cfgVehicleArsenal" >> _className)) then {
    [format ["%1: cfgVehicleArsenal class doesn't exist",_className],true,true] call MPClient_fnc_log;
    _className = "Default"; //Use Default class if it doesn't exist
};

private _textures = M_CONFIG(getArray,"cfgVehicleArsenal",_className,"textures");
if (count _textures <= _index) exitWith {};

private _texturePaths =  (_textures select _index) param [2,[]];

_vehicle setVariable ["Life_VEH_color",_index,true];

{_vehicle setObjectTextureGlobal [_forEachIndex,_x]} forEach _texturePaths;
