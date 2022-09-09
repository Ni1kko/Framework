class CfgPatches 
{
    class Gangs
    {
        units[] = {};
        weapons[] = {};
        requiredAddons[] = {"Database"};
        authors[] = {"Ni1kko"};
    };
};

class CfgGangs
{  
    
};

class CfgFunctions 
{
    class MPServer
    {
        class Gang_Functions
        {
            file = "\life_backend\scripts\Gangs";
            class insertGang {};
            class queryPlayerGang {};
            class removeGang {};
            class updateGang {};
        };
    };
};