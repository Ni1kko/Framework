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
private _animalTypes = missionNamespace getVariable ["life_var_animalTypes",[]];

//-- No animal types found, exit
if(count _animalTypes isEqualTo 0) exitWith {_animals};

//-- Make sure animal is not used by another system
if not(_getAllDefined) then { 
	if not(isNil "life_var_animalTypesRestricted")then{
		private _animalTypesRestricted = life_var_animalTypesRestricted  apply {toLower _x};
		{if(toLower _x in _animalTypesRestricted)then{_animalTypes deleteAt _forEachIndex}}ForEach _animalTypes;
	};
};

//-- Get all animal mathing given type(s)
{
	private _animal = agent _x;
	if(KIND_OF_ARRAY(_animal, _animalTypes)) then {_animals pushBackUnique _animal};
}forEach agents;

_animals