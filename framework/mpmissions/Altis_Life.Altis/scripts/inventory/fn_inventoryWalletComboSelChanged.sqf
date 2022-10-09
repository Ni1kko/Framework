#include "..\..\clientDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
	## fn_inventoryWalletComboSelChanged.sqf
*/

disableSerialization;

params [
	["_control", controlNull, [controlNull]],
	["_selectedIndex", -1, [0]]
];

hint format ["fn_inventoryWalletComboSelChanged\n%1", str _this];

if(_selectedIndex < 0) exitWith {false};

private _ctrlParent = ctrlParent _control;
private _returnControl = _ctrlParent getVariable ["RscDisplayInventory_ReturnControl", controlNull];

if(isNull _returnControl) exitWith {
	_ctrlParent closeDisplay 2;
	false
};

[_returnControl,_selectedIndex] call MPClient_fnc_inventoryShowWallet;

true