#include "..\..\script_macros.hpp"
/*
    File: fn_adminTpHere.sqf
    Author: ColinM9991

    Description:
    Teleport selected player to you.
*/
if ((call life_adminlevel) < 4) exitWith {closeDialog 0;};

private _target = lbData[2902,lbCurSel (2902)];
_target = call compile format ["%1", _target];
if (isNil "_target" || isNull _target) exitWith {};
if (_target == player) exitWith {hint localize "STR_ANOTF_Error";};
if (!(vehicle _target isEqualTo _target)) exitWith {hint localize "STR_Admin_CannotTpHere"};

_target setVariable ["life_var_teleported",true,true];

_target spawn {
    uiSleep 0.5;
    _this setPos (getPos player);
    hint ["You have teleported %1 to your location.",name _this];
    uiSleep 3;
    _this setVariable ["life_var_teleported",false,true];
};