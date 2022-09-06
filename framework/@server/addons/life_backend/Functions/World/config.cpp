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
    class Life 
    {
        class World_Functions
        {
            file = "\life_backend\Functions\World";
            class setupHospitals {};
            class setupBanks {};
        };
    };
};