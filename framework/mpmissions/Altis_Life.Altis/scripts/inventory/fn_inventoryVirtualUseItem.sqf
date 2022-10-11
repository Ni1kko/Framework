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


//-- Amount to give not a number
if (not([_selectedAmountText] call MPServer_fnc_isNumber)) exitWith {
    hint "Please enter a valid number";
	_ctrlParent closeDisplay 1;
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

//-- Amount to give sanity check
if(_selectedAmount < 1 OR  _selectedAmount > 10)exitWith{
	hint "Please select an amount between 1 and 10";
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

if (_edible > -1 || _drinkable > -1) exitWith {
	for "_i" from 1 to _selectedAmount do {
		if ([false, _selectedItem, 1] call MPClient_fnc_handleInv) then {
			if (_edible > -1) then {
				private _sum = life_var_hunger + _edible;
				life_var_hunger = (_sum max 5) min 100; // never below 5 or above 100
			};

			if (_drinkable > -1) then {
				private _sum = life_var_thirst + _drinkable;

				life_var_thirst = (_sum max 5) min 100; // never below 5 or above 100

				if (CFG_MASTER(getNumber, "enable_fatigue") isEqualTo 1) then {
					player setFatigue 0;
				};
				if (_selectedItem isEqualTo "redgull" && {CFG_MASTER(getNumber, "enable_fatigue") isEqualTo 1}) then {
					[] spawn {
						life_var_effectEnergyDrink = time;
						titleText [localize "STR_ISTR_RedGullEffect", "PLAIN"];
						player enableFatigue false;
						waitUntil {!alive player || ((time - life_var_effectEnergyDrink) > (3 * 60))};
						player enableFatigue true;
					};
				};
			};
		};

    	[_returnControl,_mainPageIndex] spawn MPClient_fnc_inventoryShowVirtual;
	};
};

switch (_selectedItem) do 
{
	//-- Items
	//case "money": {};
	//case "goldbar": {};
	//case "toolkit": {};
	//case "defibrillator": {};
	//case "pickaxe": {};
	case "boltcutter": {[cursorObject] spawn MPClient_fnc_boltcutter};
    case "defusekit": {[cursorObject] spawn MPClient_fnc_defuseKit};
    case "storagesmall": {[false] call MPClient_fnc_storageBox};
    case "storagebig": { [true] call MPClient_fnc_storageBox};
    case "tentKit": {["Land_TentDome_F"] spawn MPClient_fnc_deployTent};
    case "fuelEmpty": {[] spawn MPClient_fnc_jerryCanRefuel};
    case "lockpick": {[] spawn MPClient_fnc_lockpick};
    case "spikeStrip":
	{
        if (!isNull life_var_vehicleStinger) exitWith {hint localize "STR_ISTR_SpikesDeployment"; closeDialog 0};
        if ([false, _selectedItem, 1] call MPClient_fnc_handleInv) then {
            [] spawn MPClient_fnc_spikeStrip;
        };
    };
    case "blastingcharge": 
	{
        player reveal fed_bank;
        (group player) reveal fed_bank;
        [cursorObject] spawn MPClient_fnc_blastingCharge;
    };
    case "fuelFull": 
	{
        if !(isNull objectParent player) exitWith {hint localize "STR_ISTR_RefuelInVehicle"};
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
	//case "opium_poppy": {};
	//case "heroin_processed": {};
	//case "morphine": {};
	//case "codeine": {};
	//case "marijuanaWet": {};
	//case "marijuana": {};
	//case "medical_marijuana": {};
	//case "cocaine_unprocessed": {};
	//case "cocaine_processed": {}; 
	//--- Drinks
	//case "redgull": {};
	//case "coffee": {};
	//case "waterBottle": {};
	//--- Foods
	//case "apple": {};
	//case "peach": {};
	//case "tbacon": {};
	//case "donuts": {};
	//case "rabbit_raw": {};
	//case "rabbit": {};
	//case "salema_raw": {};
	//case "salema": {};
	//case "ornate_raw": {};
	//case "ornate": {};
	//case "mackerel_raw": {};
	//case "mackerel": {};
	//case "tuna_raw": {};
	//case "tuna": {};
	//case "mullet_raw": {};
	//case "mullet": {};
	//case "catshark_raw": {};
	//case "catshark": {};
	//case "turtle_raw": {};
	//case "turtle_soup": {};
	//case "hen_raw": {};
	//case "hen": {};
	//case "rooster_raw": {};
	//case "rooster": {};
	//case "sheep_raw": {};
	//case "sheep": {};
	//case "goat_raw": {};
	//case "goat": {};
    default {hint localize "STR_ISTR_NotUsable"};
};

//-- Close display of the control that was clicked
_ctrlParent closeDisplay 1;

[_returnControl,_mainPageIndex] spawn MPClient_fnc_inventoryShowVirtual;

true