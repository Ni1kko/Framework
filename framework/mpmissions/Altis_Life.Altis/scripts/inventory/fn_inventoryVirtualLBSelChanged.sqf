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
private _useButton = _ctrlParent displayCtrl INVENTORY_IDC_USE;
private _dropButton = _ctrlParent displayCtrl INVENTORY_IDC_DROP;
private _amountEditbox = _ctrlParent displayCtrl INVENTORY_IDC_EDIT;
private _playerListCombo = _ctrlParent displayCtrl INVENTORY_IDC_COMBOPLAYERS;
private _giveButton = _ctrlParent displayCtrl INVENTORY_IDC_GIVE;
private _pageCombo = _ctrlParent displayCtrl INVENTORY_IDC_COMBOPAGE;
private _putButton = _ctrlParent displayCtrl INVENTORY_IDC_STORE;
private _nearPlayerList = _ctrlParent getVariable ["RscDisplayInventory_NearPlayerList", []];
private _selectedPageIndex = lbCurSel _pageCombo;
private _selectedAmountText = ctrlText _amountEditbox;
private _lockoutControls = [_useButton, _dropButton, _giveButton,_putButton];

//-- 
if(isNull _ctrlParent OR isNull _control) exitWith {false};

_playerListCombo ctrlEnable (count _nearPlayerList > 0);

if(_selectedIndex < 0 OR _selectedIndex > ((lbSize _control)-1))exitWith{
	//hint "Error: invalid item index";
	{_x ctrlEnable false}forEach _lockoutControls;
	false
};

if(_selectedPageIndex < 0 OR _selectedPageIndex > ((lbSize _pageCombo)-1))exitWith{
	//hint "Error: invalid page index";
	{_x ctrlEnable false}forEach _lockoutControls;
	false
};

if(count _selectedAmountText isEqualTo 0)exitWith{ 
	{_x ctrlEnable false}forEach _lockoutControls;
	false
};

//-- Amount to give not a number
if (not([_selectedAmountText] call MPServer_fnc_isNumber)) exitWith {
	{_x ctrlEnable false}forEach _lockoutControls;
	false
};

private _selectedPage = _pageCombo lbdata _selectedPageIndex;
private _selectedItem = _control lbdata _selectedIndex;
private _selectedItemValue = _control lbValue _selectedIndex;
private _selectedAmount = parseNumber _selectedAmountText;

//-- zero or more than is owned
if(_selectedAmount < 1 OR _selectedAmount > _selectedItemValue)exitWith{
	{_x ctrlEnable false}forEach _lockoutControls;
	false
};

//-- 
switch _selectedPage do 
{
	case "Ground": { };
	case "Player": { };
	case "Vehicle": { };
	case "House": { };
	case "Tent": { };
};

//-- 
switch (_selectedItem) do 
{
	//-- Items
	case "money": {};
	case "goldbar": {};
	case "toolkit": {};
	case "defibrillator": {};
	case "pickaxe": {};
	case "boltcutter": {};
    case "defusekit": {};
    case "storagesmall": {};
    case "storagebig": {};
    case "tentKit": {};
    case "fuelEmpty": {};
    case "lockpick":{};
    case "spikeStrip": {};
    case "blastingcharge": {};
    case "fuelFull": {};
	//--- Materials
	case "oil_unprocessed": {};
	case "oil_processed": {};
	case "copper_unrefined": {};
	case "copper_refined": {};
	case "iron_unrefined": {};
	case "iron_refined": {};
	case "salt_unrefined": {};
	case "salt_refined": {};
	case "sand": {};
	case "glass": {};
	case "diamond_uncut": {};
	case "diamond_cut": {};
	case "rock": {};
	case "cement": {};
	//--- Drugs
	case "opium_poppy": {};
	case "heroin_processed": {};
	case "morphine": {};
	case "codeine": {};
	case "marijuanaWet": {};
	case "marijuana": {};
	case "medical_marijuana": {};
	case "cocaine_unprocessed": {};
	case "cocaine_processed": {}; 
	//--- Drinks
	case "redgull": {};
	case "coffee": {};
	case "waterBottle": {};
	//--- Foods
	case "apple": {};
	case "peach": {};
	case "tbacon": {};
	case "donuts": {};
	case "rabbit_raw": {};
	case "rabbit": {};
	case "salema_raw": {};
	case "salema": {};
	case "ornate_raw": {};
	case "ornate": {};
	case "mackerel_raw": {};
	case "mackerel": {};
	case "tuna_raw": {};
	case "tuna": {};
	case "mullet_raw": {};
	case "mullet": {};
	case "catshark_raw": {};
	case "catshark": {};
	case "turtle_raw": {};
	case "turtle_soup": {};
	case "hen_raw": {};
	case "hen": {};
	case "rooster_raw": {};
	case "rooster": {};
	case "sheep_raw": {};
	case "sheep": {};
	case "goat_raw": {};
	case "goat": {};
    default {};
};

//-- All seems good enable buttons again
{
	_x ctrlEnable (switch (ctrlIDC _x) do {
		case INVENTORY_IDC_GIVE: {ctrlEnabled _playerListCombo};
		default {true};
	});
}forEach _lockoutControls;

true