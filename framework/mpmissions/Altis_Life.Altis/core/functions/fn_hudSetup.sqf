#include "..\..\script_macros.hpp"
/*
    File:           fn_hudSetup.sqf
    Author:         Bryan "Tonic" Boardwine
    Edited on:      22.08.2021
    Edited by:      https://github.com/Ni1kko
    Description:    Keeps hud active and updated
*/
disableSerialization;

private _damage = damage player;
private _thirst = life_thirst;
private _hunger = life_hunger;

while {true} do 
{
    if (isNull LIFEdisplay) then {
        cutRsc ["playerHUD", "PLAIN", 2, false];
    };

    LIFEctrl(2200) progressSetPosition (_hunger / 100);
    LIFEctrl(2201) progressSetPosition (1 - _damage);
    LIFEctrl(2202) progressSetPosition (_thirst / 100);

    waitUntil {
        _damage isNotEqualTo (damage player)
        OR
        _thirst isNotEqualTo life_thirst
        OR
        _hunger isNotEqualTo life_hunger
    };
    
    _damage = damage player;
    _thirst = life_thirst;
    _hunger = life_hunger;
};  
