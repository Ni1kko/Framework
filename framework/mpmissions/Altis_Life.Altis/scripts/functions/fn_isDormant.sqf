#include "..\..\clientDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
    ## fn_isDormant.sqf
*/

private _isDormant = true;

try {
	if not(missionNamespace getVariable ["life_var_sessionDone",false]) throw false;
	if (missionNamespace getVariable ["life_var_unconscious",false]) throw false;
	if (missionNamespace getVariable ["life_var_tazed",false]) throw false;
	if (player getVariable ["arrested",false]) throw false;
	if (player getVariable ["transporting",false]) throw false;
	if (player getVariable ["playerSurrender",false]) throw false;
	if (player getVariable ["Escorting",false]) throw false;
	if (player getVariable ["restrained",false]) throw false;
	if ((player getVariable ["lifeState",""]) isNotEqualTo "HEALTHY") throw false;
	if not(player call life_fnc_inCombat) throw false;
} catch {
	_isDormant = _exception;
};

_isDormant