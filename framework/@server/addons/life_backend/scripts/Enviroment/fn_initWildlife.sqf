#include "\life_backend\serverDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
	## fn_initWildlife.sqf
*/

private _maxDistance = param [0, 75]; // Max distance from the radius of marker to delete spawned animals
private _wildLifeArray = getArray(configFile >> "CfgEnviroment" >> "wildLife");

if(count _wildLifeArray isEqualTo 0)exitWith{false};

if(_maxDistance < 5) then {
	_maxDistance = 5;
};

{ 
    _x params [
        "_type",
        "_markerName",
        "_animalCount"
    ];

    private _pos = getMarkerPos _markerName;
    private _radius = (getMarkerSize _markerName) param [0, 0];
    private _unitsNear = ({((_x distance _pos) < (_radius + _maxDistance))} count playableUnits) > 0;
    private _animalsActive = ({alive (agent _x)} count life_var_spawndAnimals) > 0;
    private _shouldSpawn = _unitsNear AND not(_animalsActive);
    
    switch _shouldSpawn do {
        case true: {[_type,_pos,_radius,_animalCount] call MPServer_fnc_createWildlife};
        case false: {[life_var_spawndAnimals] call MPServer_fnc_deleteWildlife};
    };
}forEach _wildLifeArray;

//-- Delete null object(s) from array
{
    private _animal = _x;
    if(typeName _animal isNotEqualTo "OBJECT")then{_animal = agent _animal};
    if(isNull _animal) then {life_var_spawndAnimals deleteAt _forEachIndex};
} forEach life_var_spawndAnimals

true