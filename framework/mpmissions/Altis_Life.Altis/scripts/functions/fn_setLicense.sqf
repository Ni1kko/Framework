#include "..\..\script_macros.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

params [
	["_player",objNull,[objNull]],
	["_licenseName","",[""]],
	["_licenseState",false,[false]],
	["_forceUpdate",true,[false]]
];

private _cfgLicenses = missionConfigFile >> "CfgLicenses";;
private _licenseData = life_var_licenses getOrDefault [_licenseName,createHashMapFromArray [
	["Name", _licenseName],
	["State", _licenseState]
]];

//-- is class name? if so convert to mission var
{
	private _classname = configName _x;
	private _sideflag = getText(_cfgLicenses >> _classname >> "side");
	
	if(_licenseName isEqualTo _classname)exitWith{
		_licenseName = LICENSE_VARNAME(_classname,_sideflag);
		_licenseData = life_var_licenses getOrDefault [_licenseName,createHashMapFromArray [
			["Name", _licenseName],
			["State", _licenseState]
		]];
	}; 
}forEach ("true" configClasses _cfgLicenses);

//-- Update hashMap
life_var_licenses set [_licenseData get "Name",_licenseData];

//-- TEMP (OLD system method)
missionNamespace setVariable [_licenseData get "Name",_licenseData get "State"];

//-- Sync to database
if _forceUpdate then{
	[2] call MPClient_fnc_updatePlayerDataPartial;
};

//-- return
_licenseData