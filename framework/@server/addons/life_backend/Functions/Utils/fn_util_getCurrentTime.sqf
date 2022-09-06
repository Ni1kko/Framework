/*
	## Nikko Renolds
	## https://github.com/Ni1kko/Framework
*/

systemTimeUTC params ["_year","_month","_day","_hour","_minute","_second"]; 

private _curtime = parseNumber format["%1%2",_hour,_minute];

_curtime