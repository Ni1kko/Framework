#include "..\..\script_macros.hpp"
/*
    File: fn_giveDiff.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    ??A?SD?ADS?A
*/
private ["_unit","_item","_val","_from","_bool"];
_unit = _this select 0;
if !(_unit isEqualTo player) exitWith {};
_item = _this select 1;
_val = _this select 2;
_from = _this select 3;
_bool = if (count _this > 4) then {true} else {false};
_type = M_CONFIG(getText,"cfgVirtualItems",_item,"displayName");

if ([true,_item,(parseNumber _val)] call MPClient_fnc_handleInv) then {
    hint format (switch _bool do {
        case true:  {[localize "STR_MISC_TooMuch",    _from getVariable ["realname",name _from],  _val,  TEXT_LOCALIZE(_type)]};
        case false: {[localize "STR_MISC_TooMuch_2",  _from getVariable ["realname",name _from],  _val,  TEXT_LOCALIZE(_type)]};
    });
};