#include "..\..\clientDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
	## fn_inventoryVirtualMoveItemToVehicle.sqf
*/

disableSerialization;
private _control = param [0, controlNull, [controlNull]];
private _ctrlParent = ctrlParent _control;

if(isNull _ctrlParent OR isNull _control) exitWith {false};

private _nearPlayerList = _ctrlParent getVariable ["RscDisplayInventory_NearPlayerList", []];
private _itemListBox = _ctrlParent displayCtrl INVENTORY_IDC_LIST;
private _amountEditbox = _ctrlParent displayCtrl INVENTORY_IDC_EDIT;
private _playerListCombo = _ctrlParent displayCtrl INVENTORY_IDC_COMBOPLAYERS;
private _selectedAmountText = ctrlText _amountEditbox;
private _selectedPlayerIndex = lbCurSel _playerListCombo;
private _selectedItemIndex = lbCurSel _itemListBox;

//-- Check selected index against list to make sure we don't hit out of bounds exception
if(count _selectedAmountText isEqualTo 0 OR _selectedItemIndex < 0 OR _selectedItemIndex > ((lbSize _itemListBox)-1))exitWith{
	//hint format["Error: invalid index(%1) out of bounds! expected between (0 AND %2) ",_selectedItemIndex,(count _itemListBox)-1];
	hint "Please select an item and amount";
	_ctrlParent closeDisplay 1;
	false
};

//-- Amount to give not a number
if (not([_selectedAmountText] call MPServer_fnc_isNumber)) exitWith {
    hint "Error: Please enter a valid number";
	_ctrlParent closeDisplay 1;
	false
};

private _selectedAmount = parseNumber _selectedAmountText;
private _selectedItem = _itemListBox lbData _selectedItemIndex;

//-- Item is string empty
if(count _selectedItem isEqualTo 0)exitWith{
	hint "Error: no item selected!";
	//_ctrlParent closeDisplay 1;
	false
};

//-- 
if(_selectedAmount < 1)exitWith{
	hint "Error: Please select an amount";
	//_ctrlParent closeDisplay 1;
	false
};

private _returnControl = _ctrlParent getVariable ["RscDisplayInventory_ReturnControl", controlNull];
private _mainPageIndex = _ctrlParent getVariable ["RscDisplayInventory_mainPageIndex", 0];
private _selectedItemName = ITEM_DISPLAYNAME(_selectedItem);
private _targetObject = _ctrlParent setVariable ["RscDisplayInventory_targetObject", objNull];
private _allowedTypes = [];

if(isNull _targetObject)exitWith {
    hint "Error: No target object found!";
	false
};

if(_targetObject isEqualTo player)exitWith {
    hint "Error: Items already in your inventory!";
	false
};

if(_object isKindOf "CAManBase")exitWith {
    hint "Error: Can store items into other player inventorys\nuse the give or drop option!";
	false
};

//-- Vehicle types
_allowedTypes append ["Car","Air","Ship","Armored","Submarine"];
//-- House types
_allowedTypes append ["Box_IND_Grenades_F","B_supplyCrate_F"];
//-- Tent types
_allowedTypes append ["Land_Campfire_F", "Campfire_burning_F","Land_TentA_F","Land_TentDome_F"];

if not(typeOf _targetObject in _allowedTypes)exitWith {
    hint "Error: Can only store vitems into vehicles, houses and tents!";
	false
};

if not(["PUT", _selectedItem, _selectedAmount,_targetObject] call MPClient_fnc_handleVitrualItem) exitWith {
    hint "Error: Failed to store item!";
	false
};

if(_selectedAmount isEqualTo 1)then{
	hint format["You moved %1 to vehicle storage",_selectedItemName];
}else{
	hint format ["You moved %2 (%1) to vehicle storage", _selectedItemName,_selectedAmount];
};

//-- Refresh the inventory
[_returnControl,_mainPageIndex] spawn MPClient_fnc_inventoryShowVirtual;

true