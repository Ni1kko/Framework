class CfgPatches 
{
    class Jail 
    {
        units[] = {};
        weapons[] = {};
        requiredAddons[] = {"Systems"};
        authors[] = {"Ni1kko"};
    };
};
 
class CfgJail
{
    
};

class CfgFunctions 
{
    class MPServer
    {
        class Jail_Functions
        {
            file = "\life_backend\scripts\Jail";
            class jailSys {};
        };
    };
};