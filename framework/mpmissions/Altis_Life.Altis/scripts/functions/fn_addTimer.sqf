#include "..\..\clientDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
    ## fn_endTimer.sqf
*/
params[
	["_timerName","undefined",[""]],
	["_timer",1,[0]],
	["_timerNamespace",missionNamespace,[objnull, missionNamespace]],
	["_timerPublic",false,[false]]
];

if(_timerName isEqualTo "undefined" OR _timer < 1) exitWith {false};

private _timerData = [_timerName,diag_tickTime + _timer];

if _timerPublic then {
	_timerData resize 3;
	_timerData set [2, true];
};

_timerNamespace setVariable _timerData;

true