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
            class queryRequest{};
            class insertRequest{};
            class updateRequest{};
            class loadServer {};
            class insertVehicle {};
            class updatePartial {};
            class queryBankAccount {};
        };
    };
};