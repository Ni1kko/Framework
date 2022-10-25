/*

	Function: 	MPClient_fnc_painShock
	Project: 	AsYetUntitled
	Author:     Merrick, Nikko, Affect & IceEagle132
	
*/
params [
	["_section","",[""]],
	["_time",0,[0]]
];

if(life_var_painShockRunning) exitWith{false};
life_var_painShockRunning = true;

while {life_var_painShock && alive(player)} do {
	sleep 60;
	if (life_var_painShock && alive(player)) then {
		player enableFatigue true;
		player setFatigue (getFatigue player + 0.1);
		addcamShake[3, 2, 10];
		systemChat "You have a pain shock ...";
	};
};

if (getNumber(missionConfigFile >> "cfgMaster" >> "enable_fatigue") isEqualTo 0) then {player enableFatigue false};

life_var_painShockRunning = false;

true