class DefaultEventhandlers;
class CfgPatches {
    class life_backend {
        units[] = {"C_man_1"};
        weapons[] = {};
        requiredAddons[] = {"A3_Data_F","A3_Soft_F","A3_Soft_F_Offroad_01","A3_Characters_F"};
        fileName = "life_backend.pbo";
        author = "Tonic";
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
    restartTimer[] = {4, 0}; //restart server after {x hours, y minuets}
    useShutdown = 1;         //(1 = shutdown, 0 = restart)
    useRestartMessages = 1;  //show restart messages
    restartWarningTime[] = { //restart messages intervals x,x,x... mins before restarts
        15,
        10,
        5,
        3
    };
};

class CfgFunctions {
    class MySQL_Database {
        tag = "DB";
        class MySQL
        {
            file = "\life_backend\Functions\MySQL";
            class numberSafe {};
            class mresArray {};
            class queryRequest{};
            class asyncCall{};
            class insertRequest{};
            class updateRequest{};
            class mresToArray {};
            class loadServer {};
            class insertVehicle {};
            class bool {};
            class mresString {};
            class updatePartial {};
        };
    };

    class Life_System {
        tag = "life";
        class Root {
            file = "\life_backend";
            class preInit {preInit = 1;};
        };

        class Wanted_Sys {
            file = "\life_backend\Functions\WantedSystem";
            class wantedFetch {};
            class wantedPerson {};
            class wantedBounty {};
            class wantedRemove {};
            class wantedAdd {};
            class wantedCrimes {};
            class wantedProfUpdate {};
        };

        //--- RCON Functions
        class Rcon_Functions {
            file = "\life_backend\Functions\Rcon";
            class rcon_initialize {};
            class rcon_ban {};
            class rcon_kick {};
            class rcon_kickAll {};
            class rcon_queuedmessages_thread {};
            class rcon_sendBroadcast {};
            class rcon_sendCommand {};
            class rcon_setupEvents {};
            class rcon_systemlog {};
        };

        //--- Database Functions
        class Database_Functions
        {
            file = "\life_backend\Functions\Database";
            class database_initialize {};
            class database_request {};
            class database_parse {};
        };

        //--- Events Functions
        class Events_Functions
        {
            file = "\life_backend\Functions\Events";
            class event_playerConnected {};
            class event_playerDisconnected {};
        };

        //--- Utils Functions
        class Utils_Functions
        {
            file = "\life_backend\Functions\Utils";
            class util_getPlayerObject {};
            class util_randomString {};
        };

        class Jail_Sys {
            file = "\life_backend\Functions\Jail";
            class jailSys {};
        };

        class Client_Code {
            file = "\life_backend\Functions\Client";
        };
    };
    class LifeFSM {
        class FiniteStateMachine
        {
            file="\life_backend\FSM";
            class cleanup {ext=".fsm";};
            class timeModule {ext=".fsm";};
        };
    };

    class TON_System {
        tag = "TON";

        class Systems {
            file = "\life_backend\Functions\Systems";
            class managesc {};
            class cleanup {};
            class huntingZone {};
            class getID {};
            class vehicleCreate {};
            class spawnVehicle {};
            class getVehicles {};
            class vehicleStore {};
            class vehicleDelete {};
            class spikeStrip {};
            class transferOwnership {};
            class federalUpdate {};
            class chopShopSell {};
            class clientDisconnect {};
            class entityRespawned {};
            class cleanupRequest {};
            class keyManagement {};
            class vehicleUpdate {};
            class recupkeyforHC {};
            class handleBlastingCharge {};
            class terrainSort {};
            class fix_headgear {};
            class setupHeadlessClient {};
            class whoDoneIt {};
            class index {};
            class player_query {};
            class isNumber {};
            class clientGangKick {};
            class clientGetKey {};
            class clientGangLeader {};
            class clientGangLeft {};
            class cell_emsrequest {};
            class cell_textmsg {};
            class cell_textcop {};
            class cell_textadmin {};
            class cell_adminmsg {};
            class cell_adminmsgall {};
            class clientMessage {};
        };

        class Housing {
            file = "\life_backend\Functions\Housing";
            class addHouse {};
            class addContainer {};
            class deleteDBContainer {};
            class fetchPlayerHouses {};
            class initHouses {};
            class sellHouse {};
            class sellHouseContainer {};
            class updateHouseContainers {};
            class updateHouseTrunk {};
            class houseCleanup {};
            class houseGarage {};
        };

        class Gangs {
            file = "\life_backend\Functions\Gangs";
            class insertGang {};
            class queryPlayerGang {};
            class removeGang {};
            class updateGang {};
        };

        class Actions {
            file = "\life_backend\Functions\Actions";
            class pickupAction {};
        };

        class PlayTime {
            file = "\life_backend\Functions\PlayTime";
            class setPlayTime {};
            class getPlayTime {};
        };
    };
};

class CfgVehicles {
    class Car_F;
    class CAManBase;
    class Civilian;
    class Civilian_F : Civilian {
        class EventHandlers;
    };

    class C_man_1 : Civilian_F {
        class EventHandlers: EventHandlers {
            init = "(_this select 0) spawn TON_fnc_fix_headgear;";
        };
    };
};
