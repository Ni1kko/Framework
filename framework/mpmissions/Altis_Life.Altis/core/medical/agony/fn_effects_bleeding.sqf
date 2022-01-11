/*

	Function: 	life_fnc_effects_bleeding
	Project: 	Misty Peaks RPG
	Author:     Merrick, Nikko, Affect & IceEagle132
	
*/
if(missionNamespace getVariable ["life_fnc_effects_bleeding_active",false]) exitWith{};

life_fnc_effects_bleeding_active = true;

while {life_var_bleeding && alive(player)} do {
	if (damage player < 0.89) then {
		player setDamage (damage player + 0.05);
	} else {
		// send to agony
		[player,player] call life_fnc_Agony;
	};
	player setBleedingRemaining 10;
	addcamShake[1, 2, 10];
	titleText["Your bleeding ...","PLAIN"];
	[5000] call BIS_fnc_bloodEffect;				
	uiSleep 60;
};

life_fnc_effects_bleeding_active = false;