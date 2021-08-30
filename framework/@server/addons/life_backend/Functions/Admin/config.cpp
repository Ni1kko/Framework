class CfgPatches {
    class Admin {
        units[] = {};
        weapons[] = {};
        requiredAddons[] = {"Database","Rcon"};
        authors[] = {"Ni1kko"};
    };
};
 
class CfgAdmin
{
    //--- logging
    rptlogs = 1;                //Log to RPT file
    conlogs = 1;                //Log to Console
    extlogs = 1;                //Log to Extension
    dblogs = 1;                 //Log to Database
   
};

class CfgFunctions {
    class Life {
        class Admin_Functions
        {
            file = "\life_backend\Functions\Admin";
            class admin_initialize {};
            class admin_systemlog {};
        };
    };
};