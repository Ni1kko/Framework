#include "..\..\clientDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
	## fn_inventoryWalletMoneyLBSelChanged.sqf
*/

disableSerialization;

params [
	["_control", controlNull, [controlNull]],
	["_selectedIndex", -1, [0]],
	["_selectedIndexs", [], [[]]]
];

hint format ["fn_inventoryWalletMoneyLBSelChanged\n%1", str _this];

private _ctrlParent = ctrlParent _control;
private _dropButton = _ctrlParent displayCtrl 77708;
private _amountEditbox = _ctrlParent displayCtrl 77709;
private _playerListCombo = _ctrlParent displayCtrl 77710;
private _giveButton = _ctrlParent displayCtrl 77711;
private _nearPlayerList = _ctrlParent setVariable ["RscDisplayInventory_NearPlayerList", []];

//-- 
if(isNull _ctrlParent OR isNull _control) exitWith {
	false
};

//-- Check selected index against list to make sure we don't hit out of bounds exception
if(_selectedIndex < 0 OR _selectedIndex > ((lbSize _control)-1))exitWith{
	hint format["Error: invalid index(%1) out of bounds! expected between (0 AND %2) ",_selectedIndex,(lbSize _control)-1];
	false
};

private _selectedItem = _control lbData _selectedIndex;

_playerListCombo ctrlEnable (count _nearPlayerList > 0);
  
switch _selectedItem do 
{
	case "Cash": 
	{ 
		_amountEditbox ctrlEnable (MONEY_CASH > 0);
		_dropButton ctrlEnable (ctrlEnabled _amountEditbox);
		_giveButton ctrlEnable (ctrlEnabled _amountEditbox AND ctrlEnabled _playerListCombo);
	};
	//case "Bank": { };
	//case "Gang": { };
	//case "Debt": { };
	default
	{ 
		_amountEditbox ctrlEnable false;
		_dropButton ctrlEnable false;
		_giveButton ctrlEnable false;
	};
};

true