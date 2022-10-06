#include "..\..\clientDefines.hpp"
/*
    File: fn_freezePlayer.sqf
    Author: ColinM9991

    Description:
    Freezes selected player.
*/
private ["_admin"];
_admin = [_this,0,objNull,[objNull]] call BIS_fnc_param;

if (life_var_adminFrozen) then {
    hint localize "STR_NOTF_Unfrozen";
    [1,format [localize "STR_ANOTF_Unfrozen",profileName]] remoteExecCall ["MPClient_fnc_broadcast",_admin];
    disableUserInput false;
    life_var_adminFrozen = false;
} else {
    hint localize "STR_NOTF_Frozen";
    [1,format [localize "STR_ANOTF_Frozen",profileName]] remoteExecCall ["MPClient_fnc_broadcast",_admin];
    disableUserInput true;
    life_var_adminFrozen = true;
};
