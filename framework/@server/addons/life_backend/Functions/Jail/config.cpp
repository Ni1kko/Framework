class CfgPatches 
{
    class Jail 
    {
        units[] = {};
        weapons[] = {};
        requiredAddons[] = {"Database"};
        authors[] = {"Ni1kko"};
    };
};
 
class CfgJail
{
    
};

class CfgFunctions 
{
    class Life
    {
        class Jail_Functions
        {
            file = "\life_backend\Functions\Jail";
            class jailSys {};
        };
    };
};