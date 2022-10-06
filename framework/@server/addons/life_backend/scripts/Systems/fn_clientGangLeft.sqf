#include "\life_backend\serverDefines.hpp"
/*
	## Ni1kko
	## https://github.com/Ni1kko/FrameworkV2
*/

private ["_unit","_group"];
_unit = _this select 0;
_group = _this select 1;
if (isNil "_unit" || isNil "_group") exitWith {};
if (player isEqualTo _unit && (group player) == _group) then {
    life_my_gang = objNull;
    [player] joinSilent (createGroup civilian);
    hint localize "STR_GNOTF_LeaveGang";
};