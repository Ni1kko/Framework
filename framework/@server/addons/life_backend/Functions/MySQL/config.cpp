class CfgPatches 
{
    class MySQL 
    {
        units[] = {};
        weapons[] = {};
        requiredAddons[] = {};
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
};