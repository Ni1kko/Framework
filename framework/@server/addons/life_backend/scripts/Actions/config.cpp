class CfgPatches 
{
    class Actions
    {
        units[] = {};
        weapons[] = {};
        requiredAddons[] = {"Database"};
        authors[] = {"Ni1kko"};
    };
};

class CfgActions
{  
    
};

class CfgFunctions 
{
    class MPServer
    {
        class Action_Functions
        { 
            file = "\life_backend\scripts\Actions";
            class pickupAction {};
        };
    };
};