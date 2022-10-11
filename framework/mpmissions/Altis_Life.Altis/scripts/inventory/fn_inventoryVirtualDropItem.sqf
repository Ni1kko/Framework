#include "..\..\clientDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
	## fn_inventoryVirtualDropItem.sqf
*/

disableSerialization;
private _control = param [0, controlNull, [controlNull]];
private _ctrlParent = ctrlParent _control;

if(isNull _ctrlParent OR isNull _control) exitWith {false};

private _nearPlayerList = _ctrlParent getVariable ["RscDisplayInventory_NearPlayerList", []];
private _itemListBox = _ctrlParent displayCtrl 77706;
private _amountEditbox = _ctrlParent displayCtrl 77709;
private _playerListCombo = _ctrlParent displayCtrl 77710;
private _selectedAmountText = ctrlText _amountEditbox;
private _selectedItemIndex = lbCurSel _itemListBox;

if(count _selectedAmountText isEqualTo 0 OR _selectedItemIndex < 0)exitWith{
	hint "Please select an item, player and amount";
	_ctrlParent closeDisplay 1;
	false
};

//-- Check selected index against list to make sure we don't hit out of bounds exception
if(_selectedItemIndex < 0 OR _selectedItemIndex > ((lbSize _itemListBox)-1))exitWith{
	hint format["Error: invalid index(%1) out of bounds! expected between (0 AND %2) ",_selectedItemIndex,(count _itemListBox)-1];
	false
};


//-- Amount to give not a number
if (not([_selectedAmountText] call MPServer_fnc_isNumber)) exitWith {
    hint "Please enter a valid number";
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

//-- Item is string empty
if(count _selectedItem isEqualTo 0)exitWith{
	hint "Error: no item selected!";
	//_ctrlParent closeDisplay 1;
	false
};

//-- Amount to give sanity check
if(_selectedAmount < 1 OR  _selectedAmount > 10)exitWith{
	hint "Please select an amount between 1 and 10";
	//_ctrlParent closeDisplay 1;
	false
};

if not(isNull objectParent player) exitWith {
	titleText[localize "STR_NOTF_cannotRemoveInVeh","PLAIN"];
	false
};

private _selectedItemName = ITEM_DISPLAYNAME(_selectedItem);
private _didDrop = [player,_selectedItem,_selectedAmount] call MPClient_fnc_dropItem;

if (not(_didDrop)) exitWith {
    hint format["You do not have enough %1 to drop",toLower _selectedItemName];
	false
};

if(_selectedAmount isEqualTo 1)then{
	hint format["You dropped %1",_selectedItemName];
}else{
	hint format ["You dropped %2 (%1)", _selectedItemName,_selectedAmount];
};

//-- Close display of the control that was clicked
//_ctrlParent closeDisplay 1;

private _returnControl = _ctrlParent getVariable ["RscDisplayInventory_ReturnControl", controlNull];
private _mainPageIndex = _ctrlParent getVariable ["RscDisplayInventory_mainPageIndex", 0];

[_returnControl,_mainPageIndex] spawn MPClient_fnc_inventoryShowVirtual;

true