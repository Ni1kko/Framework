#include "..\..\clientDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
	## fn_inventoryShowKeys.sqf
*/

disableSerialization;
private _control = param [0, controlNull, [controlNull]];
private _ctrlParent = ctrlParent _control;

//-- Close display of the control that was clicked
if(not(isNull _ctrlParent))then{
    _ctrlParent closeDisplay 1;
}else{
    closeDialog 2;
};

//-- Open keychain
private _displayName = "RscDisplayPlayerInventoryKeyManagement";
private _display = _ctrlParent createDisplay _displayName;
uiNamespace setVariable [_displayName, _display];

private _backButton = GETControl(_displayName, "ButtonClose");
_backButton ctrlRemoveAllEventHandlers "MouseButtonUp";
_backButton ctrlAddEventHandler ["MouseButtonUp", "_this spawn MPClient_fnc_inventoryShow"];
_backButton ctrlSetText "Inventory";
_backButton ctrlSetToolTip "Return to inventory";
_backButton ctrlSetEventHandler ["MouseButtonUp", "_this spawn MPClient_fnc_inventoryShow"];
_backButton ctrlCommit 0;

private _dropButton = GETControl(_displayName, "ButtonDrop");
_dropButton ctrlRemoveAllEventHandlers "MouseButtonUp";
_dropButton ctrlAddEventHandler ["MouseButtonUp", "_this spawn MPClient_fnc_inventoryKeysDrop"];
_dropButton ctrlCommit 0;

private _giveButton = GETControl(_displayName, "ButtonGive");
_giveButton ctrlRemoveAllEventHandlers "MouseButtonUp";
_giveButton ctrlAddEventHandler ["MouseButtonUp", "_this spawn MPClient_fnc_inventoryKeysGive"];
_giveButton ctrlCommit 0;

//-- Sometimes onload event does not fire for some reason when jumping from dialog to gearDialog
[_display] call MPClient_fnc_keyMenu;

true