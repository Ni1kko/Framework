#include "\life_backend\serverDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

private _timeString = param [0,""];
private _timeRemaining = INFINTE;
private _curtime = [] call MPServer_fnc_util_getCurrentTime;
private _selecttime = parseNumber ((_timeString splitString ":") joinString "");
private _timeDiffrenece = _selecttime - _curtime;
private _timeReached = false;
if(_timeDiffrenece >= 0 AND {_timeDiffrenece <= _timeRemaining}) then {
	_timeRemaining = _timeDiffrenece;
	_timeReached = true;
};

[-1, _timeRemaining] select _timeReached