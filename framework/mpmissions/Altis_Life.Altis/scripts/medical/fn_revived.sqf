#include "..\..\script_macros.hpp"
/*

	Function: 	MPClient_fnc_revived
	Project: 	Misty Peaks RPG
	Author:     Tonic, Merrick, Nikko, Affect & IceEagle132
	Github:		https://github.com/Ni1kko/FrameworkV2
	
*/

private _reviversName = param [0,"Unknown Medic",[""]];
private _reviveCost = LIFE_SETTINGS(getNumber,"revive_fee");
 
//-- Stop bleeding
["revived"] call MPClient_fnc_removeBuff;

//-- remove death screen
["RscDisplayDeathScreen"] call MPClient_fnc_destroyRscLayer;
closeDialog 0;

player setUnitLoadout life_save_gear;

life_is_alive = true;
player setUnconscious false;
player playMoveNow "amovpercmstpsnonwnondnon";

{player setVariable _x} forEach [
	['medicStatus',nil,true],
	['Revive',nil,true],
	['name',nil,true],
	['Reviving',nil,true],
	["lifeState","HEALTHY",true]
];

//Take fee for services.
["SUB","CASH",_reviveCost] call MPClient_fnc_handleMoney;

hint format [localize "STR_Medic_RevivePay",_reviversName,[_reviveCost] call MPClient_fnc_numberText];
 
[] call MPClient_fnc_playerSkins;
[] call MPClient_fnc_updateRequest;

2 fadeSound 1;
cutText ["You come to your senses ...", "BLACK IN", 5];
uiSleep 4;