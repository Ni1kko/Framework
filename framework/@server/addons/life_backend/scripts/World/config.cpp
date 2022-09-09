class CfgPatches 
{
    class World
    {
        units[] = {};
        weapons[] = {};
        requiredAddons[] = {};
        authors[] = {"Ni1kko"};
    };
};

class CfgWorld
{ 

};

class CfgFunctions 
{
    class MPServer 
    {
        class World_Functions
        {
            file = "\life_backend\scripts\World";
            class setupHospitals {};
            class setupBanks {};
        };
    };
};