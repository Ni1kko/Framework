class CfgPatches {
    class Vehicles {
        units[] = {};
        weapons[] = {};
        requiredAddons[] = {"Database"};
        authors[] = {"Ni1kko"};
    };
};
 
class CfgVehicles
{

};

class CfgFunctions {
    class TON {
        class Vehicles_Functions
        {
            file = "\life_backend\Functions\Vehicles";
            class vehicleCreate {};
            class spawnVehicle {};
            class getVehicles {};
            class vehicleStore {};
            class vehicleDelete {};
            class vehicleUpdate {};
        };
    };
};