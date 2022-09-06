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
    class TON
    {
        class System_Functions
        {
            file = "\life_backend\Functions\Systems";
            class managesc {};
            class cleanup {};
            class updateHuntingZone {};
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