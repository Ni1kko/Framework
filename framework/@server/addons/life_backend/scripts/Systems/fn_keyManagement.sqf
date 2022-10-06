#include "\life_backend\serverDefines.hpp"
/*
    File: fn_keyManagement.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Keeps track of an array locally on the server of a players keys.
*/
private _uid = [_this,0,"",[""]] call BIS_fnc_param;
private _side = [_this,1,sideUnknown,[sideUnknown]] call BIS_fnc_param;
private _input = [_this,2,objNull,[objNull,[]]] call BIS_fnc_param; 
private _keys = missionNamespace getVariable [format ["%1_KEYS_%2",_uid,_side],[]];

if (_uid isEqualTo "" || _side isEqualTo sideUnknown) exitWith {};
if (typeName _input isEqualTo "OBJECT") then {_input = [_input]};

{_keys pushBackUnique _x} forEach _input;
_keys = _keys - [objNull];

missionNamespace setVariable [format ["%1_KEYS_%2",_uid,_side],_keys];

_keys