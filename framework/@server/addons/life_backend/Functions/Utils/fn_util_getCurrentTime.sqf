/*
	## Nikko Renolds
	## https://github.com/Ni1kko/Framework
*/

private _GMT = true;
systemTimeUTC params ["_year","_month","_day","_hour","_minute","_second"]; 

if _GMT then {
	_hour = _hour + 1;
};

private _curtime = parseNumber format["%1%2",_hour,_minute];

_curtime