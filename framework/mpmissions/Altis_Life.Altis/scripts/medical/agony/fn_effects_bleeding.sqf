/*

	Function: 	MPClient_fnc_effects_bleeding
	Project: 	Misty Peaks RPG
	Author:     Merrick, Nikko, Affect & IceEagle132
	
*/
if(missionNamespace getVariable ["MPClient_fnc_effects_bleeding_active",false]) exitWith{};

MPClient_fnc_effects_bleeding_active = true;

while {life_var_bleeding && alive(player)} do {
	if (damage player < 0.89) then {
		player setDamage (damage player + (random[0.05, 0.07, 0.1]));
	} else {
		// send to agony
		[player,player] call MPClient_fnc_Agony;
	};
	player setBleedingRemaining 10;
	addcamShake[1, 2, 10];
	titleText["Your bleeding ...","PLAIN"];
	[5000] call BIS_fnc_bloodEffect;				
	uiSleep 60;
};

MPClient_fnc_effects_bleeding_active = false;