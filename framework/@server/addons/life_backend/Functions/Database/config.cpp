class CfgPatches {
    class Database {
        units[] = {};
        weapons[] = {};
        requiredAddons[] = {"Rcon"};
        authors[] = {"Torndeco","Ni1kko"};
    };
};
 
class CfgExtDB
{
    profile = "frameworkDB";         //Database profile setup in `extdb3-conf.ini`  
    sqlcustom = 0;                   //Enable prepared calls
    sqlcustomfile = "lifesqlcustom"; //File name of `custom.ini`

    //--- logging
    rptlogs = 1;             //Log to RPT file
    conlogs = 1;             //Log to Console
    extlogs = 0;             //Log to Extension

    //--- Misc
    debugMode = 1;          //Enable many server/hc debugging logs. Default: 0 (1 = Enabled / 0 = Disabled)
    headlessclient = 1;     //headlessclient is set to 1 (enabled), the server will run without fault when no Headless Client is connected. However, it will support the Headless Client if you choose to connect one.
    headlessclients[] = {
        "76561198276956558"
    };

    //--- procedures to run after database connects
    startup_procedures[] = {
        "increaseServerRestarts",
        "resetActivePlayerList",
        "resetLifeVehicles",
        "deleteDeadVehicles",
        "deleteOldHouses",
        "deleteOldGangs",
        "deleteDeadTents",
        "deleteOldLotteryTickets",
        "deleteClaimedLotteryTickets",
        "deleteCompletedRemoteExecRequests"
    };
};

class CfgFunctions {
    class Life {
        class Database_Functions
        {
            file = "\life_backend\Functions\Database";
            class database_initialize {preInit = 1;};
            class database_initializeHC {};
            class database_rawasync_request {};
            class database_prepared_request {};
            class database_request {};
            class database_parse {};
            class database_systemlog {};
        };
    };
};