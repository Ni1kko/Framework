/*
     File: fn_checkMap.sqf
     Author: DomT602
     Description:
     Checks if the map is being opened or closed, then puts markers according to side.
 */

 params [
     ["_mapOpen",false,[false]]
 ];

 if (_mapOpen) then {
    switch playerSide do {
        case west: {[] spawn MPClient_fnc_copMarkers};
        case independent: {[] spawn MPClient_fnc_medicMarkers};
        case civilian: {[] spawn MPClient_fnc_civMarkers};
    };
 } else {
    life_var_markers_active = false;
 };
