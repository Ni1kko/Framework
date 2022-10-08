#include "\life_backend\serverDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
	## fn_createWildlife.sqf
*/

private _type = param [0, ""];
private _pos = param [1, [0,0,0]];
private _radius = param [2, 0];
private _amount = param [3, 0];

private _spawndAnimals = [];

for "_i" from 1 to _amount do 
{
	_pos set [0, ((_pos#0) - _radius + random (_radius * 2))];
	_pos set [1, ((_pos#1) - _radius + random (_radius * 2))];
	_pos set [2, 0];

	private _animal = createAgent [_type,_pos,[],0,"FORM"];

	if(not(isNull _animal))then{
		_animal setDir (random 360);
		_spawndAnimals pushBackUnique _animal;
	};
};

if(count _spawndAnimals > 0)then{
	life_var_spawndAnimals append _spawndAnimals;
};

_spawndAnimals