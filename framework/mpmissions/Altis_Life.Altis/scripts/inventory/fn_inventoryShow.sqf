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

[player,"bagopen",20] remoteExec ["MPClient_fnc_say3D",RE_CLIENT];

waitUntil {not(isNull (_ctrlParent displayCtrl 77712))};

//-- Handle our controls
[_ctrlParent,true] call MPClient_fnc_inventoryRefresh;

life_var_inventoryLoading = false;

//-- Handle player closing inventory
[_ctrlParent]spawn {
	scriptName 'MPClient_fnc_inventoryResetUser';
	
	params ["_ctrlParent"];

	//-- Once is enough
	if(_ctrlParent setVariable ["storageUserClearPending",false])exitWith{false};

	//-- Wait for the user to close the inventory
	waitUntil {isNull _ctrlParent};
	_ctrlParent setVariable ["storageUserClearPending",true,true];

	//-- Clear the storage user
	if((vehicle player) isNotEqualTo player)then{
		if(((vehicle player) getVariable ["storageUser",objNull]) isEqualTo player)then{ 
			(vehicle player) setVariable ["storageUser",objNull,true];
		};
	}else{
		if(not(isNull cursorObject))then{ 
			if((cursorObject getVariable ["storageUser",objNull]) isEqualTo player)then{ 
				cursorObject setVariable ["storageUser",objNull,true];
			};
		}else{
			private _otherTarget = player getVariable ["storageUserTarget",objNull];
			if(not(isNull _otherTarget))then{
				if((_otherTarget getVariable ["storageUser",objNull]) isEqualTo player)then{ 
					_otherTarget setVariable ["storageUser",objNull,true];
					player setVariable ["storageUserTarget",objNull,true];
				};
			};
		};
	};

	true
};

true