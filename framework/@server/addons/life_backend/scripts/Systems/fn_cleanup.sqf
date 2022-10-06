#include "\life_backend\serverDefines.hpp"
/*
	## Tonic & Ni1kko
	## https://github.com/Ni1kko/FrameworkV2
*/

switch (param [0,""]) do 
{
    case "vehicles":
    { 
        {
            private _veh = _x; 
            private _protect = false;
            private _vehicleClass = getText(configFile >> "CfgVehicles" >> (typeOf _veh) >> "vehicleClass");
            
            if (_veh getVariable ["NPC",false]) then {_protect = true;};

            if ((_vehicleClass in ["Car","Air","Ship","Armored","Submarine"]) && {!(_protect)}) then 
            {
                private _units = {(_x distance _veh < 300)} count playableUnits;

                if (count crew _x isEqualTo 0) then {
                    switch (true) do {
                        case ((_x getHitPointDamage "HitEngine") > 0.7 && _units isEqualTo 0) : {deleteVehicle _x;};
                        case ((_x getHitPointDamage "HitLFWheel") > 0.98 && _units isEqualTo 0) : {deleteVehicle _x;};
                        case ((_x getHitPointDamage "HitLF2Wheel") > 0.98 && _units isEqualTo 0) : {deleteVehicle _x;};
                        case ((_x getHitPointDamage "HitRFWheel") > 0.98 && _units isEqualTo 0) : {deleteVehicle _x;};
                        case ((_x getHitPointDamage "HitRF2Wheel") > 0.98 && _units isEqualTo 0) : {deleteVehicle _x;};
                        case (_units isEqualTo 0): {deleteVehicle _x;};
                    };
                };

                private _dbInfo = _veh getVariable ["dbInfo",[]];
                if (count _dbInfo >= 2) then {
                    ["UPDATE", "vehicles", [
                        [
                            ["active",["DB","BOOL", false] call MPServer_fnc_database_parse],
                            ["fuel",["DB","INT", fuel _veh] call MPServer_fnc_database_parse]
                        ],
                        [
                            ["pid",["DB","STRING", _dbInfo#0] call MPServer_fnc_database_parse],
                            ["plate",["DB","STRING", _dbInfo#1] call MPServer_fnc_database_parse]
                        ]
                    ]]call MPServer_fnc_database_request;
                };
               
            };
        } forEach vehicles;

    };
    case "weapons":
    { 
        {
            deleteVehicle _x;
        } forEach (allMissionObjects "GroundWeaponHolder");
    };
    case "items":
    { 
        {
            if ((typeOf _x) in ["Land_BottlePlastic_V1_F","Land_TacticalBacon_F","Land_Can_V3_F","Land_CanisterFuel_F", "Land_Can_V3_F","Land_Money_F","Land_Suitcase_F"]) then {
                deleteVehicle _x;
            };
        } forEach (allMissionObjects "Thing");
    };
};

true