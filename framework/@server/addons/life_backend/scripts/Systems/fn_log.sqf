#include "\life_backend\script_macros.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

params [ 
	["_contents","",[""]]
];

if(count _contents isEqualTo 0) exitWith {false};

diag_log format ["[MPServer] %1",_contents];

true