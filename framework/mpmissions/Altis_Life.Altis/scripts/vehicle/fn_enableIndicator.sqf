#include "..\..\clientDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

private _caller = param[0,objNull,[objNull]];
private _type = toLower( param[1,"",[""]]);
private _vehicle = param[2,vehicle _caller,[objNull]];
private _lastType = _vehicle getVariable ["indicator_mode",""];
private _flashLimit = 0; 
private _lights = [];

// Ex
if (isNull _caller OR _type == "") exitWith {false}; 
if (_vehicle isEqualTo _caller) exitWith {false};
if (diag_tickTime - life_var_indicatorLasttick < 1 AND _type isNotEqualTo "lock") exitWith {false};
life_var_indicatorLasttick = diag_tickTime;

//-- Acive alarm, exit
if (_lastType isEqualTo "alarm" AND _type in ["lock","unlock"]) exitWith {
	false
};

// Check if the wanted indicator status is the same as the running one, if yes just turn the indicators off
if (_type isEqualTo _lastType) exitWith {
	[_vehicle] call MPClient_fnc_disableIndicator; 
	true
};

// Disable indicators first before setting up a new one
[_vehicle] call MPClient_fnc_disableIndicator;


// Get vehicle offsets
private _offsets = [typeOf _vehicle] call MPClient_fnc_getVehicleIndicatorOffsets;

// Expception
if (true in (_offsets apply {_x isEqualTo [0,0,0]})) exitWith {false};

_offsets params [
	["_frontLeftOffset",[0,0,0]],
	["_frontRightOffset",[0,0,0]],
	["_rearLeftOffset",[0,0,0]],
	["_rearRightOffset",[0,0,0]]
];

// Give vehicle var
_vehicle setVariable ["indicator_mode",_type,true];

switch (true) do 
{
	case (_type in ["lock","unlock","alarm"]):  
	{
		switch _type do 
		{
			case "lock": {_flashLimit = 1};
			case "unlock":{_flashLimit = 2};
			case "alarm":{_flashLimit = 250};
		};
		_type = "hazards";
	};
	case (_type in ["left","right"]):  
	{
		switch _type do {
			case "left":  {_offsets = [_frontLeftOffset,_rearLeftOffset]};
			case "right": {_offsets = [_frontRightOffset,_rearRightOffset]};
		};
	};
};

//-- Create indicator(s)
{	
	private _light = "#lightpoint" createVehicleLocal [1,1,1];
	_light setLightColor [0.9,0.41,0];
	_light setLightBrightness 2;
	_light setLightAmbient [0.9,0.41,0];
	_light setLightIntensity 10;
	_light setLightFlareSize 0.38;
	_light setLightFlareMaxDistance 150;
	_light setLightUseFlare true;
	_light setLightDayLight true;
	_light lightAttachObject [_vehicle, _x];
	_lights pushBack _light;
}forEach _offsets;

_vehicle setVariable ["indicator_objects", _lights, true];

{_x setLightBrightness ([2, 10] select (sunOrMoon > 0.75))} forEach _lights;
{_x setLightAttenuation [0.181, 0, 1000, 250]} forEach _lights;

private _cfgVehicleIndicators = missionConfigFile >> "cfgVehicleIndicators";
private _cfgVehicleIndicator = _cfgVehicleIndicators >> "Vehicles" >> typeOf _vehicle;
private _blinkInterval = getNumber(_cfgVehicleIndicators >> "IndicatorDefault" >> "blinkInterval");

if(isClass(_cfgVehicleIndicator))then{
	private _vehBlinkInterval = getNumber(_cfgVehicleIndicator  >> "blinkInterval"); 
	if(_vehBlinkInterval > 0)then{
		_blinkInterval = _vehBlinkInterval;
	};
};

// Script to power lights
life_var_typeicatorsThread = [_vehicle, _lights, _blinkInterval,_flashLimit] spawn {
	params ["_vehicle", "_lights", "_interval","_flashLimit"];

	private _flashIndex = 0;
	private _loop = true;
	while {_loop AND {!isNull _vehicle AND {alive _vehicle}}} do 
	{
		if _loop then 
		{
			if (_flashIndex isNotEqualTo 0 AND {_flashLimit > 0 AND {_flashIndex isEqualTo _flashLimit}}) exitWith {
				[_vehicle] call MPClient_fnc_disableIndicator;
				_loop = false;
			};

			sleep _interval;
			{_x setLightBrightness 0} forEach _lights;
			sleep _interval;
			{_x setLightBrightness ([2, 10] select (sunOrMoon > 0.75))} forEach _lights;
			
			_flashIndex = _flashIndex + 1;
		};
	};

	// Vehicle destroyed, delete indicators
	{deleteVehicle _x} forEach _lights;

	true
};

true