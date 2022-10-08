#include "..\..\clientDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
	## fn_inventoryShow.sqf
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

//-- Open Inventory
createGearDialog [player,'RscDisplayInventory'];

//--
waitUntil { _ctrlParent = uiNamespace getVariable ["RscDisplayInventory",findDisplay 602]; not(isNull _ctrlParent)};

//-- Handle our controls
[_ctrlParent,true] call MPClient_fnc_inventoryRefresh;

true