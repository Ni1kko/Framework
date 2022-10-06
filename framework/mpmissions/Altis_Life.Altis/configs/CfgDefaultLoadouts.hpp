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
            {"U_Rangemaster", "call life_copLevel >= 0"}
        };
        headgear[] = {
            {"H_Cap_blk", "call life_copLevel >= 0"}
        };
        vest[] = {
            {"V_Rangemaster_belt", "call life_copLevel >= 0"}
        };
        backpack[] = {};
        weapon[] = {
            {"hgun_P07_snds_F", "call life_copLevel >= 0"}
        };
        mags[] = {
            {"16Rnd_9x21_Mag", 6, "call life_copLevel >= 0"}
        };
        items[] = {};
        linkedItems[] = {
            {"ItemMap", "call life_copLevel >= 0"},
            {"ItemCompass", "call life_copLevel >= 0"},
            {"ItemWatch", "call life_copLevel >= 0"}
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
            {"ItemCompass", ""},
            {"ItemWatch", ""}
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
            {"ItemWatch", "call life_medLevel >= 1"}
        };
    };
};
