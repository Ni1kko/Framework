class CfgPatches 
{
    class Events 
    {
        units[] = {};
        weapons[] = {};
        requiredAddons[] = {"Database"};
        authors[] = {"Ni1kko"};
    };
};
 
class CfgEvents
{
    
};

class CfgFunctions 
{
    class MPServer
    {
        class Events_Functions
        {
            file = "\life_backend\scripts\Events";
            class event_playerConnected {};
            class event_playerDisconnected {};
        };
    };
};