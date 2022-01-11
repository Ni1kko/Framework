/*

	Function: 	life_fnc_painShock
	Project: 	Misty Peaks RPG
	Author:     Tonic, Merrick, Nikko, Affect & IceEagle132
	
*/

if(missionNamespace getVariable ["life_fnc_painShock_active",false]) exitWith{};

life_fnc_painShock_active = true;

while {life_var_pain_shock && alive(player)} do {
	uiSleep 60;
	if (life_var_pain_shock && alive(player)) then {
		player setFatigue (getFatigue player + 0.1);
		addcamShake[3, 2, 10];
		systemChat "You have a pain shock ...";
	};
};

life_fnc_painShock_active = false;