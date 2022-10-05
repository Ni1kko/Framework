#include "..\..\script_macros.hpp"
/*
    File: fn_onTakeItem.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Blocks the unit from taking something they should not have.
*/
private ["_unit","_item","_restrictedClothing","_restrictedWeapons"];
_unit = [_this,0,objNull,[objNull]] call BIS_fnc_param;
_container = [_this,1,objNull,[objNull]] call BIS_fnc_param;
_item = [_this,2,"",[""]] call BIS_fnc_param;

if (isNull _unit || _item isEqualTo "") exitWith {}; //Bad thingies?
_restrictedClothing = CFG_MASTER(getArray,"restricted_uniforms");
_restrictedWeapons = CFG_MASTER(getArray,"restricted_weapons");

switch (playerSide) do
{
    case civilian:
    {
        if (CFG_MASTER(getNumber,"restrict_clothingPickup") isEqualTo 1) then {
            if (_item in _restrictedClothing) then {
                [_item,false,false,false,false] call MPClient_fnc_handleItem;
            };
        };
        if (CFG_MASTER(getNumber,"restrict_weaponPickup") isEqualTo 1) then {
            if (_item in _restrictedWeapons) then {
                [_item,false,false,false,false] call MPClient_fnc_handleItem;
            };
        };
    };
    case independent: 
    {
        // -- Restrict Weapons
        if (CFG_MASTER(getNumber,"restrict_medic_weapons") isEqualTo 1) then {
            // -- Check if the type is a weapon
            if (isClass (configFile >> "CfgWeapons" >> _item)) then { 
                // -- Remove all weapons from player (_unit)
                removeAllWeapons _unit;
            };
        };
    };
};
