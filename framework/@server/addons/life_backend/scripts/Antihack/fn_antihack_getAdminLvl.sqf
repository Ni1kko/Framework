#include "\life_backend\script_macros.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

params [
	["_input","",[""]]
];

private _lvl = 0;
private _admins = call MPServer_fnc_antihack_getAdmins;

{
	if(_input isEqualTo _x#1 OR _input isEqualTo _x#2)exitWith{
		_lvl = _x#0;
	};
}forEach _admins;

_lvl