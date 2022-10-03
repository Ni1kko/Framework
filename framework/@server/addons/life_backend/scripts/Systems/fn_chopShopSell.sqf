#include "\life_backend\script_macros.hpp"
/*
    File: fn_chopShopSell.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Checks whether or not the vehicle is persistent or temp and sells it.
*/
params [
    ["_unit",objNull,[objNull]],
    ["_vehicle",objNull,[objNull]],
    ["_price",500,[0]]
];

//Error checks
if (isNull _vehicle || isNull _unit) exitWith  {
    [] remoteExecCall ["MPClient_fnc_chopShopSold", remoteExecutedOwner];
};

private _displayName = FETCH_CONFIG2(getText,"CfgVehicles",typeOf _vehicle, "displayName");

private _dbInfo = _vehicle getVariable ["dbInfo",[]];
if (count _dbInfo > 0) then { //Persistent vehicle
    [createHashMapFromArray [
        ["Mode",5],
        ["NetID",NetID _vehicle],
        ["Alive", false]
    ]] call MPServer_fnc_updateVehicleDataRequestPartial;
};

deleteVehicle _vehicle;

[_price,_displayName] remoteExecCall ["MPClient_fnc_chopShopSold", remoteExecutedOwner];