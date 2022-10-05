#include "..\..\script_macros.hpp"
/*
    File: fn_dropItems.sqf
    Author: Tonic & Ni1kko

    Description:
    Called on death, player drops any 'virtual' items they may be carrying.
*/

params [
    ["_unit",objNull]
];

{
    private _item = (if(_x isEqualType "")then{_x}else{configName _x});
    private _itemValue = ITEM_VALUE(_item);
    [_unit,_item,_itemValue] call MPClient_fnc_dropItem;
} forEach ("true" configClasses (missionConfigFile >> "cfgVirtualItems"));


life_var_carryWeight = 0;

true