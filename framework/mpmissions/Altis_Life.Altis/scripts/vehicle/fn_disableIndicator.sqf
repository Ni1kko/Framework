#include "..\..\clientDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

private _vehicle = param[0,objNull,[objNull]];

// Ex
if (isNull _vehicle) exitWith {false};

// Kill thread
if (!isNil "life_var_indicatorsThread") then {
	terminate life_var_indicatorsThread;
};

// Delete lightpoints
private _lights = _vehicle getVariable ["indicator_objects",[]];

if (count _lights > 0) then {
	{deleteVehicle _x} forEach _lights;
};

_vehicle setVariable ["indicator_objects", [],true];
_vehicle setVariable ["indicator_mode",nil,true];

true