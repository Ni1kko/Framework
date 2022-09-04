/*
    File: fn_setupEVH.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Master eventhandler file
*/
params {
["_player", player, [objnull]]
};

_player addEventHandler ["Killed", {_this call life_fnc_onPlayerKilled}];
_player addEventHandler ["HandleDamage", {_this call life_fnc_handleDamage}];
_player addEventHandler ["Take", {_this call life_fnc_onTakeItem}];
_player addEventHandler ["Fired", {_this call life_fnc_onFired}];
_player addEventHandler ["InventoryClosed", {_this call life_fnc_inventoryClosed}];
_player addEventHandler ["InventoryOpened", {_this call life_fnc_inventoryOpened}];
_player addEventHandler ["HandleRating", {0}];


if(isNil "life_var_mapEVH")then{
    life_var_mapEVH = addMissionEventHandler ["Map", {_this call life_fnc_checkMap}];
};
