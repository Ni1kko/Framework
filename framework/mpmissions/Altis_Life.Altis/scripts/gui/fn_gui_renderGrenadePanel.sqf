/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

disableSerialization;
private _display = uiNameSpace getVariable ["RscTitleHUD", displayNull];  
private _panelControl = _display displayCtrl 1400;
private _currentThrowable = currentThrowable player;
private _showGrenadePanel = false;
private _grenadeClassName = "";
if !(_currentThrowable isEqualTo []) then {
	if ((vehicle player) isEqualTo player) then {
		_grenadeClassName = _currentThrowable select 0;
		if !(_grenadeClassName isEqualTo "") then {
			_showGrenadePanel = true;
		};
	};
};
if !(_showGrenadePanel) then {
	if (ctrlShown _panelControl) then {
		_panelControl ctrlShow false;
	};
} else  {
	if (!ctrlShown _panelControl) then {
		_panelControl ctrlShow true;
		life_var_hud_lastrendered_grenadeclassname = "";
	};
	private _grenadeAmmo = { _x isEqualTo _grenadeClassName } count (magazines player);
	private _ammoControl = _display displayCtrl 1402;  
	_ammoControl ctrlSetText (str _grenadeAmmo);
	if !(_grenadeClassName isEqualTo life_var_hud_lastrendered_grenadeclassname) then {
		private _nameLines = getArray (configFile >> "RscTitleHUD" >> "ShortItemNames" >> _grenadeClassName);
		private _single = _display displayCtrl 1403;  
		private _double1 = _display displayCtrl 1404;  
		private _double2 = _display displayCtrl 1405;  
		switch (count _nameLines) do  {
			case 1: {
				_single ctrlSetText (_nameLines select 0);
				_single ctrlShow true;
				_double1 ctrlShow false;
				_double2 ctrlShow false;
			};
			case 2:  {
				_single ctrlShow false;
				_double1 ctrlSetText (_nameLines select 0);
				_double1 ctrlShow true;
				_double2 ctrlSetText (_nameLines select 1);
				_double2 ctrlShow true;
			};
			default {
				_single ctrlShow false;
				_double1 ctrlShow false;
				_double2 ctrlShow false;
			};
		};
		life_var_hud_lastrendered_grenadeclassname = _grenadeClassName;
	};
};