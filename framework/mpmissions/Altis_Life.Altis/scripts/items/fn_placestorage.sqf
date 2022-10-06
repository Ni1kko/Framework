#include "..\..\clientDefines.hpp"
/*
    File : fn_placestorage.sqf
    Author: NiiRoZz

    Description:
    PLace container were player select with preview

*/
private ["_container","_isFloating"];

if (!life_container_active) exitWith {};
if (life_var_activeContaineObject isEqualTo objNull) exitWith {};
if (!((typeOf life_var_activeContaineObject) in ["B_supplyCrate_F","Box_IND_Grenades_F"])) exitWith {};

_container = life_var_activeContaineObject;
_isFloating = if (((getPos _container) select 2) < 0.1) then {false} else {true};
detach _container;
[_container,true] remoteExecCall ["MPClient_fnc_simDisable",RE_GLOBAL];
_container setPosATL [getPosATL _container select 0, getPosATL _container select 1, (getPosATL _container select 2) + 0.7];
_container allowDamage false;
_container enableRopeAttach false;

if ((typeOf _container) == "B_supplyCrate_F") then {
    [false,"storagebig",1] call MPClient_fnc_handleInv;
} else {
    [false,"storagesmall",1] call MPClient_fnc_handleInv;
};

[_container, _isFloating] call MPClient_fnc_placeContainer;
life_container_active = false;
life_var_activeContaineObject = objNull;
