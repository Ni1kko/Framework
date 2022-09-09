/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

life_var_vitems = [];
life_var_loadout = getUnitLoadout player;

{
    private _item = format ["life_inv_%1",getText(missionConfigFile >> "VirtualItems" >> _x >> "variable")];
    private _count = missionNamespace getVariable [_item,0];
    if (_count > 0) then {life_var_vitems pushBack [_x,_count]};
} forEach getArray(missionConfigFile >> "Life_Settings" >> "saved_virtualItems");

_loadout