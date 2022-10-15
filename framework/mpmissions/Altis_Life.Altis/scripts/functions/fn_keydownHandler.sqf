/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/
#define DIK_INCLUDES 1
#include "..\..\clientDefines.hpp"

disableSerialization;

private _caller = _this select 0;
private _keyCode = _this select 1;
private _shiftState = _this select 2;
private _controlState = _this select 3;
private _altState = _this select 4; 
private _stopPropagation = false;

if (_keyCode in (actionKeys "nightVision")) exitWith {true};
if (_keyCode in (actionKeys "TacticalView")) exitWith {true};

//Open Inventory
if(_keyCode isEqualTo DIK_I) exitWith 
{  
	private _controlParent = findDisplay INVENTORY_IDD;

	if not(isNull(_controlParent))then{
		_controlParent closeDisplay 2; 
	}else{
		[
			INVENTORY_IDC_VIRTUALITEMS, 
			INVENTORY_INDEX_VIRTUALITEMS_PLAYER, 
			life_var_autorun
		] spawn {//-- Bit messy but it works
			scriptName 'MPClient_fnc_inventoryOpenScript';
			params ["_idc", "_pageIndex", "_autorun"];
			private _control = {((findDisplay INVENTORY_IDD) displayCtrl _idc)}; 
			private _controlParent = {ctrlParent (call _control)};
			if life_var_inventoryLoading exitwith{false};life_var_inventoryLoading = true;
			if _autorun then {["interrupt"] call MPClient_fnc_autoruntoggle};
			private _inventoryShowThread = [(call _control)] spawn MPClient_fnc_inventoryShow;
			waitUntil {scriptDone _inventoryShowThread};
			private _inventoryShowVirtualTabThread = [(call _control),_pageIndex] spawn MPClient_fnc_inventoryShowVirtual;
			waitUntil {scriptDone _inventoryShowVirtualTabThread AND {not(life_var_inventoryLoading AND _autorun) OR isNull(call _controlParent)}};
			life_var_inventoryLoading = true;
			if _autorun then {["continue"] call MPClient_fnc_autoruntoggle};
			uisleep 1;
			life_var_inventoryLoading = false;
			true
		};
	};

	true
};
 
if(((_keyCode in [DIK_Q,DIK_E,DIK_NEXT,DIK_SPACE]) AND (player getvariable ["inConstructionMode",false])) OR _keyCode in [DIK_GRAVE,DIK_HOME,DIK_BACK,DIK_END,DIK_INSERT,DIK_F1,DIK_F2,DIK_F3,DIK_F4,DIK_F5,DIK_F6,DIK_F7,DIK_F8,DIK_F9,DIK_F10,DIK_F11,DIK_F12,DIK_1,DIK_2,DIK_3,DIK_4,DIK_5,DIK_6,DIK_7,DIK_8,DIK_9,DIK_0])then{
	_stopPropagation = true;
};
 
_stopPropagation