#include "..\..\script_macros.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

params [
	["_player",objNull,[objNull]],
	["_owned",true,[false]],
	["_displayNames",false,[false]],
	["_configNames",false,[false]]
];

private _sideflag = [side _player,true] call MPServer_fnc_util_getSideString;
private _licenses = [];
 
{
	private _value = LICENSE_VALUE(configName _x,_sideflag);
	private _license = [
		LICENSE_VARNAME(configName _x,_sideflag), 
		LICENSE_DISPLAYNAME(configName _x,_sideflag)
	] select _displayNames;
	
	if _owned then {
		if _value then {
			if _configNames then {
				_licenses pushBackUnique (configName _x);
			}else{
				_licenses pushBackUnique [_license,true];
			};
		};
	}else{
		if _configNames then {
			_licenses pushBackUnique (configName _x);
		}else{
			_licenses pushBackUnique [_license,false];
		};
	};
}forEach (format ["getText(_x >> 'side') isEqualTo '%1'",_sideflag] configClasses (missionConfigFile >> "cfgLicenses"));

_licenses