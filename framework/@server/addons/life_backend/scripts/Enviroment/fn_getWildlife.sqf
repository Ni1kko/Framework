#include "\life_backend\serverDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
	## fn_getWildlife.sqf
*/
params [
	["_getAllDefined", false, [true]]
];

private _animals = []; 
private _animalTypes = localNamespace getVariable ["MPServer_var_animalTypes",[]];

//-- No animal types found, exit
if(count _animalTypes isEqualTo 0) exitWith {_animals};

//-- Make sure animal is not used by another system
if (not(_getAllDefined)) then {
	{
		private _animaltypes_fishing = (CFG_MASTER(getArray,"animaltypes_fish")) apply {toLower _x};
		private _animaltypes_hunting = (CFG_MASTER(getArray,"animaltypes_hunting")) apply {toLower _x};
		private _animaltypes_ambient = (getArray(configFile >> "CfgEnviroment" >> "wildLife")) apply {toLower _x};

		if(_x in _animaltypes_fishing OR _x in _animaltypes_hunting OR _x in _animaltypes_ambient)then{
			_animalTypes deleteAt _forEachIndex;
		};
	}ForEach (_animalTypes apply {toLower _x});
};

//-- Get all animal mathing given type(s)
{
	private _animal = agent _x;
	if(KIND_OF_ARRAY(_animal, _animalTypes)) then {_animals pushBackUnique _animal};
}forEach agents;

_animals