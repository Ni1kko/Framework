/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

private _player = param [0,player,[objNull]];

_player addEventHandler ["Killed", {_this call MPClient_fnc_onPlayerKilled}];
_player addEventHandler ["HandleDamage", {_this call MPClient_fnc_handleDamage}];
_player addEventHandler ["USE", {_this call MPClient_fnc_onTakeItem}];
_player addEventHandler ["Fired", {_this call MPClient_fnc_onFired}];
_player addEventHandler ["InventoryClosed", {_this call MPClient_fnc_inventoryClosed}];
_player addEventHandler ["InventoryOpened", {_this call MPClient_fnc_inventoryOpened}];
_player addEventHandler ["HandleRating", {0}];


if(isNil "life_var_mapEVH")then{
    life_var_mapEVH = addMissionEventHandler ["Map", {_this call MPClient_fnc_checkMap}];
};
