class CfgPatches 
{
    class Market 
    {
        units[] = {};
        weapons[] = {};
        requiredAddons[] = {"Database"};
        authors[] = {"Ni1kko"};
    };
};
 
class CfgMarket
{
    oneTimeUse = 0; // disable too give back tent after packing up
    garages = 1; // allow to store vehicles at placed campsites
};

class CfgFunctions 
{
    class MPServer 
    {
        class Market_Functions
        {
            file = "\life_backend\scripts\Tents";
            class loadMarket { postInit = 1; };
        };
    };
};