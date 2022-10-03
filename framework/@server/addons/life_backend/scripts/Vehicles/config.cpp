class CfgPatches 
{
    class Vehicles 
    {
        units[] = {};
        weapons[] = {};
        requiredAddons[] = {"Database"};
        authors[] = {"Ni1kko"};
    };
};
 
class CfgVehicles
{
    impoundFee = 500; // How much money to get back a vehicle from impound (Does increase with each day until it is released)
    thermalVision = 0; // 1 = Thermal Vision Enabled, 0 = Thermal Vision Disabled
    nightVision = 1; // 1 = Night Vision Enabled, 0 = Night Vision Disabled
};

class CfgFunctions 
{
    class MPServer 
    {
        class Vehicles_Functions
        {
            file = "\life_backend\scripts\Vehicles";
            class vehicleCreate {};
            class spawnVehicle {};
            class getVehicles {};
            class vehicleStore {};
            class vehicleDelete {};
            class vehicle_generateVIN {preInit = 1;};
        };
    };
};