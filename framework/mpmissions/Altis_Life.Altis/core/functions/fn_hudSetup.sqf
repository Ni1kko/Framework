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
private _alive = life_is_alive;
private _thirst = life_thirst;
private _hunger = life_hunger;

while {true} do 
{
    if (isNull LIFEdisplay) then {
        cutRsc ["playerHUD", "PLAIN", 2, false];
    };

    LIFEctrl(2200) progressSetPosition (_hunger / 100);
    LIFEctrl(2201) progressSetPosition ([0,(1 - _damage)] select _alive);
    LIFEctrl(2202) progressSetPosition (_thirst / 100);

    waitUntil {
        _damage isNotEqualTo (damage player)
        OR 
        _alive isNotEqualTo life_is_alive
        OR
        _thirst isNotEqualTo life_thirst
        OR
        _hunger isNotEqualTo life_hunger
    };
    
    _damage = damage player;
    _alive = life_is_alive;
    _thirst = life_thirst;
    _hunger = life_hunger;
};  
