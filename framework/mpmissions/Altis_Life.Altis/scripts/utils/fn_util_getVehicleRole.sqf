/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

private _unit = _this;
private _crew = fullCrew (vehicle _unit);
private _role = "";

if !(_crew isEqualTo []) then{
	{
		if ((_x select 0) isEqualTo _unit) exitWith{
			_role = toLower (_x select 1);
		};
	} forEach _crew;
};

_role