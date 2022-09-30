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
private _sideflagActual = [side _player,true] call (missionNamespace getvariable ["MPServer_fnc_util_getSideString",{"Undefined"}]);
private _alliLcenses = missionNamespace getVariable ["MPClient_var_licenses",createHashMap];
private _licenses = [];

//-- preInit loads before server is ready, so we force get all sides
if (_sideflagActual isEqualTo "Undefined")then{
	_sideOnly = false;
};

{
	private _classname = configName _x;
	private _sideflag = [getText(_cfgLicenses >> _classname >> "side"),_sideflagActual]select _sideOnly;
	private _varname = LICENSE_VARNAME(_classname,_sideflag);

	private _licenseData = _alliLcenses getOrDefault [_varname,createHashMapFromArray [
		["Name", _varname],
		["State", false]
	]];

	private _altName = switch (true) do {
		case _useDisplayNames: {LICENSE_DISPLAYNAME(_classname)};
		case _useConfigNames: {_classname}; 
		default {_varname};
	};
	
	if _ownedOnly then {
		if((_licenseData getOrDefault ["State", false]) OR LICENSE_VALUE(_classname,_sideflag))then{
			_licenses pushBackUnique ([[_licenseData get "Name" ,true], _altName] select (_useDisplayNames OR _useConfigNames));
		};
	}else{
		_licenses pushBackUnique ([[_licenseData get "Name",false], _altName] select (_useDisplayNames OR _useConfigNames));
	};

}forEach ("true" configClasses _cfgLicenses);

_licenses