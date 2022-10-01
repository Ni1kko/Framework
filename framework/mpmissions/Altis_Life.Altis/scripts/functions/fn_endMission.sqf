#include "..\..\script_macros.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

FORCE_SUSPEND("MPClient_fnc_endMission");

params [
	["_title",""],
	["_text",""],
	["_ending","END1"],
	["_color","red"]
];

//-- Disallow input
disableUserInput true;

//-- Handle undefined ending
if(not(isClass(configFile >> "CfgDebriefing" >> _ending)) AND not(isClass(missionConfigFile >> "CfgDebriefing" >> _ending)))then{
	[format["CfgDebriefing >> %1 is undefined",_ending],true,true] call MPClient_fnc_log;
	_ending = "END1";
};

//-- Handle defined endings
switch (toLower _ending) do
{
	case "logoff":
	{
		if(count _title isEqualTo 0)then{_title = "STR_EndMission_Logoff_Title"};
		if(count _text isEqualTo 0)then{_text = "STR_EndMission_Logoff_Desc"};
		if(not(life_var_loadingScreenActive))then{
			startLoadingScreen ["","RscDisplayLoadingScreen"]; 
			waitUntil{life_var_loadingScreenActive AND (call BIS_fnc_isLoading)};
		};
		playSound "byebye";
	};
};

//-- Handle String table
if(isLocalized _title)then{_title = _title call BIS_fnc_localize};
if(isLocalized _text)then{_text = _text call BIS_fnc_localize};

//-- Update loading screen if active
if(life_var_loadingScreenActive)then{
    [_title,_text,_color] call MPClient_fnc_setLoadingText;
    uiSleep 5;
	endLoadingScreen;
};

//-- Log event
if(count _title isEqualTo 0)then{
	[_title,true,true] call MPClient_fnc_log;
};

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