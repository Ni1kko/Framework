#include "..\..\clientDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
    ## fn_endTimer.sqf
*/

params[
	["_timerName","undefined",[""]],
	["_timerNamespace",missionNamespace,[objnull, missionNamespace]]
];

if(_timerName isEqualTo "undefined") exitWith {false};

private _timerData = [_timerName,diag_tickTime - 1];

if _timerPublic then {
	_timerData resize 3;
	_timerData set [2, true];
};

_timerNamespace setVariable _timerData;

true