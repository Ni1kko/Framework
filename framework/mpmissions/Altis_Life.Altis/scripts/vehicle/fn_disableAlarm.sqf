#include "..\..\script_macros.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
    ## fn_disableAlarm.sqf
*/

FORCE_SUSPEND("MPClient_fnc_disableAlarm");

params [
	["_vehicle", objNull, [objNull]],
	["_type", "", [""]],
	["_chirp",false, [false]]
];

if(not(_type in ["lock","unlock"])) exitWith {false};

//--- Disable harazd lights
[_player, _type,_vehicle] remoteExec ["MPClient_fnc_enableIndicator",0];

//--- Disable sound
_vehicle setVariable ["AlarmState","Disarming",true];
uiSleep 0.5;

//---
if _chirp then  {[_vehicle,"car_lock_bleep",50,1] remoteExec ["MPClient_fnc_say3D",0]};

//--- Update alarm
switch _type do 
{
	case "lock": {_vehicle setVariable ["AlarmState","Armed",true]};
	case "unlock": {_vehicle setVariable ["AlarmState","Disarmed",true]};
};

true