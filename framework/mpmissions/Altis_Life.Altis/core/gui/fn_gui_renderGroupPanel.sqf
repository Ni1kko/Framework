/*
	## Nikko Renolds
	## https://github.com/Ni1kko/Framework
*/

disableSerialization;
if (diag_tickTime - life_var_hud_lastgrprendered_at >= 1) then
{
	life_var_hud_lastgrprendered_at = diag_tickTime;
	private _display = uiNamespace getVariable "RscPlayerHUD";
	private _groupControl = _display displayCtrl 1000;
	if (((group player) getVariable ["gang_id",-1]) <= 0) then {
		if (ctrlShown _groupControl) then {
			_groupControl ctrlShow false;
		};
	} else {
		if !(ctrlShown _groupControl) then {
			_groupControl ctrlShow true;
		};
		private _lines = "";
		{
			if (isPlayer _x) then  {
				private _color = switch (true) do {
					case ((damage _x) < 0.1): { "#c0b9ff4b" };
					case ((damage _x) < 0.5): { "#c0ffac4b" };
					default 				  { "#c0d20707" };
				};
				if ((vehicle _x) isEqualTo _x) then {
					_lines = _lines + format ["<t color='%1'>%2</t><br/>", _color, name _x];
				} else {
					private _role = _x call life_fnc_util_getVehicleRole;
					switch (_role) do {
						case "driver": {
							_lines = _lines + format ["<t color='%1'>%2 <img image='textures\hud\hud_group_driver.paa'/></t><br/>", _color, name _x];
						};
						case "gunner": {
							_lines = _lines + format ["<t color='%1'>%2 <img image='textures\hud\hud_group_gunner.paa'/></t><br/>", _color, name _x];
						};
						case "commander": {
							_lines = _lines + format ["<t color='%1'>%2 <img image='textures\hud\hud_group_commander.paa'/></t><br/>", _color, name _x];
						};
						default  {
							_lines = _lines + format ["<t color='%1'>%2 <img image='textures\hud\hud_group_passenger.paa'/></t><br/>", _color, name _x];
						};
					};
				};
			};
		} forEach (units (group player));
		_lines = "<t shadow='0' size='0.8'>" + _lines + "</t>";
		_groupControl ctrlSetStructuredText (parseText _lines);
	};
};