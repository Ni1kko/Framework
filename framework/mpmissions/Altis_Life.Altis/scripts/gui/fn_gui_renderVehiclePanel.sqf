/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

disableSerialization;
if (diag_tickTime - life_var_hud_lastvehrendered_at >= 0.1) then{
	life_var_hud_lastvehrendered_at = diag_tickTime;
	private _display = uiNamespace getVariable "RscDisplayPlayerHUD";
	private _vehiclePanelControl = _display displayCtrl 1200;
	private _vehicle = vehicle player;
	private _showVehiclePanel = false;
	private _showHeight = true;
	private _showSpeed = true;
	private _showFuel = true;
	private _showDriverAmmo = true; 
	if !(_vehicle isEqualTo player) then {
		private _vehicleRole = assignedVehicleRole player;
		if (toLower (_vehicleRole select 0) isEqualTo "driver") then {
			_showVehiclePanel = true;
			switch (true) do {
				case (_vehicle isKindOf "Bicycle"): {
					_showFuel = false;
					_showDriverAmmo = false;
					_showHeight = false;
				};
				case (_vehicle isKindOf "ParachuteBase"):{
					_showFuel = false;
					_showDriverAmmo = false;
				};
				case (_vehicle isKindOf "StaticWeapon"):{
					_showVehiclePanel = false; 
				};
				case (_vehicle isKindOf "Rubber_duck_base_F"),
				case (_vehicle isKindOf "Boat_Civil_01_base_F"),
				case (_vehicle isKindOf "LandVehicle"):{
					_showHeight = false; 
				};
			};
		};
	};
	if !(_showVehiclePanel) then {
		if (ctrlShown _vehiclePanelControl) then {
			_vehiclePanelControl ctrlShow false;
		};
	} else {
		private _fuelControl = _display displayCtrl 1204;
		private _speedControl = _display displayCtrl 1202;
		private _heightControl = _display displayCtrl 1203;
		if !(ctrlShown _vehiclePanelControl) then{
			_vehiclePanelControl ctrlShow true;
			_speedControl ctrlShow _showSpeed;
			_heightControl ctrlShow _showHeight;
			_fuelControl ctrlShow _showFuel;
		};
		if (_showSpeed) then{
			private _speed = round (speed _vehicle);
			if (_speed isEqualTo -0) then{
				_speed = 0;
			};
			_speedControl ctrlSetText (str _speed);
		};
		if (_showHeight) then{
			private _height = ceil ((getPos _vehicle) select 2);
			if (_height isEqualTo -0) then {
				_height = 0;
			};
			private _heightString = str (round _height);
			if (_height > 999) then{
				_heightString = format ["%1k", [_height / 1000, 2] call MPClient_fnc_util_math_round];
			};
			_heightControl ctrlSetText (format ["%1m", _heightString]);		
		};
		if (_showFuel) then{
			private _vehicleClassName = typeOf _vehicle;
			if !(_vehicleClassName isEqualTo life_var_hud_lastrendered_vehclassname) then{
				life_var_hud_lastrendered_vehfueltanksize = getNumber(configFile >> "CfgVehicles" >> _vehicleClassName >> "fuelCapacity"); 
				life_var_hud_lastrendered_vehclassname = _vehicleClassName;
			};
			private _fuel = fuel _vehicle;
			if (_fuel > 0.25) then{
				_fuelControl ctrlSetTextColor [111/255, 113/255, 122/255, 1];
			}else{
				_fuelControl ctrlSetTextColor [221/255, 38/255, 38/255, 1];
			};	
			private _tankSize = life_var_hud_lastrendered_vehfueltanksize;
			private _tankSizeString = str (round _tankSize);
			if (_tankSize > 999) then{
				_tankSizeString = format ["%1k", [_tankSize / 1000, 2] call MPClient_fnc_util_math_round];
			};
			private _fuelRemaining = _fuel * life_var_hud_lastrendered_vehfueltanksize;
			private _fuelRemainingString = str (round _fuelRemaining);
			if (_fuelRemaining > 999) then{
				_fuelRemainingString = format ["%1k", [_fuelRemaining / 1000, 2] call MPClient_fnc_util_math_round];
			};
			_fuelControl ctrlSetText format ["%1/%2l", _fuelRemainingString, _tankSizeString];
		};
	};
};