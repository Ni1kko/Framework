#include "..\..\script_macros.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

params [
	["_title",""],
	["_text",""],
	["_ending","END1"]
];

//-- Disallow input
disableUserInput true;

//-- Update loading screen if active
if(life_var_loadingScreenActive)then{
    [_title,_text] call MPClient_fnc_setLoadingText;
    uiSleep 5;
	endLoadingScreen;
};

//-- Log event
[_title,true,true] call MPClient_fnc_log;

//-- Kick out of vehicle
if(vehicle player isNotEqualTo player)then{
	player moveOut _vehicle;
};

//-- Throw them in sky 
player setPosATL [INFINTE,INFINTE,INFINTE];

//-- End mission
[_ending,false,true] call BIS_fnc_endMission;

//-- Allow input
disableUserInput false;

true