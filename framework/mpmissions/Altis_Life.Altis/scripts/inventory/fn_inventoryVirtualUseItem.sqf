#include "..\..\clientDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
	## fn_inventoryVirtualUseItem.sqf
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

//-- Amount to give sanity check
if(_selectedAmount < 1 OR  _selectedAmount > 10)exitWith{
	hint "Error: Please select an amount between 1 and 10";
	//_ctrlParent closeDisplay 1;
	false
};

private _returnControl = _ctrlParent getVariable ["RscDisplayInventory_ReturnControl", controlNull];
private _mainPageIndex = _ctrlParent getVariable ["RscDisplayInventory_mainPageIndex", 0];
private _selectedItemName = ITEM_DISPLAYNAME(_selectedItem);
private _edible = M_CONFIG(getNumber, "cfgVirtualItems", _selectedItem, "edible");
private _drinkable = M_CONFIG(getNumber, "cfgVirtualItems", _selectedItem, "drinkable");

if (ITEM_ILLEGAL(_selectedItem) isEqualTo 1 AND ([west,visiblePosition player,100] call MPClient_fnc_nearUnits)) then {
	systemChat format["%1 is an illegal item and cops are near by, risky...", _selectedItemName];
};

private _itemRemoved = false;
private _itemUsed = false;
private _itemConsumed = "NONE";

if (_edible > -1 OR _drinkable > -1) then 
{
	_itemRemoved = ["TAKE", _selectedItem, _selectedAmount] call MPClient_fnc_handleVitrualItem;
	if _itemRemoved then 
	{
		switch (true) do
		{
			case (_edible >= 1):
			{
				private _sum = life_var_hunger + _edible;
				life_var_hunger = (_sum max 5) min 100; // never below 5 or above 100
				_itemConsumed = "FOOD";
			};
			case (_drinkable >= 1): 
			{
				private _sum = life_var_thirst + _drinkable;
				life_var_thirst = (_sum max 5) min 100; // never below 5 or above 100
				_itemConsumed = "DRINK";
				//-- remove any fatiuge
				if (CFG_MASTER(getNumber, "enable_fatigue") isEqualTo 1) then {player setFatigue 0};
			};
		};
	};
};


switch _selectedItem do 
{
	//-- Items
	case "money": {};
	case "goldbar": {};
	case "toolkit": {};
	case "defibrillator": {};
	case "pickaxe": {};
	case "boltcutter": 
	{
		_itemUsed = true;
		[cursorObject] spawn MPClient_fnc_boltcutter;
	};
    case "defusekit": 
	{
		_itemUsed = true;
		[cursorObject] spawn MPClient_fnc_defuseKit;
	};
    case "storagesmall": 
	{
		_itemUsed = true;
		[false] call MPClient_fnc_storageBox;
	};
    case "storagebig": 
	{
		_itemUsed = true; 
		[true] call MPClient_fnc_storageBox;
	};
    case "tentKit": 
	{
		_itemUsed = true;
		["Land_TentDome_F"] spawn MPClient_fnc_deployTent;
	};
    case "fuelEmpty": 
	{
		_itemUsed = true;
		[] spawn MPClient_fnc_jerryCanRefuel;
	};
    case "lockpick": 
	{
		_itemUsed = true;
		[] spawn MPClient_fnc_lockpick;
	};
    case "spikeStrip":
	{
        if not(isNull life_var_vehicleStinger) exitWith {hint localize "STR_ISTR_SpikesDeployment"; closeDialog 0};
        if (["TAKE", _selectedItem, 1] call MPClient_fnc_handleVitrualItem) then 
		{
			_itemUsed = true;
            [] spawn MPClient_fnc_spikeStrip;
        };
    };
    case "blastingcharge": 
	{ 
		_itemUsed = true;
        player reveal fed_bank;
        (group player) reveal fed_bank;
        [cursorObject] spawn MPClient_fnc_blastingCharge;
    };
    case "fuelFull": 
	{
        if not(isNull objectParent player) exitWith {hint localize "STR_ISTR_RefuelInVehicle"};
		_itemUsed = true;
        [] spawn MPClient_fnc_jerryRefuel;
    };
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
	case "redgull": 
	{
		//-- Disable fatiuge system for few mins to simulate effects of engery juice
		if (_itemRemoved AND CFG_MASTER(getNumber, "enable_fatigue") isEqualTo 1) then {
			_itemUsed = true;
			[] spawn {
				life_var_effectEnergyDrink = time;
				titleText [localize "STR_ISTR_RedGullEffect", "PLAIN"];
				player enableFatigue false;
				waitUntil {!alive player || ((time - life_var_effectEnergyDrink) > (3 * 60))};
				if (CFG_MASTER(getNumber, "enable_fatigue") isEqualTo 1) then {player enableFatigue true};
			};
		};
	};
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
};

if not(_itemRemoved OR _itemUsed) exitWith {
	hint localize "STR_ISTR_NotUsable";
	lbClear _control;
	[_returnControl,_mainPageIndex] spawn MPClient_fnc_inventoryShowVirtual;
	false
};

//-- Close display of the control that was clicked if item is usable
if _itemUsed exitWith {
	_ctrlParent closeDisplay 1;
	true
};

if(_selectedAmount > 1)then{
	switch _itemConsumed do {
		case "FOOD": {hint format["You ate %1 %2s",_selectedAmount, _selectedItem]};
		case "DRINK": {hint format["You drank %1 %2s",_selectedAmount, _selectedItem]};
		case "DRUG": {hint format["You used %1 %2s",_selectedAmount, _selectedItem]};
		case "ALCOHOL": {hint format["You drank %1 %2s",_selectedAmount, _selectedItem]};
	};
}else{
	switch _itemConsumed do {
		case "FOOD": {hint format["You ate a %1",_selectedAmount, _selectedItem]};
		case "DRINK": {hint format["You drank a %1",_selectedAmount, _selectedItem]};
		case "DRUG": {hint format["You used %1",_selectedAmount, _selectedItem]};
		case "ALCOHOL": {hint format["You drank a %1",_selectedAmount, _selectedItem]};
	};
};

//-- 
[_returnControl,_mainPageIndex] spawn MPClient_fnc_inventoryShowVirtual;

true