#include "..\..\script_macros.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
	## fn_checkPauseScript.sqf

    ## The script executes in its own namespace. 
        In order to get/set external global variable you need to explicitly use mission namespace.
*/

disableSerialization;

params [
    ["_display", displayNull, [displayNull]]
];

waitUntil{
	(isNull _display) OR not(isNull(uiNamespace getVariable ["RscDisplayGameOptions",displayNull]))
};

private _displayChild = uiNamespace getVariable ["RscDisplayGameOptions",displayNull];

while {not(isNull _display) OR not(isNull _displayChild)} do 
{
	waitUntil {
		_displayChild = uiNamespace getVariable ["RscDisplayGameOptions",displayNull];
		not(isNull _displayChild)
	};

	//Difficulty
	(_displayChild displayCtrl 304) ctrlEnable false;
	(_displayChild displayCtrl 304) ctrlSetText "Disabled";

	//Layout
	(_displayChild displayCtrl 2405) ctrlEnable false;
	(_displayChild displayCtrl 2405) ctrlSetText "AntiCheat Patch";

	waitUntil{isNull _displayChild};
};

true