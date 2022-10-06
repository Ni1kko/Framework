#include "..\..\clientDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
    ## fn_setLicenses.sqf
*/

params [
	["_player",objNull,[objNull]],
	["_licenses",[],[[]]],
	["_forceUpdate",true,[false]]
];

if(isNull _player) exitWith {life_var_licenses};

//-- Get all licenses avalible to player (Used for developers to give all faction licenses)
if (count _licenses isEqualTo 0) then {
    _licenses = [_player,false,false,false,true] call MPClient_fnc_getLicenses;
};

//-- Set licenses
{
    _x params [["_name","",[""]],["_state",false,[false]]];
    [_player, _name, _state, false] call MPClient_fnc_setLicense;
} forEach _licenses;

//-- Sync to database
if _forceUpdate then {
	[2] call MPClient_fnc_updatePlayerDataPartial;
};

life_var_licenses