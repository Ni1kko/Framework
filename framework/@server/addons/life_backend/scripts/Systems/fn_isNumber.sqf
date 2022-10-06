#include "\life_backend\serverDefines.hpp"
/*
	## Ni1kko
	## https://github.com/Ni1kko/FrameworkV2
*/

params [
    ['_string','',['']]
];

if (_string isEqualTo '') exitWith {false};

private _array = _string splitString '';

private _return = true;
{
    if !(_x in ['0','1','2','3','4','5','6','7','8','9']) exitWith {
        _return = false;
    };
} forEach _array;

_return;