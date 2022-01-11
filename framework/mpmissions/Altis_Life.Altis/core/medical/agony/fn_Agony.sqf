/*

	Function: 	life_fnc_Agony
	Project: 	Misty Peaks RPG
	Author:     Merrick, Nikko, Affect & IceEagle132
	
*/
params [
	["_unit",objNull,[objNull]],
	["_source",objNull,[objNull]],
	["_instigator",objNull,[objNull]],
	["_projectile","",[""]]
];
_unit setVariable ["medicStatus",-1,true];
_unit setVariable ["lifeState","INCAPACITATED",true];
[_unit] spawn life_fnc_deathScreen;