#include "..\..\clientDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
	## fn_inventoryVirtualGiveItem.sqf
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
private _selectedPlayerIndex = lbCurSel _playerListCombo;
private _selectedItemIndex = lbCurSel _itemListBox;

if(count _selectedAmountText isEqualTo 0 OR _selectedPlayerIndex < 0 OR _selectedItemIndex < 0)exitWith{
	hint "Please select an item, player and amount";
	_ctrlParent closeDisplay 1;
	false
};

//-- Check selected index against list to make sure we don't hit out of bounds exception
if(_selectedPlayerIndex < 0 OR _selectedPlayerIndex > ((count _nearPlayerList)-1))exitWith{
	hint format["Error: invalid index(%1) out of bounds! expected between (0 AND %2) ",_selectedPlayerIndex,(count _nearPlayerList)-1];
	false
};

//-- Check selected index against list to make sure we don't hit out of bounds exception
if(_selectedItemIndex < 0 OR _selectedItemIndex > ((lbSize _itemListBox)-1))exitWith{
	hint format["Error: invalid index(%1) out of bounds! expected between (0 AND %2) ",_selectedItemIndex,(count _itemListBox)-1];
	false
};

private _selectedAmount = parseNumber _selectedAmountText;
private _selectedPlayer = _nearPlayerList param [_selectedPlayerIndex,objNull,[objNull]];
private _selectedItem = call compile ([_itemListBox lbData _selectedItemIndex] param [0,str('')]);

//-- Player valid
if(isNull _selectedPlayer OR not(alive _selectedPlayer))exitWith{
	hint "Please select a valid player";
	//_ctrlParent closeDisplay 1;
	false
};

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

//-- Amount to give not a number
if (not([_selectedAmount] call MPServer_fnc_isNumber)) exitWith {
    hint "Please enter a valid number";
	_ctrlParent closeDisplay 1;
	false
};

//-- Amount to give sanity check
if(_selectedAmount < 1 OR  _selectedAmount > 10)exitWith{
	hint "Please select an amount between 1 and 10";
	//_ctrlParent closeDisplay 1;
	false
};

private _didRemove = [false,_selectedItem, _selectedAmount] call MPClient_fnc_handleInv;

if (not(_didRemove)) exitWith {
    hint "You do not have enough of this item to give";
};

private _selectedPlayerName = _selectedPlayer getVariable ["realname", name _selectedPlayer];
private _selectedItemName = ITEM_DISPLAYNAME(_selectedItem);
[
	_selectedPlayer, 
	_selectedAmount, 
	_selectedItem, 
	player
] remoteExecCall ["MPClient_fnc_receiveItem", owner _selectedPlayer];

if(_selectedAmount isEqualTo 1)then{
	hint format["You gave %1 to %2",_selectedItemName,_selectedPlayerName];
}else{
	hint format ["You gave (%1) %2 to %3.", _selectedItemName, _selectedPlayerName,_selectedAmount];
};

//-- Close display of the control that was clicked
//_ctrlParent closeDisplay 1;

true