/*
    File: fn_garageRefund.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    I don't know?
*/

params [
    ["_price", 0, [0]],
    ["_unit", objNull, [objNull]] 
];

if (_unit isNotEqualTo player) exitWith {false};

["ADD","BANK",_price] call MPClient_fnc_handleMoney;

true
