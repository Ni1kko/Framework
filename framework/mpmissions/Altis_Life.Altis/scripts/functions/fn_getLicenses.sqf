#include "..\..\clientDefines.hpp"
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
private _sideflagActual = [side _player,true] call (missionNamespace getvariable ["MPServer_fnc_util_getSideString",{""}]);
private _allLicenses = missionNamespace getVariable ["life_var_licenses",createHashMap];
private _licenses = [];

//-- preInit loads before server is ready, so we force get all sides
if (count _sideflagActual isEqualTo 0)then{
	_sideOnly = false;
};

{
	private _classname = configName _x;
	private _sideflag = [getText(_cfgLicenses >> _classname >> "side"),_sideflagActual]select _sideOnly;
	private _varname = LICENSE_VARNAME(_classname,_sideflag);

	private _licenseData = _allLicenses getOrDefault [_classname,createHashMapFromArray [
		["Name", _varname],
		["State", false]
	]];

	private _altName = switch (true) do {
		case _useDisplayNames: {LICENSE_DISPLAYNAME(_classname)};
		case _useConfigNames: {_classname}; 
		default {_varname};
	};
	
	if _ownedOnly then {
		private _name = _licenseData getOrDefault ["Name",_varname];
		private _state =_licenseData getOrDefault ["State", false];
		private _stateOLD = missionNamespace getVariable [_varname,false];

		if(_state OR _stateOLD)then{
			_licenses pushBackUnique ([[_name ,true], _altName] select (_useDisplayNames OR _useConfigNames));
		};
	}else{
		_licenses pushBackUnique ([[_licenseData get "Name",false], _altName] select (_useDisplayNames OR _useConfigNames));
	};

}forEach ("true" configClasses _cfgLicenses);

_licenses