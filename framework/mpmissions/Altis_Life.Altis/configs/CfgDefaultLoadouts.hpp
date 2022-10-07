/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
    ## CfgDefaultLoadouts.hpp
*/

class CfgDefaultLoadouts 
{
    // COP
    class WEST 
    {
        uniform[] = {
            {"U_Rangemaster", "call life_copLevel >= 1"}
        };
        headgear[] = {
            {"H_Cap_blk", "call life_copLevel >= 1"}
        };
        vest[] = {
            {"V_Rangemaster_belt", "call life_copLevel >= 1"}
        };
        backpack[] = {};
        weapon[] = {
            {"hgun_P07_snds_F", "call life_copLevel >= 1"}
        };
        mags[] = {
            {"16Rnd_9x21_Mag", 6, "call life_copLevel >= 1"}
        };
        items[] = {};
        linkedItems[] = {
            {"ItemMap", "call life_copLevel >= 1"},
            {"ItemCompass", "call life_copLevel >= 1"}
        };
        vitems[] = {
            {"waterBottle", 2, "call life_copLevel >= 1"},
            {"apple", 2, "call life_copLevel >= 1"},
            {"peach", 1, "call life_copLevel >= 1"}
        }; 
    };

    // CIV
    class CIV 
    {
        uniform[] = {
            {"U_C_Poloshirt_blue", "not(player getVariable ['arrested',false])"},
            {"U_C_Poloshirt_burgundy", "not(player getVariable ['arrested',false])"},
            {"U_C_Poloshirt_stripped", "not(player getVariable ['arrested',false])"},
            {"U_C_Poloshirt_tricolour", "not(player getVariable ['arrested',false])"},
            {"U_C_Poloshirt_salmon", "not(player getVariable ['arrested',false])"},
            {"U_C_Poloshirt_redwhite", "not(player getVariable ['arrested',false])"},
            {"U_C_Commoner1_1", "not(player getVariable ['arrested',false])"}
        };
        headgear[] = {};
        vest[] = {};
        backpack[] = {};
        weapon[] = {};
        mags[] = {};
        items[] = {};
        linkedItems[] = {
            {"ItemMap", ""},
            {"ItemCompass", ""}
        };
        vitems[] = {
            {"waterBottle", 2, "not(player getVariable ['arrested',false])"},
            {"apple", 2, "not(player getVariable ['arrested',false])"},
            {"peach", 1, "not(player getVariable ['arrested',false])"}
        }; 
    };

    // REB (Temp use civ for rebel)
    class EAST : CIV {};

    // MED
    class GUER 
    {
        uniform[] = {
            {"U_Rangemaster", "call life_medLevel >= 1"}
        };
        headgear[] = {
            {"H_Cap_red", "call life_medLevel >= 1"}
        };
        vest[] = {};
        backpack[] = {};
        weapon[] = {};
        mags[] = {};
        items[] = {
            {"FirstAidKit", 2, "call life_medLevel >= 1"}
        };
        linkedItems[] = {
            {"ItemMap", "call life_medLevel >= 1"},
            {"ItemCompass", "call life_medLevel >= 1"},
        };
        vitems[] = {
            {"waterBottle", 2, "call life_medLevel >= 1"},
            {"apple", 2, "call life_medLevel >= 1"},
            {"peach", 1, "call life_medLevel >= 1"}
        }; 
    };
};
