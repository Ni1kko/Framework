class CfgPatches 
{
    class Rcon 
    {
        units[] = {};
        weapons[] = {};
        requiredAddons[] = {"life_backend"};
        authors[] = {"Ni1kko"};
    };
};
 
class CfgRCON 
{
    //--- Note that for this to work you need to have serverCommandPassowrd defined in config.cfg and BE enabled
    serverPassword = "ABC7890";

    //--- auto lock
    restartAutoLock = 5;     //lock server x mins before restart

    //--- auto kick
    useAutoKick = 1;         //auto kick all players from server (1 = enabled, 0 = disabled)
    kickTime = 2;            //kick all players x mins before restart

    //--- logging
    rptlogs = 1;             //Log to RPT file
    conlogs = 1;             //Log to Console
    extlogs = 1;             //Log to Extension
    dblogs = 1;              //Log to Database (Kicks & Bans Only)

    //
    friendlyMessages[] = {
        {25,{"Follow the rules!","Need help? ask someone!","Be friendly to everyone!","Enjoy your time here :)"}},
        {35,{"Don't be that guy, keep it friendly"}}
    };

    //---
    restartTimes[] = 
    {
        "00:00",
        "04:00",
        "08:00",
        "12:00",
        "16:00",
        "20:00"
    };
    useShutdown = 1;         //(1 = shutdown, 0 = restart)
    useRestartMessages = 1;  //show restart messages
    restartWarningTime[] = { //restart messages intervals x,x,x... mins before restarts
        15,
        10,
        5,
        3
    };
};

class CfgFunctions 
{
    class MPServer 
    {
        class Rcon_Functions
        {
            file = "\life_backend\Functions\Rcon";
            class rcon_initialize {preInit = 1;};
            class rcon_ban {};
            class rcon_kick {};
            class rcon_kickAll {};
            class rcon_queuedMessages {};
            class rcon_sendBroadcast {};
            class rcon_sendCommand {};
            class rcon_setupEvents {};
            class rcon_systemlog {};
        };
    };
};