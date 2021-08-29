class CfgPatches {
    class life_headless {
        units[] = {};
        weapons[] = {};
        requiredAddons[] = {};
        author = "Ni1kko";
    };
};

class CfgFunctions 
{
    class Life
    {
        class Root 
        {
            file = "\life_headless";
            class preInit {preInit = 1;};
        };
    };
};