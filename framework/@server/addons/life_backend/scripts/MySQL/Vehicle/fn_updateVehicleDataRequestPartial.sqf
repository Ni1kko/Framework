#include "\life_backend\serverDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
    ## fn_updateVehicleDataRequestPartial.sqf (Server)
*/ 

params [
    ["_packetData",createHashMap, [createHashMap]]
];

private _vehicle = objectFromNetId (_packetData getOrDefault ["NetID", ""]);

//-- Bad player object
if(isNull _vehicle) exitWith {false};

private _vehicleInfo = _vehicle getVariable ["dbInfo",[]];
private _vehicleTrunk = _vehicle getVariable ["virtualInventory",[[],0]];

_packetData set ["SteamID", _vehicleInfo param [0, ""]];
_packetData set ["Plate", _vehicleInfo param [1, ""]];

if(count(_packetData get "SteamID") isNotEqualTo 17 OR count(_packetData get "Plate") isEqualTo 0) exitWith {false};
 
private _whereClause = [
    ["pid",_packetData get "SteamID"],
    ["plate",_packetData get "Plate"]
];

switch (_packetData getOrDefault ["Mode", -1]) do 
{ 
    case 1: 
    {
        private _vehItems = getItemCargo _vehicle;
        private _vehMags = getMagazineCargo _vehicle;
        private _vehWeapons = getWeaponCargo _vehicle;
        private _vehBackpacks = getBackpackCargo _vehicle;
        private _cargo = [_vehItems,_vehMags,_vehWeapons,_vehBackpacks];

        // Keep it clean!
        if ((count (_vehItems#0) isEqualTo 0) && (count (_vehMags#0) isEqualTo 0) && (count (_vehWeapons#0) isEqualTo 0) && (count (_vehBackpacks#0) isEqualTo 0)) then {
            _cargo = [];
        };

        ["UPDATE", "vehicles", [
            [
                ["gear",["DB","ARRAY", _cargo] call MPServer_fnc_database_parse]
            ],
            _whereClause
        ]]call MPServer_fnc_database_request;
    };

    case 2: 
    {
        /*
            private _resourceItems = CFG_MASTER(getArray,"save_vehicle_items");
            private _totalweight = 0;
            private _items = [];
            {
                _x params ["_item","_amount"];
                if (_item in _resourceItems) then {
                    private _weight = (ITEM_WEIGHT(_item)) * _amount;
                    _items pushBack [_item,_amount];
                    _totalweight = _weight + _totalweight;
                };
            }forEach (_vehicleTrunk#0);

            _vehicleTrunk = [_items,_totalweight];
        */

        ["UPDATE", "vehicles", [
            [
                ["inventory",["DB","ARRAY", _vehicleTrunk] call MPServer_fnc_database_parse]
            ],
            _whereClause
        ]]call MPServer_fnc_database_request;
    };

    case 3: 
    {  
        ["UPDATE", "vehicles", [
            [
                ["blacklist",["DB","BOOL", _packetData getOrDefault ["Blacklisted", false]] call MPServer_fnc_database_parse]
            ],
            _whereClause
        ]]call MPServer_fnc_database_request;
    };

    case 4: 
    {  
        ["UPDATE", "vehicles", [
            [
                ["active",["DB","BOOL", _packetData getOrDefault ["Spawned", not(isNull _vehicle)]] call MPServer_fnc_database_parse]
            ],
            _whereClause
        ]]call MPServer_fnc_database_request;
    };

    case 5: 
    {  
        ["UPDATE", "vehicles", [
            [
                ["alive",["DB","BOOL", _packetData getOrDefault ["Alive", alive _vehicle]] call MPServer_fnc_database_parse]
            ],
            _whereClause
        ]]call MPServer_fnc_database_request;
    };

    case 6: 
    {  
        ["UPDATE", "vehicles", [
            [
                ["fuel",["DB","INT", _packetData getOrDefault ["Fuel", fuel _vehicle]] call MPServer_fnc_database_parse]
            ],
            _whereClause
        ]]call MPServer_fnc_database_request;
    };
};

true