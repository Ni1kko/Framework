#include "\life_backend\script_macros.hpp"
/*
	## Tonic & Ni1kko
	## https://github.com/Ni1kko/FrameworkV2

    ## Spawns animals around the marker when a player is near.
*/

private _unitsNear = false;
private _animalsActive = false;

{ 
    _x params [
        "_markerName",
        "_animalCount"
    ];

    private _markerSize = getMarkerSize _markerName;
    private _radius = _markerSize param [0, 0];
    private _zone = getMarkerPos _markerName;
    
    {if ((_x distance _zone) < (_radius + 100)) exitWith {_unitsNear = true;}; _unitsNear = false;} forEach playableUnits;

    if (_unitsNear && !_animalsActive) then {
        _animalsActive = true;
        for "_i" from 1 to _animalCount do 
        {
            private _animal = createAgent [
                selectRandom ["Sheep_random_F","Goat_random_F","Hen_random_F","Cock_random_F"],
                [((_zone#0) - _radius + random (_radius * 2)), ((_zone#1) - _radius + random (_radius * 2)),0],
                [],0,"FORM"
            ];
            _animal setDir (random 360);
            life_var_spawndAnimals pushBack _animal;
        };
    } else {
        if (!_unitsNear && _animalsActive) then {
            {
                deleteVehicle _x;
                life_var_spawndAnimals deleteAt _forEachIndex;
            } forEach life_var_spawndAnimals;
            _animalsActive = count life_var_spawndAnimals isEqualTo 0;
        };
    }; 
}forEach [
    ["hunting_zone",30]
];

true