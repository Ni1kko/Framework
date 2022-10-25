#include "..\..\..\clientDefines.hpp"
/*

	Function: 	MPClient_fnc_effects_bleeding
	Project: 	AsYetUntitled
	Author:     Merrick, Nikko, Affect & IceEagle132
	
*/
params [
	["_section","",[""]],
	["_time",0,[0]]
];

if(life_var_bleeding) exitWith{false};
life_var_bleeding = true;

private _loopConditions = {((alive player) AND life_var_bleeding)};

while {call _loopConditions} do 
{
	//-- Make them bleed
	player setBleedingRemaining INFINTE;
	player setDamage (damage player + (random[0.05, 0.07, 0.1]));

	//-- send to agony
	if (damage player >= 0.79) exitWith {
		[player,player] call MPClient_fnc_Agony;
		waitUntil {not(call _loopConditions)};
		player setBleedingRemaining -1;
		systemChat "You bledout ...";
	};

	titleText["Your bleeding ...","PLAIN"];

	private _remainingHealth = ((1 - damage player)  * 100);
	if(_remainingHealth < 25)then{
		private _timeStamp = diag_tickTime + _time;
		waitUntil {
			if(round diag_tickTime mod 15 isEqualTo 0)then{
				addcamShake[1, 2, 10];
				[INFINTE] call BIS_fnc_bloodEffect;
			};
			((diag_tickTime >= _timeStamp) OR not(call _loopConditions))
		};
	}else{
		[INFINTE] call BIS_fnc_bloodEffect;
		sleep _time;
	};
};

player setBleedingRemaining -1;

true