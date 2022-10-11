#include "..\..\clientDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
	## fn_inventoryVirtualLBSelChanged.sqf
*/

disableSerialization;

params [
	["_control", controlNull, [controlNull]],
	["_selectedIndex", -1, [0]],
	["_selectedIndexs", [], [[]]]
];

hint format ["fn_inventoryVirtualLBSelChanged\n%1", str _this];

private _ctrlParent = ctrlParent _control;
private _pageCombo = _ctrlParent displayCtrl 77712;
private _playerListCombo = _ctrlParent displayCtrl 77710;
private _confirmButton = _ctrlParent displayCtrl 77711;
private _nearPlayerList = _ctrlParent getVariable ["RscDisplayInventory_NearPlayerList", []];
private _selectedPageIndex = lbCurSel _pageCombo;

//-- 
if(isNull _ctrlParent OR isNull _control) exitWith {false};
if(_selectedIndex < 0 OR _selectedIndex > ((lbSize _control)-1))exitWith{
	hint "Error: invalid item index";
	false
};

if(_selectedPageIndex < 0 OR _selectedPageIndex > ((lbSize _pageCombo)-1))exitWith{
	hint "Error: invalid item index";
	false
};

private _selectedItem = _control lbdata _selectedIndex;
switch _selectedItem do 
{
	case "Player": { };
	case "Ground": { };
	case "Vehicle": { };
	case "House": { };
	case "Tent": { };
};

private _selectedPage = _pageCombo lbdata _selectedPageIndex;
switch _selectedPage do 
{
	case "Ground": { };
	case "Player": { };
	case "Vehicle": { };
	case "House": { };
	case "Tent": { };
};

_playerListCombo ctrlEnable (count _nearPlayerList > 0);

//-- All seems good enable button again
_confirmButton ctrlEnable (ctrlEnabled _playerListCombo);

true