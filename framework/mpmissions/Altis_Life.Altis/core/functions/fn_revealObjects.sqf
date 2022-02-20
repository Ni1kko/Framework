#include "..\..\script_macros.hpp"
/*
    File: fn_revealObjects.sqf
    Author: Tonic & Ni1kko
    
    Description:
    Reveals nearest objects within X amount of meters automatically to help with picking
    up various static objects on the ground such as money, water, etc.
    
    Can be taxing on low-end systems or AMD CPU users.
*/

if (!life_settings_revealObjects) exitWith {};

//--- Cache object array
private _cacheVar = "Life_var_revealObjectsCache";
private _cache = call(missionNamespace getVariable [_cacheVar, {[]}]);
if(count(_cache) <= 0)then
{
    _cache = [
        "Land_CargoBox_V1_F",
        "CAManBase"
    ];

    {_cache pushBackUnique _x}forEach ("true" configClasses (missionConfigFile >> "VirtualItems")) apply {
        private _item = (if(_x isEqualType "")then{_x}else{configName _x});
        private _itemObject = ITEM_OBJECT(_item);
        _itemObject
    };

    missionNamespace setVariable [_cacheVar, compileFinal str _cache];
};

//--- Cache player position
private _cachePos = missionNamespace getVariable [format["%1_pos",_cacheVar], [0,0,0]];
private _playerPos = visiblePositionASL player;
if(_cachePos distance2D _playerPos >= (REVEAL_DISTANCE / 2))then
{
    {
        player reveal _x;
        (group player) reveal _x;
    } forEach (nearestObjects[_playerPos, _cache, REVEAL_DISTANCE]);

    missionNamespace setVariable [format["%1_pos",_cacheVar], _playerPos];
};
