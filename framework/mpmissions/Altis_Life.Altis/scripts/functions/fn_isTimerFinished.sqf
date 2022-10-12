#include "..\..\clientDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
    ## fn_isTimerFinished.sqf
*/

params[
	["_timerName", "undefined",[""]],
	["_timerNamespace", missionNamespace,[objnull, missionNamespace]]
];

if(_timerName isEqualTo "undefined") exitWith {true};

diag_tickTime >= (_timerNamespace getVariable[_timerName,diag_tickTime])