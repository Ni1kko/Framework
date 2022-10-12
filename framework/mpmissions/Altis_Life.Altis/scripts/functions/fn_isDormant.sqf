#include "..\..\clientDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
    ## fn_isDormant.sqf

	cause this is called in escInterupt
		you must use namespace you desire as stupid shit executes in its own namespace
			update i found a way to make it less gay... with missionNamespace try {
*/

private _isDormant = true;

with missionNamespace try {
	with missionNamespace do 
	{
		if not(life_var_sessionDone) throw false;
		if (life_var_unconscious) throw false;
		if (life_var_tazed) throw false;
		if (player call life_fnc_inCombat) throw false;
	};
	
	{
		if (player getVariable ["arrested",false]) throw false;
	}forEach [
		"arrested",
		"transporting",
		"playerSurrender",
		"Escorting",
		"restrained"
	];

	if ((player getVariable ["lifeState",""]) isNotEqualTo "HEALTHY") throw false;
} catch {
	_isDormant = _exception;
};

_isDormant