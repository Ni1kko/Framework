#include "..\..\script_macros.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/
params [
	["_reviver",objNull,[objNull]],
	["_player",objNull,[objNull]],
	["_arrested",false,[false]]
];

if(isNull _reviver OR isNull _player)exitWith{false};
if(_player isNotEqualTo player)exitWith{false};

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

private _reviversName = _reviver getVariable ["realname",name _reviver];
private _message = format ["%1 has revived you",_reviversName];

if(_reviver isEqualTo _player)then{
	_message = "You have revived yourself";
};

//-- Take fee for services.
if (not(_arrested)) then {
	private _reviveCost = CFG_MASTER(getNumber,"revive_fee");
	_message = format [localize "STR_Medic_RevivePay",_reviversName,[_reviveCost] call MPClient_fnc_numberText];
	["SUB","BANK",_reviveCost] call MPClient_fnc_handleMoney;
};

systemChat _message;

//-- Database update
[] call MPClient_fnc_updatePlayerData;

true