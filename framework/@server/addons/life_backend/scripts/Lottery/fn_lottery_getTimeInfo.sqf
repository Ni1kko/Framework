#include "\life_backend\script_macros.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

private _timeRemaining = INFINTE;
private _configIndex = -1;
private _config = call life_var_lotto_config;
private _ticketDrawTimes = _config param [5,[]];

{
	private _timeString = _x;
	private _tempTime = [_timeString] call MPServer_fnc_util_getRemainingTime;

	if(_tempTime isNotEqualTo -1) then {
		_timeRemaining =  _tempTime;
		_configIndex = _forEachIndex;
	};
}forEach _ticketDrawTimes;

[_timeRemaining,_configIndex,_configIndex isNotEqualTo -1]