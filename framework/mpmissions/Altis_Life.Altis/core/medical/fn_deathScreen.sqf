/*

	Function: 	life_fnc_deathScreen
	Project: 	Misty Peaks RPG
	Author:     Tonic, Merrick, Nikko, Affect & IceEagle132
	Github:		https://github.com/AsYetUntitled/Framework
	
*/

disableSerialization;

private _entity = param [0,objNull,[objNull]];
private _exit = param [1,false];

life_var_medicstatus = -1;
life_var_medicstatusby = "";


if(_exit)then{
	["RscDisplayDeathScreen"] call life_fnc_destroyRscLayer;
};

//-- register our layer
["RscDisplayDeathScreen","PLAIN"] call life_fnc_createRscLayer;


//-- get our layers controls
private _display = uiNamespace getVariable ["RscDisplayDeathScreen",displayNull];
private _txtTopLeft = _display displayCtrl 66601;
private _txtTopRight = _display displayCtrl 66602;
private _txtBottomLeft = _display displayCtrl 66603;
private _txtBottomRight = _display displayCtrl 66604;

//-- register our input handler for the layer
private _inputEH = (findDisplay 46) displayAddEventHandler ["KeyDown", "_this call life_fnc_deathScreenKeyHandler"];
uiNamespace setVariable ["Death_Screen_Inputhandler",_inputEH];

//-- switch too third person
_entity switchCamera "INTERNAL";

//-- hide chat
showChat false;

//-- blood effect
LIFE_PPE_DEATH_BLOOD = ppEffectCreate ["colorCorrections", 2009];
LIFE_PPE_DEATH_BLOOD ppEffectEnable true;
LIFE_PPE_DEATH_BLOOD ppEffectAdjust [1, 1.04, -0.004, [0.5, 0.5, 0.5, 0.0], [0.5, 0.5, 0.5, 0.0],  [0.5, 0.5, 0.5, 0.0]]; 
LIFE_PPE_DEATH_BLOOD ppEffectCommit 5;

//-- drowsy effect
"dynamicBlur" ppEffectEnable true;
"dynamicBlur" ppEffectAdjust [3];
"dynamicBlur" ppEffectCommit 2;

//-- start bleedout timer
_txtBottomLeft spawn {
	disableSerialization;
	private _maxTime = time + (([missionConfigFile >> "life_timers", "bleedout", 0]  call BIS_fnc_returnConfigEntry) * 60);
	life_deathScreen_canRespawn = false;
	waitUntil {		
		_this ctrlSetStructuredText parseText format ["<t size='1.15' align='center' valign='middle'><br/>You Will Bleedout in <t color='#f30404'>%1</t> seconds</t>", [(_maxTime - time),"MM:SS.MS"] call BIS_fnc_secondsToString];
		(_maxTime - time) <= 0 OR (isNull (uiNamespace getVariable ["RscDisplayDeathScreen",displayNull]))
	};
	life_deathScreen_canRespawn = true;
	_this ctrlSetStructuredText parseText format ["<t size='1.15' align='center' valign='middle'><br/>Click <t color='#f30404'>R</t> too respawn...</t>"];
};

//-- Request medic
waitUntil {
	_entity setBleedingRemaining 3;
	
	private _statusText = switch(life_var_medicstatus) do {
		case -1: {format["Click <t color='#ffd200'>M</t> to call a doctor"]};
		case 0: {format["<t color='#ffd200'>Waiting</t>"]};
		case 1: {format["<t color='#f30404'>Denied</t>"]};
		case 2: {format["<t color='#65d315'>%1 accepted your call</t>",life_var_medicstatusby]};
		case 3: {format["Red zone - <t color='#f30404'>Denied</t>"]};
		case 4: {format["Wanted - <t color='#f30404'>Denied</t>>"]};
	};
	private _medicsOnlineTxt = format[localize "STR_Medic_Online",playersNumber east];
	_txtBottomRight ctrlSetStructuredText parseText format ["<t size='0.8' align='center' valign='middle'>%1<br/><br/><br/>%2</t>",_medicsOnlineTxt,_statusText];
	uiSleep 3;
	isNull (uiNamespace getVariable ["RscDisplayDeathScreen",displayNull])
};

//-- show chat
showChat true;

//remove input handler
(findDisplay 46) displayRemoveEventHandler ["KeyDown", _inputEH];

//-- stop buff effects
["all"] call life_fnc_removeBuff;

//-- remove blood effect
LIFE_PPE_DEATH_BLOOD ppEffectAdjust [1, 1, 0,[ 0, 0, 0, 0],[ 1, 1, 1, 1],[ 0, 0, 0, 0]];
LIFE_PPE_DEATH_BLOOD ppEffectCommit 5;
LIFE_PPE_DEATH_BLOOD = -1;

//-- remove drowsy effect
"dynamicBlur" ppEffectAdjust [0];
"dynamicBlur" ppEffectCommit 2;
"dynamicBlur" ppEffectEnable false;

//-- stop any bleeding
_entity setBleedingRemaining 0;