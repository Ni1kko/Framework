class CfgPatches 
{
    class Properties
    {
        units[] = {};
        weapons[] = {};
        requiredAddons[] = {"Systems"};
        authors[] = {"Ni1kko"};
    };
};

class CfgProperties
{  
    
};

class CfgFunctions 
{
    class MPServer 
    {
        class Property_Functions
        {
            file = "\life_backend\scripts\Housing";
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