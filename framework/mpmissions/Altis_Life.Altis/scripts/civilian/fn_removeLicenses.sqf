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
private _licenseFlag = [side _player,true] call MPServer_fnc_util_getSideString;

{
    private _license = LICENSE_VARNAME(_x,_licenseFlag);
    if(missionNamespace getVariable [_license,false])then{
        missionNamespace setVariable [_license,false];
        _hadLicense = true
    };
} forEach _licenses
 

if _hadLicense then {
    systemChat (_message call BIS_fnc_localize); 
};

//return
(_hadLicense AND count _licenses > 0)