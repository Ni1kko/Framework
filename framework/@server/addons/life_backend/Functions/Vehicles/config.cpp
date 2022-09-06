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
};

class CfgFunctions 
{
    class Life 
    {
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