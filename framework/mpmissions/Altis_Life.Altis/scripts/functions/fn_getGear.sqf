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
private _cfgVitems = missionConfigFile >> "VirtualItems";

for "_currentIndex" from 0 to (count(_cfgVitems) - 1) do {
	private _currentItem = _cfgVitems select _currentIndex;
	private _currentItemName = configName _currentItem;
	private _item = format ["life_inv_%1",getText(missionConfigFile >> "VirtualItems" >> _currentItemName >> "variable")];
    private _count = missionNamespace getVariable [_item,0];
	if _owned then {
		if (_count > 0) then {
			_vitems pushBackUnique [_currentItemName,_count];
		};
	}else{
		_vitems pushBackUnique [_currentItemName,0];
	};
};

[getUnitLoadout _player,_vitems]