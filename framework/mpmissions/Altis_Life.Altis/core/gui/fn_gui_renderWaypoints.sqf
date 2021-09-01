/*
	## Nikko Renolds
	## https://github.com/Ni1kko/Framework
*/

if !(life_var_hud_waypoints isEqualTo []) then {
	{
		private _distance = player distance2D _x;
		drawIcon3D  [
			"\a3\ui_f\data\Map\MapControl\custommark_CA.paa",
			[1, 1, 1, linearConversion [0, 200, _distance, 0.25, 1, true]],
			_x,
			0.65,
			0.65,
			0,
			format ["%1m", floor _distance],
			0,
			0.03,
			"PuristaMedium",
			"center",
			true
		];
	} forEach life_var_hud_waypoints;
};