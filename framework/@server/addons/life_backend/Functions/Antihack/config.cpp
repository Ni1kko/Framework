class CfgPatches {
    class Antihack {
        units[] = {};
        weapons[] = {};
        requiredAddons[] = {"Database","Rcon"};
        authors[] = {"Ni1kko"};
    };
};
 
class CfgAntiHack
{
    //--- logging
    rptlogs = 1;             //Log to RPT file
    conlogs = 1;             //Log to Console
    extlogs = 1;             //Log to Extension
    dblogs = 1;              //Log to Database (Kicks & Bans Only)
    
    //--- options
    checklanguage = 1;       //check for language
    checkrecoil = 1;         //check for weapon recoil hack              Notes: (admins excluded)
    checkspeed = 1;          //check for walking speed hack              Notes: (admins excluded)
    checkdamage = 1;         //check for god mode hack                   Notes: (admins excluded)
    checksway = 1;           //check for weapon sway hack                Notes: (admins excluded)
    checkmapEH = 1;          //check for added map event handlers        Notes: (admin lvl 3 and above excluded)
    checkvehicleweapon = 1;  //check for added vehicle weapons           Notes: (admin lvl 5 and above excluded)
    checkterraingrid = 1;    //
    checkdetectedmenus = 1;  //
    checkdetectedvariables = 1;  //
    checknamebadchars = 1;  //
    checknameblacklist = 1;  //
    
    use_databaseadmins = 1;  //
    use_debugconadmins = 0;  //
    use_interuptinfo = 1;

    serverlanguage = 'English';

    //--- 
    nameblacklist[] = {
        'Admin','Administor'
    };

    //--- bad menu IDD's
    detectedmenus[] = {
        
    };

    //--- bad variables
    detectedvariables[] = {
        'test_ah_var'
    };
};

class CfgFunctions {
    class Life {
        class Antihack_Functions
        {
            file = "\life_backend\Functions\Antihack";
            class antihack_initialize {preInit = 1;}; 
            class antihack_systemlog {};
            class antihack_setupNetwork {};
            class antihack_getAdmins {};
        };
    };
};