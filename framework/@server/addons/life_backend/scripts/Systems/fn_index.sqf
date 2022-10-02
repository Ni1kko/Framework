#include "\life_backend\script_macros.hpp"
/*
	## Ni1kko
	## https://github.com/Ni1kko/FrameworkV2
*/

params [
    "_item",
    ["_stack",[],[[]]]
];

_stack findIf {_item in _x};