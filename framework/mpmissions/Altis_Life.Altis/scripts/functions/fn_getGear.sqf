#include "..\..\script_macros.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

params [
	["_player",objNull,[objNull]],
	["_owned",true,[false]],
	["_displayNames",false,[false]],
	["_configNames",false,[false]]
];

private _vitems = [];
private _cfgVitems = missionConfigFile >> "cfgVirtualItems";

for "_currentIndex" from 0 to (count(_cfgVitems) - 1) do {
	private _currentItem = _cfgVitems select _currentIndex;
	private _currentItemName = configName _currentItem;
	private _item = format ["life_inv_%1",getText(missionConfigFile >> "cfgVirtualItems" >> _currentItemName >> "variable")];
    private _count = missionNamespace getVariable [_item,0];
	if _owned then {
		if (_count > 0) then {
			if _configNames then{
				_vitems pushBackUnique _currentItemName;
			}else{
				_vitems pushBackUnique [[_item, localize getText(_cfgVitems >> _currentItemName >> "displayName")]select _displayNames,_count];
			};
		};
	}else{
		if _configNames then{
			_vitems pushBackUnique _currentItemName;
		}else{
			_vitems pushBackUnique [[_item, localize getText(_cfgVitems >> _currentItemName >> "displayName")]select _displayNames,0];
		};
	};
};

[getUnitLoadout _player,_vitems]