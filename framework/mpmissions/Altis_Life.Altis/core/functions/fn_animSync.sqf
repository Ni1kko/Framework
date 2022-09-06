/*

	Function: 	MPClient_fnc_animSync
	Project: 	Misty Peaks RPG
	Author:     Tonic, Merrick, Nikko, Affect & IceEagle132
	Github:		https://github.com/AsYetUntitled/Framework
	
*/

params [
	["_unit",objNull,[objnull]],
	["_anim","",[""]],
	["_isSwitchMove",true],
	["_isPlayMove",true]
];

if (isNull _unit) exitWith {};

if (_isSwitchMove) then {_unit switchMove _anim};
if (_isPlayMove) then {_unit playMove _anim};