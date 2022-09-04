class CfgPatches {
    class Life_Backend_Functions {
        units[] = {};
        weapons[] = {};
        requiredAddons[] = {};
        authors[] = {"Tonic", "Ni1kko"};
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

    class Life_Backend_Functions {
        tag = "life";

        //--- Events Functions
        class Events_Functions
        {
            file = "\life_backend\Functions\Events";
            class event_playerConnected {};
            class event_playerDisconnected {};
        };

        //--- Jail Functions
        class Jail_Sys {
            file = "\life_backend\Functions\Jail";
            class jailSys {};
        };

        //--- Utils Functions
        class Utils_Functions
        {
            file = "\life_backend\Functions\Utils";
            class util_getPlayerObject {};
            class util_randomString {};
        };

        //--- Wanted Functions
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
    };
  
    class TON_System {
        tag = "TON";

        //--- Actions Functions
        class Actions {
            file = "\life_backend\Functions\Actions";
            class pickupAction {};
        };

        //--- Gang Functions
        class Gangs {
            file = "\life_backend\Functions\Gangs";
            class insertGang {};
            class queryPlayerGang {};
            class removeGang {};
            class updateGang {};
        };

        //--- House Functions
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

        //--- PlayTime Functions
        class PlayTime {
            file = "\life_backend\Functions\PlayTime";
            class setPlayTime {};
            class getPlayTime {};
        };

        //--- World Functions
        class World {
            file = "\life_backend\Functions\World";
            class setupHospitals {};
            class setupFedralReserve {};
        };
        
        //--- Systems Functions
        class Systems {
            file = "\life_backend\Functions\Systems";
            class managesc {};
            class cleanup {};
            class updateHuntingZone {};
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
            class switchSideRequest {};
            class updateDealers {};
            class stripNpcs {};
            class setupRadioChannels {};
            class masterSchedule {};
        };
    };
};