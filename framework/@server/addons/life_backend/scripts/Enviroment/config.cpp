class CfgPatches 
{
    class Enviroment
    {
        units[] = {};
        weapons[] = {};
        requiredAddons[] = {};
        authors[] = {"Ni1kko"};
    };
};

class CfgEnviroment
{ 
    class wildLife 
    {
        animaltypes[]= {
            {"Sheep_random_F", "hunting_pos",250},
            {"Goat_random_F", "hunting_pos",120},
            {"Cock_random_F", "hunting_pos",60},
            {"Hen_random_F", "hunting_pos",30}
        };
    };
};

class CfgFunctions 
{
    class MPServer
    {
        class Enviroment_Functions
        {
            file = "\life_backend\scripts\Enviroment";
            class initWildlife {};
            class getWildlife {};
            class createWildlife {};
            class cleanUpWildlife {};
            class deleteWildlife {};
        };
    };
};