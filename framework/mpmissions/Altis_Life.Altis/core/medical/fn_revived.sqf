#include "..\..\script_macros.hpp"
/*

	Function: 	MPClient_fnc_revived
	Project: 	Misty Peaks RPG
	Author:     Tonic, Merrick, Nikko, Affect & IceEagle132
	Github:		https://github.com/AsYetUntitled/Framework
	
*/

private ["_medic","_dir","_reviveCost"];
_medic = param [0,"Unknown Medic",[""]];
_reviveCost = LIFE_SETTINGS(getNumber,"revive_fee");

[life_save_gear] spawn MPClient_fnc_loadDeadGear;

//remove death screen & Bring me back to life. 
[_unit,true,false] spawn MPClient_fnc_deathScreen;


player setUnconscious false;
player playMoveNow "amovpercmstpsnonwnondnon";

{player setVariable _x} forEach [
	['medicStatus',nil,true],
	['Revive',nil,true],
	['name',nil,true],
	['Reviving',nil,true],
	['lifeState','HEALTHY',true]
];

//Take fee for services.
if (life_var_bank > _reviveCost) then {
    life_var_bank = life_var_bank - _reviveCost;
} else {
    life_var_bank = 0;
};

hint format [localize "STR_Medic_RevivePay",_medic,[_reviveCost] call MPClient_fnc_numberText];
 
[] call MPClient_fnc_playerSkins;
[] call MPClient_fnc_updateRequest;

2 fadeSound 1;
cutText ["You come to your senses ...", "BLACK IN", 5];
uiSleep 4;