#include "..\..\script_macros.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

params [
	["_player",objNull,[objNull]],
	["_ownedOnly",true,[false]],
	["_useDisplayNames",false,[false]],
	["_useConfigNames",false,[false]],
	["_sideOnly",true,[false]]
];

private _cfgLicenses = missionConfigFile >> "CfgLicenses";
private _sideflagActual = [side _player,true] call (missionNamespace getvariable ["MPServer_fnc_util_getSideString",{}]);
private _licenses = [];

//-- preInit loads before server is ready, so we force get all sides
if (isNil {_sideflagActual})then{
	_sideOnly = false;
	_sideflagActual = "Undefined";
};

{
	private _classname = configName _x;
	private _sideflag = [getText(_cfgLicenses >> _classname >> "side"),_sideflagActual]select _sideOnly;
	private _license = [LICENSE_VARNAME(_classname,_sideflag),LICENSE_DISPLAYNAME(_classname)] select _useDisplayNames;
	
	if _ownedOnly then {
		if (LICENSE_VALUE(_classname,_sideflag)) then {
			if _useConfigNames then {
				_licenses pushBackUnique _classname;
			}else{
				_licenses pushBackUnique [_license,true];
			};
		};
	}else{
		if _useConfigNames then {
			_licenses pushBackUnique _classname;
		}else{
			_licenses pushBackUnique [_license,false];
		};
	};
}forEach ("true" configClasses _cfgLicenses);

_licenses