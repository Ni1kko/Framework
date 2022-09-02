class CfgPatches {
    class Tents {
        units[] = {};
        weapons[] = {};
        requiredAddons[] = {"Database"};
        authors[] = {"Ni1kko"};
    };
};
 
class CfgTents
{
    oneTimeUse = 1;
};

class CfgFunctions {
    class Life {
        class Tent_Functions
        {
            file = "\life_backend\Functions\Tents";
            class tents_init { postInit = 1; };
            class tents_build {};
            class tents_buildRequest {};
            class tents_packup {};
            class tents_packupRequest {};
        };
    };
};