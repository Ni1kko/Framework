#include "\life_backend\serverDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

private _length = 2;
private _bonusballNumbers = [];

for "_i" from 1 to _length do {
	private _randomNumber = selectRandom [0,1,2,3,4,5,6,7,8,9];
	_bonusballNumbers pushBack _randomNumber; 
};

_bonusballNumbers joinString ""