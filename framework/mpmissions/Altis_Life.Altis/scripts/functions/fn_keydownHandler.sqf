/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

#include "..\..\clientDefines.hpp"
#include "\a3\ui_f\hpp\definedikcodes.inc"

disableSerialization;

private _caller = _this select 0;
private _keyCode = _this select 1;
private _shiftState = _this select 2;
private _controlState = _this select 3;
private _altState = _this select 4; 
private _stopPropagation = false;

if (_keyCode in (actionKeys "nightVision")) exitWith {true};
if (_keyCode in (actionKeys "TacticalView")) exitWith {true};

//Open Inventory whilst autoruning
if(_keyCode isEqualTo DIK_I AND life_var_autorun AND isNull(findDisplay 602)) exitWith {
	[]spawn { 
		if(life_var_autorun_inventoryOpened)exitWith{
			hint "Inventory Opening...";
		};
		life_var_autorun_inventoryOpened = true;
		["interrupt"] call MPClient_fnc_autoruntoggle;
		waitUntil{
			uiSleep 1;
			player action ["GEAR",objNull];//Force open inventory
			!isNull(findDisplay 602)
		};
		waitUntil{isNull(findDisplay 602)};
		["continue"] call MPClient_fnc_autoruntoggle;
		life_var_autorun_inventoryOpened = false; 
	};
	true
};
 
if(((_keyCode in [DIK_Q,DIK_E,DIK_NEXT,DIK_SPACE]) AND ExtremoClientIsInConstructionMode) OR _keyCode in [DIK_GRAVE,DIK_HOME,DIK_BACK,DIK_END,DIK_INSERT,DIK_F1,DIK_F2,DIK_F3,DIK_F4,DIK_F5,DIK_F6,DIK_F7,DIK_F8,DIK_F9,DIK_F10,DIK_F11,DIK_F12,DIK_1,DIK_2,DIK_3,DIK_4,DIK_5,DIK_6,DIK_7,DIK_8,DIK_9,DIK_0])then{
	_stopPropagation = true;
};
 
_stopPropagation