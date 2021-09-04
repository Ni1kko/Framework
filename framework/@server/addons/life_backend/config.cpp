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

rptFileLimit=1;

class CfgFunctions {
    class MySQL_Database {
        tag = "DB";
        class MySQL
        {
            file = "\life_backend\Functions\MySQL";
            class numberSafe {};
            class mresArray {};
            class queryRequest{};
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
            class whoDoneIt {};
            class index {};
            class player_query {};
            class isNumber {};
            class clientGangKick {};
            class clientGetKey {};
            class clientGangLeader {};
            class clientGangLeft {};
            class clientMessageRequest {};
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
