class DefaultEventhandlers;
class CfgPatches 
{
    class life_backend 
    {
        units[] = {"C_man_1"};
        weapons[] = {};
        requiredAddons[] = {"A3_Data_F","A3_Soft_F","A3_Soft_F_Offroad_01","A3_Characters_F"};
        fileName = "life_backend.pbo";
        author = "Tonic";
    };
};

//--- Limits RPT file output to one file only!
rptFileLimit=1;

class CfgVehicles {
    class Car_F;
    class CAManBase;
    class Civilian;
    class Civilian_F : Civilian {
        class EventHandlers;
    };

    class C_man_1 : Civilian_F {
        class EventHandlers: EventHandlers {
            init = "(_this select 0) spawn life_fnc_fix_headgear;";
        };
    };
};