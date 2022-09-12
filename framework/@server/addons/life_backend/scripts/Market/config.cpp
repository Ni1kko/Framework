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
    
};

class CfgFunctions 
{
    class MPServer 
    {
        class Market_Functions
        {
            file = "\life_backend\scripts\Market";
            class loadMarket { postInit = 1; };
            class getMarketDataValue {};
        };
    };
};