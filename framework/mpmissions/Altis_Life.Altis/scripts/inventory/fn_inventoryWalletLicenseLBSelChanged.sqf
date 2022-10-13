#include "..\..\clientDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
	## fn_inventoryWalletLicenseLBSelChanged.sqf
*/

disableSerialization;

params [
	["_control", controlNull, [controlNull]],
	["_selectedIndex", -1, [0]],
	["_selectedIndexs", [], [[]]]
];

hint format ["fn_inventoryWalletLicenseLBSelChanged\n%1", str _this];

private _ctrlParent = ctrlParent _control;
private _dropButton = _ctrlParent displayCtrl INVENTORY_IDC_DROP; 
private _playerListCombo = _ctrlParent displayCtrl INVENTORY_IDC_COMBOPLAYERS;
private _giveButton = _ctrlParent displayCtrl INVENTORY_IDC_GIVE;
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


_dropButton ctrlEnable true;
{_x ctrlEnable (count _nearPlayerList > 0)}forEach [
	_playerListCombo,
	_giveButton
];

switch (toLower _selectedItem) do 
{ 
	case "driver": { }; 
	case "boat": { };  
	case "pilot": { };
	case "trucking": { };
	case "gun": { };
	case "dive": { };
	case "home": { };
	case "bountyhunter": { };
	case "rebel": { };
	case "oil": { };
	case "diamond": { };
	case "salt": { };
	case "sand": { };
	case "iron": { };
	case "copper": { };
	case "cement": { };
	case "cocaine": { };
	case "heroin": { };
	case "marijuana": { };
	case "medmarijuana": { };
	case "cAir": { };
	case "cg": { };
	case "mAir": { };
	default { };
};

true