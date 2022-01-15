class CfgPatches {
    class Scriptloader {
        units[] = {};
        weapons[] = {};
        requiredAddons[] = {};
        authors[] = {"Ni1kko" , "maca134"};
    };
};
 
class CfgFunctions {
    class Life {
        class Scriptloader_Functions
        {
            file = "\life_backend\Functions\Scriptloader";
            class preInit {preInit = 1;};
            class loadscript {};
			class runscript {};
        };
    };
};