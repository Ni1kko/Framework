#include "\life_backend\script_macros.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

private _GMT = getNumber(configFile >> "CfgUtils" >> "useGMTtime") isEqualTo 1;
systemTimeUTC params ["_year","_month","_day","_hour","_minute","_second"]; 

if _GMT then {
	_hour = _hour + 1;

	if(_hour > 23 || _hour < 0) then {
		_hour = 0;
	};
};

private _curtime = parseNumber format["%1%2",_hour,_minute];

_curtime