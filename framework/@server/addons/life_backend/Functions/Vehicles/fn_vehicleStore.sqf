#include "\life_backend\script_macros.hpp"
/*
    File: fn_vehicleStore.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Stores the vehicle in the 'Garage'
*/
private ["_vehicle","_impound","_vInfo","_vInfo","_plate","_uid","_query","_sql","_unit","_trunk","_vehItems","_vehMags","_vehWeapons","_vehBackpacks","_cargo","_saveItems","_storetext","_resourceItems","_fuel","_damage","_itemList","_totalweight","_weight","_thread"];
_vehicle = [_this,0,objNull,[objNull]] call BIS_fnc_param;
_impound = [_this,1,false,[true]] call BIS_fnc_param;
_unit = [_this,2,objNull,[objNull]] call BIS_fnc_param;
_storetext = [_this,3,"",[""]] call BIS_fnc_param;
_resourceItems = LIFE_SETTINGS(getArray,"save_vehicle_items");

if (isNull _vehicle || isNull _unit) exitWith {life_impound_inuse = false; (owner _unit) publicVariableClient "life_impound_inuse";life_garage_store = false;(owner _unit) publicVariableClient "life_garage_store";}; //Bad data passed.
_vInfo = _vehicle getVariable ["dbInfo",[]];

if (count _vInfo > 0) then {
    _plate = _vInfo select 1;
    _uid = _vInfo select 0;
};

private _vehicleID = _vehicle getVariable ["vehicle_id",-1];
private _impoundFee = getNumber(configFile >> "cfgVehicles" >> "impoundFee");

// save damage.
if (LIFE_SETTINGS(getNumber,"save_vehicle_damage") isEqualTo 1) then {
    _damage = getAllHitPointsDamage _vehicle;
    _damage = _damage select 2;
    } else {
    _damage = [];
}; 
// because fuel price!
_fuel = (fuel _vehicle);

// not persistent so just do this!
if (count _vInfo isEqualTo 0) exitWith {
    [1,"STR_Garage_Store_NotPersistent",true] remoteExecCall ["life_fnc_broadcast",(owner _unit)];
    life_garage_store = false;
    (owner _unit) publicVariableClient "life_garage_store";
};

if (_uid isNotEqualTo getPlayerUID _unit AND !_impound) exitWith {
    [1,"STR_Garage_Store_NoOwnership",true] remoteExecCall ["life_fnc_broadcast",(owner _unit)];
    life_garage_store = false;
    (owner _unit) publicVariableClient "life_garage_store";
};

// sort out whitelisted items!
_trunk = _vehicle getVariable ["Trunk", [[], 0]];
_itemList = _trunk select 0;
_totalweight = 0;
_items = [];
if (LIFE_SETTINGS(getNumber,"save_vehicle_virtualItems") isEqualTo 1) then {
    if (LIFE_SETTINGS(getNumber,"save_vehicle_illegal") isEqualTo 1) then {
        private ["_isIllegal", "_blacklist"];
        _blacklist = false;
        _profileQuery = format ["SELECT name FROM players WHERE pid='%1'", _uid];
        _profileName = [_profileQuery, 2] call life_fnc_database_rawasync_request;
        _profileName = _profileName select 0;

        {
            _isIllegal = M_CONFIG(getNumber,"VirtualItems",(_x select 0),"illegal");

            _isIllegal = if (_isIllegal isEqualTo 1) then { true } else { false };

            if (((_x select 0) in _resourceItems) || (_isIllegal)) then {
                _items pushBack[(_x select 0),(_x select 1)];
                _weight = (ITEM_WEIGHT(_x select 0)) * (_x select 1);
                _totalweight = _weight + _totalweight;
            };
            if (_isIllegal) then {
                _blacklist = true;
            };

        }
        foreach _itemList;

        if (_blacklist) then {
            [_uid, _profileName, "481"] remoteExecCall["life_fnc_wantedAdd", RSERV];
            _query = format ["UPDATE vehicles SET blacklist='1' WHERE pid='%1' AND plate='%2'", _uid, _plate];
            _thread = [_query, 1] call life_fnc_database_rawasync_request;
        };

    }
    else {
        {
            if ((_x select 0) in _resourceItems) then {
                _items pushBack[(_x select 0),(_x select 1)];
                _weight = (ITEM_WEIGHT(_x select 0)) * (_x select 1);
                _totalweight = _weight + _totalweight;
            };
        }
        forEach _itemList;
    };

    _trunk = [_items, _totalweight];
}
else {
    _trunk = [[], 0];
};

if (LIFE_SETTINGS(getNumber,"save_vehicle_inventory") isEqualTo 1) then {
    _vehItems = getItemCargo _vehicle;
    _vehMags = getMagazineCargo _vehicle;
    _vehWeapons = getWeaponCargo _vehicle;
    _vehBackpacks = getBackpackCargo _vehicle;
    _cargo = [_vehItems,_vehMags,_vehWeapons,_vehBackpacks];
    // no items? clean the array so the database looks pretty
    if ((count (_vehItems select 0) isEqualTo 0) && (count (_vehMags select 0) isEqualTo 0) && (count (_vehWeapons select 0) isEqualTo 0) && (count (_vehBackpacks select 0) isEqualTo 0)) then {_cargo = [];};
    } else {
    _cargo = [];
};
// prepare
_trunk = [_trunk] call DB_fnc_mresArray;
_cargo = [_cargo] call DB_fnc_mresArray;

private _queryElements = [
    ["active",["DB","BOOL", false] call life_fnc_database_parse], 
    ["inventory",["DB","ARRAY", _trunk] call life_fnc_database_parse], 
    ["gear",["DB","ARRAY", _cargo] call life_fnc_database_parse], 
    ["fuel",["DB","INT", _fuel] call life_fnc_database_parse], 
    ["damage",["DB","ARRAY", _damage] call life_fnc_database_parse]
];

if (_impound) then {
    if (count _vInfo isEqualTo 0) then  {
        life_impound_inuse = false;
        (owner _unit) publicVariableClient "life_impound_inuse";

        if (!isNil "_vehicle" && {!isNull _vehicle}) then {
            deleteVehicle _vehicle;
        };
    } else {
        if(_vehicleID > 0) then {
            _queryElements pushBack ["impounded",["DB","BOOL", true] call life_fnc_database_parse];
        };
    }; 
};

private _impounded = ["impounded",["DB","BOOL", true] call life_fnc_database_parse] in _queryElements;

//--- 
["UPDATE", "vehicles", [
    _queryElements,
    [
        ["pid",["DB","STRING", _uid] call life_fnc_database_parse],
        ["plate",["DB","STRING", _plate] call life_fnc_database_parse]
    ]
]]call life_fnc_database_request;

 
if (!isNil "_vehicle" && {!isNull _vehicle}) then {
    deleteVehicle _vehicle;
};

if _impounded exitWith
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