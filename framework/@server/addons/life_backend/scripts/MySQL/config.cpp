class CfgPatches 
{
    class MySQL 
    {
        units[] = {};
        weapons[] = {};
        requiredAddons[] = {"Systems"};
        authors[] = {"Ni1kko"};
    };
};
 
class CfgMySQL
{
    
};

class CfgFunctions 
{
    class MPServer
    {
        class MySQL_BankFunctions
        {
            file = "\life_backend\scripts\MySQL\Bank";
            class fetchBankDataRequest {};
            class insertBankDataRequest {};
            class updateBankDataRequest {};
            class updateBankDataRequestPartial {};
        };

        class MySQL_GangFunctions
        {
            file = "\life_backend\scripts\MySQL\Gang";
            class fetchGangDataRequest {};
            class insertGangDataRequest {};
            class updateGangDataRequest {};
            class updateGangDataRequestPartial {};
        };

        class MySQL_PlayerFunctions
        {
            file = "\life_backend\scripts\MySQL\Player";
            class fetchPlayerDataRequest {};
            class insertPlayerDataRequest {};
            class updatePlayerDataRequest {};
            class updatePlayerDataRequestPartial {};
        };

        class MySQL_ServerFunctions
        {
            file = "\life_backend\scripts\MySQL\Server";
            class fetchServerDataRequest {};
            class insertServerDataRequest {};
            class updateServerDataRequest {};
            class updateServerDataRequestPartial {};
        };

        class MySQL_VehicleFunctions
        {
            file = "\life_backend\scripts\MySQL\Vehicle";
            class fetchVehicleDataRequest {};
            class insertVehicleDataRequest {};
            class updateVehicleDataRequest {};
            class updateVehicleDataRequestPartial {};
        };
    };
};