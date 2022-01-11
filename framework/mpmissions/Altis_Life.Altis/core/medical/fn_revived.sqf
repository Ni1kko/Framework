#include "..\..\script_macros.hpp"
/*

	Function: 	life_fnc_revived
	Project: 	Misty Peaks RPG
	Author:     Tonic, Merrick, Nikko, Affect & IceEagle132
	Github:		https://github.com/AsYetUntitled/Framework
	
*/

private ["_medic","_dir","_reviveCost"];
_medic = param [0,"Unknown Medic",[""]];
_reviveCost = LIFE_SETTINGS(getNumber,"revive_fee");

[life_save_gear] spawn life_fnc_loadDeadGear;

//remove death screen & Bring me back to life. 
[_unit,true,false] spawn life_fnc_deathScreen;


player setUnconscious false;
player playMoveNow "amovpercmstpsnonwnondnon";

player setVariable ["medicStatus",nil,true];
player setVariable ["Revive",nil,true];
player setVariable ["name",nil,true];
player setVariable ["Reviving",nil,true];
player setVariable ["lifeState","HEALTHY",true];

//Take fee for services.
if (life_var_bank > _reviveCost) then {
    life_var_bank = life_var_bank - _reviveCost;
} else {
    life_var_bank = 0;
};

hint format [localize "STR_Medic_RevivePay",_medic,[_reviveCost] call life_fnc_numberText];
 
[] call life_fnc_playerSkins;
[] call SOCK_fnc_updateRequest;

2 fadeSound 1;
cutText ["You come to your senses ...", "BLACK IN", 5];
uiSleep 4;