class CfgPatches 
{
    class Systems
    {
        units[] = {};
        weapons[] = {};
        requiredAddons[] = {"Database"};
        authors[] = {"Ni1kko"};
    };
};
 
class CfgSystems
{
    
};

class CfgFunctions 
{
    class MPServer
    {
        class System_Functions
        {
            file = "\life_backend\scripts\Systems";
            class managesc {};
            class cleanup {};
            class spikeStrip {};
            class transferOwnership {};
            class updateBanks {};
            class chopShopSell {};
            class clientDisconnect {};
            class entityRespawned {};
            class cleanupRequest {};
            class keyManagement {};
            class recupkeyforHC {};
            class handleBlastingCharge {};
            class terrainSort {};
            class fix_headgear {};
            class whoDoneIt {};
            class index {};
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
            class log {};
            class handleMoneyRequest {};
        };
    };
};