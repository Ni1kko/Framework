/*

	Function: 	MPClient_fnc_deathScreenKeyHandler
	Project: 	Misty Peaks RPG
	Author:     Tonic, Merrick, Nikko, Affect & IceEagle132
	Github:		https://github.com/AsYetUntitled/Framework
	
*/

#include "\a3\ui_f\hpp\definedikcodes.inc"

params ["_ctrl","_code","_shift","_ctrlKey","_alt"];

private _handled = false;
private _medicReqKey = (actionKeys "ShowMap") select 0;


switch _code do {
	case _medicReqKey:
	{
		_handled = true;
		[player] call MPClient_fnc_requestMedic;
	};
	case DIK_R:
	{
		_handled = true;
		if (life_deathScreen_canRespawn) then {
			player setDamage 1;
		};
	};
	case DIK_H:
	{
		if (call life_adminlevel > 0) then {
			_handled = true;
			[] spawn MPClient_fnc_revived;
		};
	};
	case DIK_MINUS:
	{
		if(_shift) then {
			_handled = true;
			[] spawn {
				hint "You are frozen for 15 seconds for Shift minus";
				disableUserInput true;
				uiSleep 15;
				disableUserInput false;
				hint "You are thawed";
			};
		};
	};
};

_handled