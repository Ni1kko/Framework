#include "..\..\script_macros.hpp"
/*
    File: fn_revealObjects.sqf
    Author: Ni1kko
    
    Description:
    Reveals nearest objects within X amount of meters automatically to help with picking
    up various static objects on the ground such as money, water, etc.
    
    Can be taxing on low-end systems or AMD CPU users.
*/

if (!life_settings_revealObjects) exitWith {};

private _reveal = {
    params[
        ["_objects",[],[[]]],
        ["_player",player]
    ];
    
    if(count _objects < 1)exitWith {false};

    private _group = (group _player);

    {
        if(_group isEqualTo (objNull))then{
            _player reveal _x;
        }else{
            _group reveal _x;
        };
        
    } forEach _objects;

    true
};

private _cacheReveal = [false]; 

//--- Cache object array
if(!isFinal CACHE_VAR)then
{
    private _cache = [
        "Land_CargoBox_V1_F",
        "CAManBase"
    ];

    {_cache pushBackUnique _x}forEach (("true" configClasses (missionConfigFile >> "VirtualItems")) apply {ITEM_OBJECT(configName _x)});

    missionNamespace setVariable [CACHE_VAR, compileFinal str _cache];
};

//--- Cache player position
private _cachePos = missionNamespace getVariable [CACHE_POS_VAR, [0,0,0]];
private _playerPos = visiblePositionASL player;
if(_cachePos distance2D _playerPos >= (REVEAL_DISTANCE / 2))then
{
    missionNamespace setVariable [CACHE_POS_VAR, _playerPos];
    private _cache = missionNamespace getVariable [CACHE_VAR, {[]}];
    private _objects2Reveal = (
        nearestObjects[
            _playerPos, 
            call _cache, 
            REVEAL_DISTANCE
        ]
    );

    //--- Cache near objects
    private _cache2 = missionNamespace getVariable [CACHE2_VAR, []];
    if(_cache2 isNotEqualTo _objects2Reveal)then{
        _cacheReveal = [true] + _objects2Reveal;
        missionNamespace setVariable [CACHE2_VAR, _objects2Reveal];
    };
};

if(_cacheReveal#0)then{
    [(_cacheReveal - [true]), player] call _reveal;
};
