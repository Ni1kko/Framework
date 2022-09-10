#include "..\..\script_macros.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

params [
	["_player",objNull,[objNull]],
	["_owned",true,[false]]
];

private _vitems = [];

{
    private _item = format ["life_inv_%1",getText(missionConfigFile >> "VirtualItems" >> _x >> "variable")];
    private _count = missionNamespace getVariable [_item,0];
	if _owned then {
		if (_count > 0) then {
			_vitems pushBackUnique [_x,_count];
		};
	}else{
		_vitems pushBackUnique [_x,0];
	};
} forEach getArray(missionConfigFile >> "Life_Settings" >> "saved_virtualItems");

[getUnitLoadout _player,_vitems]