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
        class MySQL_Functions
        {
            file = "\life_backend\scripts\MySQL";
            class fetchBankDataRequest {};
            class fetchPlayerDataRequest{};
            class fetchServerDataRequest {};
            class insertPlayerDataRequest{};
            class insertVehicleDataRequest {};
            class updateBankDataRequest {};
            class updatePlayerDataRequest {};
            class updatePlayerDataRequestPartial {};
        };
    };
};