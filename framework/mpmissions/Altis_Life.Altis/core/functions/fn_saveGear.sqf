/*
	## Nikko Renolds
	## https://github.com/Ni1kko/Framework
*/

private _virtualitems = if (getNumber(missionConfigFile >> "Life_Settings" >> "save_virtualItems") isEqualTo 1) then {
    private _temp = [];
    {
        private _val = missionNamespace getVariable [format ["life_inv_%1",getText(missionConfigFile >> "VirtualItems" >> _x >> "variable")],0];
        if (_val > 0) then {
            _temp pushBack [_x,_val];
        };
    } forEach getArray(missionConfigFile >> "Life_Settings" >> "saved_virtualItems");
    _temp
}else{
    []
};

life_var_loadout = getUnitLoadout player;
life_var_vitems = _virtualitems;