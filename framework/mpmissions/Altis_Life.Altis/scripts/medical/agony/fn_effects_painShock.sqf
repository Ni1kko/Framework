/*

	Function: 	MPClient_fnc_painShock
	Project: 	Misty Peaks RPG
	Author:     Merrick, Nikko, Affect & IceEagle132
	
*/

if(life_var_painShockRunning) exitWith{false};
life_var_painShockRunning = true;

while {life_var_painShock && alive(player)} do {
	uiSleep 60;
	if (life_var_painShock && alive(player)) then {
		player enableFatigue true;
		player setFatigue (getFatigue player + 0.1);
		addcamShake[3, 2, 10];
		systemChat "You have a pain shock ...";
	};
};

if (getNumber(missionConfigFile >> "Life_Settings" >> "enable_fatigue") isEqualTo 0) then {player enableFatigue false};

life_var_painShockRunning = false;

true