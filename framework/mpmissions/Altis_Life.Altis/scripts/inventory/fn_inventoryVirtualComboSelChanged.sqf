#include "..\..\clientDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
	## fn_inventoryVirtualComboSelChanged.sqf
*/

disableSerialization;

params [
	["_control", controlNull, [controlNull]],
	["_selectedIndex", -1, [0]],
	["_selectedIndexs", [], [[]]]
];

hint format ["fn_inventoryVirtualComboSelChanged\n%1", str _this];

if(isNull _ctrlParent OR isNull _control) exitWith {
	false
};

private _ctrlParent = ctrlParent _control;
private _itemListBox = _ctrlParent displayCtrl INVENTORY_IDC_LIST;
private _dropButton = _ctrlParent displayCtrl INVENTORY_IDC_DROP;
private _amountEditbox = _ctrlParent displayCtrl INVENTORY_IDC_EDIT;
private _playerListCombo = _ctrlParent displayCtrl INVENTORY_IDC_COMBOPLAYERS;
private _giveButton = _ctrlParent displayCtrl INVENTORY_IDC_GIVE;
private _returnControl = _ctrlParent getVariable ["RscDisplayInventory_ReturnControl", controlNull];
private _lastPage = _ctrlParent getVariable ["RscDisplayInventory_CurrentPage", ["", -1]];
private _nearPlayerList = _ctrlParent getVariable ["RscDisplayInventory_NearPlayerList", []];

//-- Check selected index against list to make sure we don't hit out of bounds exception
if(_selectedIndex < 0 OR _selectedIndex > ((lbSize _control)-1))exitWith{
	hint format["Error: invalid index(%1) out of bounds! expected between (0 AND %2) ",_selectedIndex,(lbSize _control)-1];
	false
};

private _selectedPage = lbCurSel _selectedIndex;
private _currentPage = [_selectedPage, _selectedIndex];

//-- No fucking refresh it breaks arma now there a fucking suprise. whole game crashes coz this crap
if(_lastPage isEqualTo _currentPage) exitWith {false};
_ctrlParent setVariable ["RscDisplayInventory_CurrentPage",_currentPage];

//-- Handle blocking accses whilst being used by a player
if(_selectedPage in ["Vehicle", "House", "Tent"]) then {
	if(isNull (_vehicle getVariable ["storageUser",objNull]))then{
		_vehicle setVariable ["storageUser",player,true];
	};
} else {
	if((_vehicle getVariable ["storageUser",objNull]) isEqualTo player)then{ 
		_vehicle setVariable ["storageUser",objNull,true];
	};
};

[_returnControl,_selectedIndex] call MPClient_fnc_inventoryShowVirtual;

true