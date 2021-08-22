#include "..\..\script_macros.hpp"
/*
    File: fn_adminDebugCon.sqf
    Author: ColinM9991

    Description:
    Opens the Debug Console.
*/
if !(player call life_isdev) exitWith {closeDialog 0; hint localize "STR_NOTF_adminDebugCon";};
life_admin_debug = true;

createDialog "RscDisplayDebugPublic";
[0,format [localize "STR_NOTF_adminHasOpenedDebug",profileName]] remoteExecCall ["life_fnc_broadcast",RCLIENT];
