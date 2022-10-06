#include "..\..\..\clientDefines.hpp"
/*

	Function: 	MPClient_fnc_effects_bleeding
	Project: 	AsYetUntitled
	Author:     Merrick, Nikko, Affect & IceEagle132
	
*/

if(life_var_bleedingRunning) exitWith{false};
life_var_bleedingRunning = true;

while {life_var_bleeding && alive(player)} do {
	if (damage player <= 0.79) then {
		player setDamage (damage player + (random[0.05, 0.07, 0.1]));
	} else {
		// send to agony
		[player,player] call MPClient_fnc_Agony;
	};
	player setBleedingRemaining INFINTE;
	addcamShake[1, 2, 10];
	titleText["Your bleeding ...","PLAIN"]; 
	private _remainingHealth = ((1 - damage player)  * 100);
	private _timeout = (_remainingHealth max 1) min 60;
	private _time = diag_tickTime;
	if(_remainingHealth < 25)then{
		waitUntil {
			uiSleep 5;
			[INFINTE] call BIS_fnc_bloodEffect;
			diag_tickTime > (_time + _timeout)
		};
	}else{
		[INFINTE] call BIS_fnc_bloodEffect;
		uiSleep _timeout;	
	};
};

player setBleedingRemaining -1;
life_var_bleedingRunning = false;

true