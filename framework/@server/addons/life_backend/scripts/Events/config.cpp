class DefaultEventhandlers;
class CfgPatches 
{
    class Events 
    {
        units[] = {"C_man_1"};
        weapons[] = {};
        requiredAddons[] = {"A3_Characters_F", "Systems"};
        authors[] = {"Ni1kko"};
    };
};
 
class CfgEvents
{
    fixHeadGear = 1;
    randomNPC_Uniforms = 1;
    NPC_Uniforms[] = {
        "U_C_Poloshirt_blue",
        "U_C_Poloshirt_burgundy",
        "U_C_Poloshirt_redwhite",
        "U_C_Poloshirt_salmon",
        "U_C_Poloshirt_stripped",
        "U_C_Poloshirt_tricolour",
        "U_C_HunterBody_grn"
    };
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
            class event_initPlayerObject {};
        };
    };
};

class CfgVehicles 
{
    class Car_F;
    class CAManBase;
    class Civilian;
    class Civilian_F : Civilian 
    {
        class EventHandlers;
    };

    class C_man_1 : Civilian_F 
    {
        class EventHandlers: EventHandlers 
        {
            init = "(_this#0) spawn MPServer_fnc_event_initPlayerObject;";
        };
    };
};
