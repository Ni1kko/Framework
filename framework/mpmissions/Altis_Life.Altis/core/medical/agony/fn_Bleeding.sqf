/*

	Function: 	life_fnc_Bleeding
	Project: 	Misty Peaks RPG
	Author:     Tonic, Merrick, Nikko, Affect & IceEagle132
	
*/
while {life_var_pain_shock && alive(player)} do {
	uiSleep 60;
	if (life_var_pain_shock && alive(player)) then {
		player setFatigue (getFatigue player + 0.1);
		addcamShake[3, 2, 10];
		systemChat "You have a pain shock ...";
	};
};