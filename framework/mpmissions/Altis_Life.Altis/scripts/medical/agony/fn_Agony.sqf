/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
	## fn_Agony.sqf
*/
params [
	["_unit",objNull,[objNull]],
	["_source",objNull,[objNull]],
	["_instigator",objNull,[objNull]],
	["_projectile","",[""]]
];

if((_unit getVariable ["lifeState","HEALTHY"]) isEqualTo "INCAPACITATED") exitWith {false};

_unit setVariable ["medicStatus",-1,true];
_unit setVariable ["lifeState","INCAPACITATED",true];

[_unit] call life_fnc_enterCombat;

[_unit] spawn MPClient_fnc_deathScreen;


true