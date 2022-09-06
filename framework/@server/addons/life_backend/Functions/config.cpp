class CfgPatches 
{
    class Life_Backend_Functions 
    {
        units[] = {};
        weapons[] = {};
        requiredAddons[] = {"Life_Backend_Fsms"};
        authors[] = {"Tonic", "Ni1kko"};
    };
};

class CfgFunctions 
{
    //--- Root Functions
    class Life 
    {
        class Root_Functions
        {
            file = "\life_backend\Functions";
            class preInit {preInit = 1;};
        }; 
    };
};