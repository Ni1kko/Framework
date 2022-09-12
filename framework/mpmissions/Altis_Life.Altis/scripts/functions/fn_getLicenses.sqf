#include "..\..\script_macros.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

params [
	["_player",objNull,[objNull]],
	["_owned",true,[false]]
];

private _sideflag = [side _player,true] call MPServer_fnc_util_getSideString;
private _licenses = [];
 
{
	private _value = LICENSE_VALUE(configName _x,_sideflag);
	private _license = LICENSE_VARNAME(configName _x,_sideflag);
	
	if _owned then {
		if _value then {
			_licenses pushBackUnique [_license,true];
		};
	}else{
		_licenses pushBackUnique [_license,false];
	};
}forEach (format ["getText(_x >> 'side') isEqualTo '%1'",_sideflag] configClasses (missionConfigFile >> "cfgLicenses"));

_licenses