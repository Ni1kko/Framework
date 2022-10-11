#include "..\..\clientDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
	## fn_inventoryVirtualPlayersComboSelChanged.sqf
*/

disableSerialization;

params [
	["_control", controlNull, [controlNull]],
	["_selectedIndex", -1, [0]],
	["_selectedIndexs", [], [[]]]
];

hint format ["fn_inventoryVirtualPlayersComboSelChanged\n%1", str _this];

private _ctrlParent = ctrlParent _control;
private _confirmButton = _ctrlParent displayCtrl 77711;
private _nearPlayerList = _ctrlParent getVariable ["RscDisplayInventory_NearPlayerList", []];

//-- Disable button till we check selection
_confirmButton ctrlEnable false;

//-- Its loney here...
if(count _nearPlayerList isEqualTo 0)exitWith{
	hint "No players nearby";
	false
};

//-- Check selected index against list to make sure we don't hit out of bounds exception
if(_selectedIndex < 0 OR _selectedIndex > ((count _nearPlayerList)-1))exitWith{
	hint format["Error: invalid index(%1) out of bounds! expected between (0 AND %2) ",_selectedIndex,(count _nearPlayerList)-1];
	false
};

//-- Get player from list
private _selectedPlayer = _nearPlayerList param [_selectedIndex, objNull, [objNull]];
if(isNull _selectedPlayer)exitWith{
	hint "Error: <OBJECT-NULL>";
	false
};

//-- All seems good enable button again
_confirmButton ctrlEnable (isPlayer _selectedPlayer);

true