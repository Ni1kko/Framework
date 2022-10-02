#include "\life_backend\script_macros.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

params ["_uid", "_playtimenew"];

//--- Playtime
private _playtimeindex = life_var_playtimeValuesRequest find [_uid, _playtimenew];

if (_playtimeindex != -1) then {
    life_var_playtimeValuesRequest set[_playtimeindex,-1];
    life_var_playtimeValuesRequest = life_var_playtimeValuesRequest - [-1];
    life_var_playtimeValuesRequest pushBack [_uid, _playtimenew];
} else {
    life_var_playtimeValuesRequest pushBack [_uid, _playtimenew];
};

switch (_side) do {
    case west: { 
        [_uid,_playtimenew#0] call MPServer_fnc_setPlayTime;
    };
    case independent: { 
        [_uid,_playtimenew#1] call MPServer_fnc_setPlayTime;
    };
    case east: { 
        [_uid,_playtimenew#2] call MPServer_fnc_setPlayTime;
    };
    default { 
        [_uid,_playtimenew#3] call MPServer_fnc_setPlayTime;
    };
};

publicVariable "life_var_playtimeValuesRequest";
 
true