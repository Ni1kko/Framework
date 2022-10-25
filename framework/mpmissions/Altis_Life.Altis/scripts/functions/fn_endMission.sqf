#include "..\..\clientDefines.hpp"
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

private _CfgDebriefing = missionConfigFile >> "CfgDebriefing";

//-- Handle undefined ending
if(not(isClass(configFile >> "CfgDebriefing" >> _ending)) AND not(isClass(_CfgDebriefing >> _ending)))then{
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
		if not(life_var_loadingScreenActive) then{
			startLoadingScreen ["","RscDisplayLoadingScreen"]; 
			waitUntil{life_var_loadingScreenActive};
		};
		playSound "byebye";
	};
	case "antihack":
	{
		if(count _title isEqualTo 0)then{_title = "Antihack Kicked"};
		if(count _text isEqualTo 0)then{_text = "Antihack has flagged you for cheating. You have been kicked from the server."};
		if not(life_var_loadingScreenActive) then{
			startLoadingScreen ["","RscDisplayLoadingScreen"]; 
			waitUntil{life_var_loadingScreenActive};
		};
		playSound "flashbang";
	};
};

//-- Handle undefined title and text
if(count _title isEqualTo 0)then{_title = getText(_CfgDebriefing >> _ending >> "title")};
if(count _text isEqualTo 0)then{_text = getText(_CfgDebriefing >> _ending >> "description")};

//-- Handle String table
if(isLocalized _title)then{_title = _title call BIS_fnc_localize};
if(isLocalized _text)then{_text = _text call BIS_fnc_localize};

//-- Update loading screen if active
if(life_var_loadingScreenActive)then{
    [_title,_text,_color] call MPClient_fnc_setLoadingText;
    sleep 5;
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

private _failEndings = ["error","genericerror","clienterror","servererror","fail"];

//-- End mission
if((toLower _ending in _failEndings))then{
	failMission _ending;
}else{
	endMission _ending;
};

//-- Don't run effect on ah end
_failEndings pushBackUnique "antihack";

//-- End with effects
[_ending,not(toLower _ending in _failEndings),false] call BIS_fnc_endMission;

waitUntil {count missionEnd >= 1};
[format["Mission ended with ending: %1",_ending],true,true] call MPClient_fnc_log;

missionEnd params [
	["_endType",""],
	["_failMission",false],
	["_isFailed",false]
];

//-- Allow input
disableUserInput false;

//-- 
if (_failMission OR _isFailed) then {
	forceEnd;
};

//-- 
activateKey format ["BIS_%1.%2_done", missionName, worldName];

true