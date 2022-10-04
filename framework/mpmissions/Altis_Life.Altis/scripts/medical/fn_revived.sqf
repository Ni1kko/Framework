#include "..\..\script_macros.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

private _reviversName = param [0,"Unknown Medic",[""]];
private _reviveCost = LIFE_SETTINGS(getNumber,"revive_fee");
 
//--
{player setVariable _x} forEach [
	['medicStatus',nil,true],
	['Revive',nil,true],
	['name',nil,true],
	['Reviving',nil,true],
	["lifeState","HEALTHY",true]
];

//-- remove death screen
[_unit, true] spawn MPClient_fnc_deathScreen;

//-- Reload there gear
if(count life_var_gearWhenDied > 0)then{player setUnitLoadout life_var_gearWhenDied};
systemChat "You have been revived, Dont forget to pick up any dropped items!";

//-- Animate
player playMoveNow "amovpercmstpsnonwnondnon";
uiSleep 3;

//-- Take fee for services.
["SUB","BANK",_reviveCost] call MPClient_fnc_handleMoney;
systemChat format [localize "STR_Medic_RevivePay",_reviversName,[_reviveCost] call MPClient_fnc_numberText];

//-- Database update
[] call MPClient_fnc_updatePlayerData;

true