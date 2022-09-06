class CfgPatches 
{
    class PlayTime 
    {
        units[] = {};
        weapons[] = {};
        requiredAddons[] = {"Database"};
        authors[] = {"Ni1kko"};
    };
};

class CfgPlayTime
{  
    
};

class CfgFunctions 
{
    class MPServer 
    {
        class PlayTime_Functions
        {
            file = "\life_backend\Functions\PlayTime";
            class setPlayTime {};
            class getPlayTime {};
            class registerPlayTime {};
        };
    };
};