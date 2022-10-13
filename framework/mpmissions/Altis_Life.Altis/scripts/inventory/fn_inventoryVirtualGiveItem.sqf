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
private _itemListBox = _ctrlParent displayCtrl INVENTORY_IDC_LIST;
private _amountEditbox = _ctrlParent displayCtrl INVENTORY_IDC_EDIT;
private _playerListCombo = _ctrlParent displayCtrl INVENTORY_IDC_COMBOPLAYERS;
private _pageCombo = _ctrlParent displayCtrl INVENTORY_IDC_COMBOPAGE;
private _selectedAmountText = ctrlText _amountEditbox;
private _selectedPlayerIndex = lbCurSel _playerListCombo;
private _selectedItemIndex = lbCurSel _itemListBox;
private _selectedPageIndex = lbCurSel _pageCombo;

if(count _selectedAmountText isEqualTo 0 OR _selectedPlayerIndex < 0 OR _selectedItemIndex < 0)exitWith{
	hint "Please select an item, player and amount";
	_ctrlParent closeDisplay 1;
	false
};

//-- Check selected index against list to make sure we don't hit out of bounds exception
if(_selectedPlayerIndex < 0 OR _selectedPlayerIndex > ((count _nearPlayerList)-1))exitWith{
	//hint format["Error: invalid index(%1) out of bounds! expected between (0 AND %2) ",_selectedPlayerIndex,(count _nearPlayerList)-1];
	hint "Error: please select a valid target";
	false
};

//-- Check selected index against list to make sure we don't hit out of bounds exception
if(_selectedItemIndex < 0 OR _selectedItemIndex > ((lbSize _itemListBox)-1))exitWith{
	//hint format["Error: invalid index(%1) out of bounds! expected between (0 AND %2) ",_selectedItemIndex,(count _itemListBox)-1];
	hint "Error: please select a valid item";
	false
};

if(_selectedPageIndex < 0 OR _selectedPageIndex > ((lbSize _pageCombo)-1))exitWith{
	//hint "Error: invalid page index";
	false
};

//-- Amount to give not a number
if (not([_selectedAmountText] call MPServer_fnc_isNumber)) exitWith {
    hint "Error: Please enter a valid number";
	_ctrlParent closeDisplay 1;
	false
};

private _selectedAmount = parseNumber _selectedAmountText;
private _selectedPlayer = _nearPlayerList param [_selectedPlayerIndex,objNull,[objNull]];
private _selectedItem = _itemListBox lbData _selectedItemIndex;
private _selectedPage = _pageCombo lbdata _selectedPageIndex;

//-- Player valid
if(isNull _selectedPlayer OR not(alive _selectedPlayer))exitWith{
	hint "Error: Please select an alive player";
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

//-- Amount to give sanity check
if(_selectedAmount < 1 OR  _selectedAmount > 10)exitWith{
	hint "Please select an amount between 1 and 10";
	//_ctrlParent closeDisplay 1;
	false
};

if (not(isNull objectParent player) AND not(_selectedPlayer in crew (vehicle player))) exitWith {
	titleText["You cannot give an item when you are in a vehicle, to someone outside vehicle!","PLAIN"];
	false
};

if (ITEM_ILLEGAL(_selectedItem) isEqualTo 1 AND ([west,visiblePosition player,100] call MPClient_fnc_nearUnits)) exitWith {
	titleText["This is an illegal item and cops are near by. You cannot dispose of the evidence.", "PLAIN"];
	false
};

if not(["GIVE",_selectedItem, _selectedAmount, _selectedPage, _selectedPlayer] call MPClient_fnc_handleVitrualItem) exitWith {
    hint "You do not have enough of this item to give";
	false
};

private _selectedItemName = ITEM_DISPLAYNAME(_selectedItem);
private _selectedPlayerName = _selectedPlayer getVariable ["realname", name _selectedPlayer];

if(_selectedAmount isEqualTo 1)then{
	hint format["You gave %1 to %2",_selectedItemName,_selectedPlayerName];
}else{
	hint format ["You gave (%1) %2 to %3.", _selectedItemName, _selectedPlayerName,_selectedAmount];
};

//-- Close display of the control that was clicked
//_ctrlParent closeDisplay 1;

private _returnControl = _ctrlParent getVariable ["RscDisplayInventory_ReturnControl", controlNull];
private _mainPageIndex = _ctrlParent getVariable ["RscDisplayInventory_mainPageIndex", 0];

[_returnControl,_mainPageIndex] spawn MPClient_fnc_inventoryShowVirtual;

true