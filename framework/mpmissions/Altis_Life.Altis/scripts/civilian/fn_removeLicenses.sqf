#include "..\..\script_macros.hpp"
/*
    File: fn_removeLicenses.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Used for stripping certain licenses off of civilians as punishment.
*/

params [
    ["_player",objNull,[objNull]],
    ["_licenses",[],[[]]],
    ["_message","",[""]]
];

if(count _licenses isEqualTo 0)exitWith{false};
private _hadLicense = false;

{
    if(LICENSE_VALUE(_x))then{
        TAKE_LICENSE(_x);
        _hadLicense = true
    };
} forEach _licenses
 

if _hadLicense then {
    systemChat (_message call BIS_fnc_localize); 
};

//return
_hadLicense