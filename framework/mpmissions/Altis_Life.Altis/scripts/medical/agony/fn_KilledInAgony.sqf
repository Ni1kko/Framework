/*

	Function: 	MPClient_fnc_KilledInAgony
	Project: 	Misty Peaks RPG
	Author:     Merrick, Nikko, Affect & IceEagle132
	
*/
params [
	["_unit",objNull,[objNull]],
	["_source",objNull,[objNull]],
	["_instigator",objNull,[objNull]],
	["_damage",0,[0]],
	["_projectile","",[""]],
	["_selection","",[""]]
];

["all"] call MPClient_fnc_removeBuff;
_unit setDamage 1;

true