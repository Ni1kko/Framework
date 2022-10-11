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
	if not(life_var_sessionDone) throw false;
	if (life_var_unconscious) throw false;
	if (life_var_tazed) throw false;
	//if (player call life_fnc_inCombat) throw false;
	if (player getVariable ["arrested",false]) throw false;
	if (player getVariable ["transporting",false]) throw false;
	if (player getVariable ["playerSurrender",false]) throw false;
	if (player getVariable ["Escorting",false]) throw false;
	if (player getVariable ["restrained",false]) throw false;
	if ((player getVariable ["lifeState",""]) isNotEqualTo "HEALTHY") throw false;
} catch {
	_isDormant = _exception;
};

_isDormant