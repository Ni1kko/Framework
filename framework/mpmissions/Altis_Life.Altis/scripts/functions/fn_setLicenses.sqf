#include "..\..\script_macros.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

params [
	["_player",objNull,[objNull]],
	["_licenses",[],[[]]],
	["_forceUpdate",false,[false]]
];
 
if (count _licenses > 0) then 
{
    {
        _x params [
            ["_name","",[""]],
            ["_state",false,[false]]
        ];

        [_player, _name, _state, false] call MPClient_fnc_setLicense;
    } forEach _licenses;
};

//-- Sync to database
if _forceUpdate then{
	[2] call MPClient_fnc_updatePlayerDataPartial;
};

life_var_licenses