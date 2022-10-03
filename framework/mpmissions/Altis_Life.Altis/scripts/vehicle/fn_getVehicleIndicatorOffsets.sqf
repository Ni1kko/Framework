#include "..\..\script_macros.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

private _class = param[0,"",[""]];
private _cfgIndicators = missionConfigFile >> "cfgVehicleIndicators" >> "Vehicles";
private _config = [
	[0,0,0],//FL
	[0,0,0],//FR
	[0,0,0],//RL
	[0,0,0] //RR
];

// Exit
if (_class == "" OR {not(isClass(_cfgIndicators >> _class))}) exitWith {
	_config
};

// Get config entries
{
	_config set [_forEachIndex, _x]; 
}forEach (getArray(missionConfigFile >> "cfgVehicleIndicators" >> "Vehicles" >> _class >> "positions"));

// Return
_config;