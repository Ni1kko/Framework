#include "..\..\script_macros.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
    ## fn_checkConditions.sqf
*/

if !(params [["_itemConfig", [], [[],""]]]) exitWith {};

scopeName "main";

private _return = false;

if (_itemConfig isEqualTo []) exitWith { 
    [localize "STR_NOTF_emptyArray_checkConditions"] call MPClient_fnc_log;
    _return
};

if (_itemConfig isEqualType []) then {
    private _lastElement = _itemConfig select (count _itemConfig - 1);
    if (_lastElement isEqualType "") then {
        _itemConfig = _lastElement;
    } else {
        true breakOut "main";
    };
};

if (isNil {_itemConfig}) exitWith {true};
if (_itemConfig isEqualTo "") exitWith {true};

private _evaluation = call compile _itemConfig;

if (_evaluation isEqualType true) then {
    if (_evaluation) then {
        _return = true;
    };
} else {
    _return = true;
};

_return;
