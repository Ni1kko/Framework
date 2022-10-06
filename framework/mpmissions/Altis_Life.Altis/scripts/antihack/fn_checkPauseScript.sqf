#include "..\..\clientDefines.hpp"
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

private _display = uiNamespace getVariable ["RscDisplayMPInterrupt",param [0,findDisplay 49,[displayNull]]];
private _displayParent = uiNamespace getVariable ["RscDisplayMission",displayParent _display];
private _displayChild = uiNamespace getVariable ["RscDisplayGameOptions",findDisplay 151];
private _displayInventory = uiNamespace getVariable ["RscDisplayInventory",findDisplay 602];

//-- while esacpe or options are open
while {not(isNull _display) OR not(isNull _displayChild)} do 
{
	//-- Wait for options to open
	waitUntil {
		_displayChild = uiNamespace getVariable ["RscDisplayGameOptions",findDisplay 151];
		_displayInventory = uiNamespace getVariable ["RscDisplayInventory",findDisplay 602];

		if(not(isNull _displayInventory)) exitWith {
			{_x closeDisplay 2}forEach[
				_displayInventory,
				_displayChild,
				_display
			];
			true
		};

		not(isNull _displayChild)
	};

	//-- Wait for options to close
	waitUntil{
		_displayChild = uiNamespace getVariable ["RscDisplayGameOptions",findDisplay 151];
		_displayInventory = uiNamespace getVariable ["RscDisplayInventory",findDisplay 602];
	
		if(not(isNull _displayInventory)) exitWith {
			{_x closeDisplay 2}forEach[
				_displayInventory,
				_displayChild,
				_display
			];
			true
		};

		if(not(isNull _displayChild)) then {
			//Difficulty
			(_displayChild displayCtrl 304) ctrlEnable false;
			(_displayChild displayCtrl 304) ctrlSetText "Disabled";

			//Layout
			(_displayChild displayCtrl 2405) ctrlEnable false;
			(_displayChild displayCtrl 2405) ctrlSetText "AntiCheat Patch";
		};

		isNull _displayChild
	};
};

true