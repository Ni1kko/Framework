#include "\life_backend\script_macros.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

private _config = call life_var_lotto_config;
private _ticketLength = _config param [1, 0];
private _ticketNumbers = [];

for "_i" from 1 to _ticketLength do {
	private _randomNumber = selectRandom [0,1,2,3,4,5,6,7,8,9];
	_ticketNumbers pushBack _randomNumber; 
};

_ticketNumbers joinString ""