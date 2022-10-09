#include "..\..\clientDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
	## fn_inventoryVirtualComboSelChanged.sqf
*/

disableSerialization;

params [
	["_control", controlNull, [controlNull]],
	["_selectedIndex", -1, [0]]
];

hint format ["fn_inventoryVirtualComboSelChanged\n%1", str _this];

if(isNull _control OR _selectedIndex < 0) exitWith {false};
private _ctrlParent = ctrlParent _control;

if(isNull _ctrlParent) exitWith {false};
private _returnControl = _ctrlParent getVariable ["RscDisplayInventory_ReturnControl", controlNull];

if(isNull _returnControl) exitWith {
	_ctrlParent closeDisplay 2;
	false
};

private _modes = _ctrlParent getVariable ["ComboModes", []];
if(count _modes isEqualTo 0 OR _selectedIndex > count _modes)exitWith{false};
private _mode = (_modes#_selectedIndex);

_ctrlParent setVariable ["RscDisplayInventory_WalletMode", [_mode, _selectedIndex]];

switch _mode do {
	case "Player": {_vehicle getVariable ["storageUser",objNull,true]};
	case "Vehicle": {_vehicle getVariable ["storageUser",player,true]}; 
};

[_returnControl,_selectedIndex] call MPClient_fnc_inventoryShowVirtual;

true