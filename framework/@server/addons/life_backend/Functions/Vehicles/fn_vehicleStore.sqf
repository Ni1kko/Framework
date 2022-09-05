#include "\life_backend\script_macros.hpp"
/*
    File: fn_vehicleStore.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Stores the vehicle in the 'Garage'
*/

params [ 
    ["_vehicle", objNull, [objNull]], 
    ["_impound", false, [true]], 
    ["_unit", objNull, [objNull]], 
    ["_storetext", "", [""]] 
];

if (isNull _vehicle || isNull _unit) exitWith {life_impound_inuse = false; (owner _unit) publicVariableClient "life_impound_inuse";life_garage_store = false;(owner _unit) publicVariableClient "life_garage_store";}; //Bad data passed.

private _vehicleID = _vehicle getVariable ["vehicle_id",-1];
private _vInfo = _vehicle getVariable ["dbInfo",[]];
private _trunk = _vehicle getVariable ["Trunk", [[], 0]];
private _impoundFee = getNumber(configFile >> "cfgVehicles" >> "impoundFee");
private _blacklist = false;  
private _totalweight = 0;

private ["_plate","_uid"];
if (count _vInfo > 0) then {
    _plate = _vInfo select 1;
    _uid = _vInfo select 0;
};

//-- not persistent
if (count _vInfo isEqualTo 0) exitWith {
    if _impound then  {
        if (!isNil "_vehicle" && {!isNull _vehicle}) then {
            deleteVehicle _vehicle;
            waitUntil {isNull _vehicle};
        };
        life_impound_inuse = false;
        (owner _unit) publicVariableClient "life_impound_inuse";
    }else{ 
        [1,"STR_Garage_Store_NotPersistent",true] remoteExecCall ["life_fnc_broadcast",(owner _unit)];
        life_garage_store = false;
        (owner _unit) publicVariableClient "life_garage_store"; 
    };
};

//-- not the vehicles owner
if (_uid isNotEqualTo getPlayerUID _unit AND !_impound) exitWith {
    [1,"STR_Garage_Store_NoOwnership",true] remoteExecCall ["life_fnc_broadcast",(owner _unit)];
    life_garage_store = false;
    (owner _unit) publicVariableClient "life_garage_store";
};

// save damage.
private _damage = (getAllHitPointsDamage _vehicle)#2;

// because fuel price!
private _fuel = (fuel _vehicle);

private _cargo = [
    getItemCargo _vehicle,
    getMagazineCargo _vehicle,
    getWeaponCargo _vehicle,
    getBackpackCargo _vehicle
];
 
private _items = (_trunk#0) apply {
    private _isIllegal = (M_CONFIG(getNumber,"VirtualItems",(_x#0),"illegal")) isEqualTo 1;
    private _weight = (ITEM_WEIGHT(_x#0)) * (_x#1);
    _totalweight = _weight + _totalweight;
    if _isIllegal then {_blacklist = true};
    [_x#0,_x#1]
};

private _queryElements = [
    ["active",["DB","BOOL", false] call life_fnc_database_parse], 
    ["inventory",["DB","ARRAY", [_items, _totalweight]] call life_fnc_database_parse], 
    ["gear",["DB","ARRAY", _cargo] call life_fnc_database_parse], 
    ["fuel",["DB","INT", _fuel] call life_fnc_database_parse], 
    ["damage",["DB","ARRAY", _damage] call life_fnc_database_parse]
];

//--- check if the vehicle was impounded by cop and were they anything illegal in the trunk
if (_impound AND _blacklist AND side _unit isEqualTo west) then {
    private _profileQuery = [format ["SELECT name FROM players WHERE pid='%1'", _uid], 2] call life_fnc_database_rawasync_request;
    private _profileName = _profileQuery#0; 
    [_uid, _profileName, "481"] call life_fnc_wantedAdd;
    _queryElements pushBack ["blacklist",["DB","BOOL", true] call life_fnc_database_parse];
    if (_vehicleID > 0) then { 
        _queryElements pushBack ["impounded",["DB","BOOL", true] call life_fnc_database_parse];
    };
};

//--- Delete
if (!isNil "_vehicle" && {!isNull _vehicle}) then {
    deleteVehicle _vehicle;
    waitUntil {isNull _vehicle};
};

//--- Store
["UPDATE", "vehicles", [
    _queryElements,
    [
        ["pid",["DB","STRING", _uid] call life_fnc_database_parse],
        ["plate",["DB","STRING", _plate] call life_fnc_database_parse]
    ]
]]call life_fnc_database_request;

//--- Impounded
if (["impounded",["DB","BOOL", true] call life_fnc_database_parse] in _queryElements) exitWith
{
    ["CREATE", "impounded_vehicles", 
        [
            ["vehicle_id",				["DB","INT", _vehicleID] call life_fnc_database_parse],
            ["impound_by_guid", 		["DB","STRING", ('BEGuid' callExtension ("get:"+(getPlayerUID _unit)))] call life_fnc_database_parse],
            ["impound_fee", 			["DB","INT", _impoundFee] call life_fnc_database_parse]
        ]
    ] call life_fnc_database_request;

    life_impound_inuse = false;
    (owner _unit) publicVariableClient "life_impound_inuse";

    true
};

 
life_garage_store = false;
(owner _unit) publicVariableClient "life_garage_store";
[1,_storetext] remoteExecCall ["life_fnc_broadcast",(owner _unit)];

true