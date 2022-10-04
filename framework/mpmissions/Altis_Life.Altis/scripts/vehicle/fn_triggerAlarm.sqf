#include "..\..\script_macros.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
    ## fn_triggerAlarm.sqf
*/

params [
	["_vehicle", objNull, [objNull]]
]; 

// Check if the vehicle is already has acrive alarm
if((_vehicle getVariable ["AlarmState","Disarmed"]) isEqualTo "Active")exitWith{false};

//---
_vehicle setVariable ["AlarmState","Active",true];

//--- Enable harazd lights
[_player, "alarm",_vehicle] remoteExec ["MPClient_fnc_enableIndicator",0];

//--- Play alarm sound
[_vehicle]spawn{
	params [
		["_vehicle", objNull]
	];
	
	private _soundClass = "car_alarm";
	private _soundLength = 0.565;
	private _soundDistance = 250;

	while {not(isNull _vehicle) AND {alive _vehicle AND {(_vehicle getVariable ["AlarmState","Disarmed"]) isEqualTo "Active"}}} do 
	{
		[_vehicle,_soundClass,_soundDistance,1,_soundLength] remoteExec ["MPClient_fnc_say3D",0];
		uiSleep _soundLength;
	};

	if(not(isNull _vehicle) AND {alive _vehicle AND {(_vehicle getVariable ["AlarmState","Active"]) isNotEqualTo "Disarmed"}})then
	{
		[_vehicle, "lock", true] call MPClient_fnc_disableAlarm;
	};
	
	true
};
