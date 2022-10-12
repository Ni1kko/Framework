#include "..\..\clientDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
	## fn_inventoryOpened.sqf
*/

params [
    ["_unit", objNull, [objNull]],
    ["_container", objNull, [objNull]],
    ["_secContainer", objNull, [objNull]]
];

//-- Type of containers opened
private _types = [];

//-- Check if the container can be opened
if (({
    private _blockInventory = false;
    private _blockInventoryMessage = "";

    private _object = _x;

    if (not(isNull _object)) then 
    {
        private _objectType = typeOf _object; 

        switch (true) do 
        {
            //-- Dead Player
            case (_object isKindOf "CAManBase" AND not(alive _object)): 
            {
                _blockInventory = true;
                _blockInventoryMessage = localize "STR_NOTF_NoLootingPerson";
                _types pushBack "dead_player";
            };
            //-- Player backpack
            case (FETCH_CONFIG2(getNumber, "CfgVehicles", _objectType, "isBackpack") isEqualTo 1): 
            {
                _blockInventory = true;
                _blockInventoryMessage = localize "STR_MISC_Backpack";
                _types pushBack "storage_player";
            };
            //-- House storage
            case (_objectType in ["Box_IND_Grenades_F", "B_supplyCrate_F"]): 
            { 
                private _house = nearestObject [player, "House"];
                private _hasKeys = _house in life_var_vehicles; 
                private _isLocked = _house getVariable ["locked",true];

                if (_isLocked AND not(_hasKeys)) then {
                    _blockInventory = true;
                    _blockInventoryMessage = localize "STR_House_ContainerDeny";
                    _types pushBack "storage_house";
                };
            };
            //-- Vehicles
            case (({_object isKindOf _x} count ["LandVehicle", "Car", "Ship", "Air", "Tank"]) > 0): 
            {
                private _vehicle = _object;
                private _hasKeys = _vehicle in life_var_vehicles;
                private _isLocked = locked _vehicle isEqualTo 2;

                if (_isLocked AND not(_hasKeys)) then {
                    _blockInventory = true;
                    _blockInventoryMessage = localize "STR_MISC_VehInventory";
                    _types pushBack "storage_vehicle";
                    /*TODO: Trigger Alarm (Hazards only no sound)*/
                };
            };
        };
        
        if _blockInventory then {
            hint _blockInventoryMessage;
        };
    };

    _blockInventory
} count [_container, _secContainer]) > 0) exitWith {
    (findDisplay 602) closeDisplay 0;
    true
};

//-- exteneted inventory
if not(isNil "virtualNamespace") then {
   [] spawn MPClient_fnc_inventoryCreateMenu;
};

false