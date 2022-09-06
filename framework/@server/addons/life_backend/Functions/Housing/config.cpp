class CfgPatches 
{
    class Properties
    {
        units[] = {};
        weapons[] = {};
        requiredAddons[] = {"Database"};
        authors[] = {"Ni1kko"};
    };
};

class CfgProperties
{  
    
};

class CfgFunctions 
{
    class TON 
    {
        class Property_Functions
        {
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
    };
};