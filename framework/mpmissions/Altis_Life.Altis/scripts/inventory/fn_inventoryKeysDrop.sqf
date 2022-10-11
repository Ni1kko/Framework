#include "..\..\clientDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
	## fn_inventoryKeysDrop.sqf
*/

disableSerialization;

private _control = param [0, controlNull, [controlNull]];
private _ctrlParent = ctrlParent _control;

//-- Close display of the control that was clicked
if(not(isNull _ctrlParent))then{
	//_ctrlParent closeDisplay 1;
};

_ctrlParent = findDisplay 2700;
private _listBox = _ctrlParent displayCtrl 4;
private _selectedndex = lbCurSel _listBox;

if (_selectedndex isEqualTo -1) exitWith {
    hint localize "STR_NOTF_noDataSelected";
	false
};
 
if (_listBox lbData _selectedndex isEqualTo "") exitWith {
    hint localize "STR_NOTF_didNotSelectVehicle";
	false
};

private _selectedItem = life_var_vehicles param [_listBox lbValue _selectedndex, objNull, [objNull]];
if isNull _selectedItem exitWith {false};

// Do not let them drop the key to a house
if (_selectedItem isKindOf "House_F") exitWith {
    hint localize "STR_NOTF_cannotRemoveHouseKeys"
};

// Solve stupidness
if (objectParent player isEqualTo _selectedItem && {locked _selectedItem isEqualTo 2}) exitWith {
    hint localize "STR_NOTF_cannotDropKeys"
};

life_var_vehicles = life_var_vehicles - [_selectedItem];

// Update vehicle owners
private _owners = _selectedItem getVariable ["vehicle_info_owners", []];
_owners deleteAt _index;
_selectedItem setVariable ["vehicle_info_owners", _owners, true];

// Reload
[_ctrlParent] call MPClient_fnc_keyMenu;

true