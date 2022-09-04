#include "..\script_macros.hpp"

/*
*    FORMAT:
*        STRING (Conditions) - Must return boolean :
*            String can contain any amount of conditions, aslong as the entire
*            string returns a boolean. This allows you to check any levels, licenses etc,
*            in any combination. For example:
*                "call life_coplevel && license_civ_someLicense"
*            This will also let you call any other function.
*/
class VirtualShops {
    //Virtual Shops
    class market {
        name = "STR_Shops_Market";
        side = "civ";
        conditions = "";
        items[] = { "waterBottle", "rabbit", "apple", "redgull", "tbacon", "pickaxe", "toolkit", "fuelFull", "peach", "storagesmall", "storagebig", "rabbit_raw", "hen_raw", "rooster_raw", "sheep_raw", "goat_raw" };
    };

    class med_market {
        name = "STR_Shops_Market";
        side = "med";
        conditions = "";
        items[] = { "waterBottle", "rabbit", "apple", "redgull", "tbacon", "toolkit", "fuelFull", "peach", "defibrillator" };
    };

    class rebel {
        name = "STR_Shops_Rebel";
        side = "civ";
        conditions = "license_civ_rebel";
        items[] = { "tentKit", "waterBottle", "rabbit", "apple", "redgull", "tbacon", "lockpick", "pickaxe", "toolkit", "fuelFull", "peach", "boltcutter", "blastingcharge" };
    };

    class gang {
        name = "STR_Shops_Gang";
        side = "civ";
        conditions = "";
        items[] = { "tentKit", "waterBottle", "rabbit", "apple", "redgull", "tbacon", "lockpick", "pickaxe", "toolkit", "fuelFull", "peach", "boltcutter", "blastingcharge" };
    };

    class wongs {
        name = "STR_Shops_Wongs";
        side = "civ";
        conditions = "";
        items[] = { "turtle_soup", "turtle_raw" };
    };

    class coffee {
        name = "STR_Shops_Coffee";
        side = "civ";
        conditions = "";
        items[] = { "coffee", "donuts" };
    };

    class f_station_coffee {
        name = "STR_Shop_Station_Coffee";
        side = "";
        conditions = "";
        items[] = { "coffee", "donuts", "redgull", "toolkit", "fuelFull"};
    };

    class drugdealer {
        name = "STR_Shops_DrugDealer";
        side = "civ";
        conditions = "";
        items[] = { "cocaine_processed", "heroin_processed", "marijuana" };
    };

    class oil {
        name = "STR_Shops_Oil";
        side = "civ";
        conditions = "";
        items[] = { "oil_processed", "pickaxe", "fuelFull" };
    };

    class fishmarket {
        name = "STR_Shops_FishMarket";
        side = "civ";
        conditions = "";
        items[] = { "salema_raw", "salema", "ornate_raw", "ornate", "mackerel_raw", "mackerel", "tuna_raw", "tuna", "mullet_raw", "mullet", "catshark_raw", "catshark" };
    };

    class glass {
        name = "STR_Shops_Glass";
        side = "civ";
        conditions = "";
        items[] = { "glass" };
    };

    class iron  {
        name = "STR_Shops_Minerals";
        side = "civ";
        conditions = "";
        items[] = { "iron_refined", "copper_refined" };
    };

    class diamond {
        name = "STR_Shops_Diamond";
        side = "civ";
        conditions = "";
        items[] = { "diamond_uncut", "diamond_cut" };
    };

    class salt {
        name = "STR_Shops_Salt";
        side = "civ";
        conditions = "";
        items[] = { "salt_refined" };
    };

    class cement {
        name = "STR_Shops_Cement";
        side = "civ";
        conditions = "";
        items[] = { "cement" };
    };

    class gold {
        name = "STR_Shops_Gold";
        side = "civ";
        conditions = "";
        items[] = { "goldbar" };
    };

    class cop {
        name = "STR_Shops_Cop";
        side = "cop";
        conditions = "";
        items[] = { "donuts", "coffee", "spikeStrip", "waterBottle", "rabbit", "apple", "redgull", "toolkit", "fuelFull", "defusekit", "defibrillator" };
    };

    class bountyhunter {
		name = "STR_Shops_bountyHunter";
        side = "civ";
        conditions = "";
		items[] = {
			"waterBottle",
			"rabbit",
			"apple"
			"redgull",
			"tbacon",
			"lockpick",
			"pickaxe",
			"fuelFull"
		};
	};
};

/*
*    CLASS:
*        variable = Variable Name
*        displayName = Item Name
*        weight = Item Weight
*        buyPrice = Item Buy Price
*        sellPrice = Item Sell Price
*        illegal = Illegal Item
*        edible = Item Edible (-1 = Disabled, other values = added value)
*        drinkable = Item Drinkable (-1 = Disabled, other values = added value)
*        icon = Item Icon
*        object = name of object that will be used when droping item
*/
class VirtualItems 
{
    //--- Misc
    class money {
        variable = VITEM_MISC_MONEY;
        displayName = "STR_Item_Money";
        weight = 0;
        buyPrice = -1;
        sellPrice = -1;
        illegal = false;
        edible = -1;
        drinkable = -1;
        icon = "";
        object = "Land_Money_F";
    };

    class pickaxe {
        variable = VITEM_MISC_PICKAXE;
        displayName = "STR_Item_Pickaxe";
        weight = 2;
        buyPrice = 750;
        sellPrice = 350;
        illegal = false;
        edible = -1;
        drinkable = -1;
        icon = "icons\ico_pickaxe.paa";
        object = "Land_Suitcase_F";
    };

    class defibrillator {
        variable = VITEM_MISC_DEFIBILLATOR;
        displayName = "STR_Item_Defibrillator";
        weight = 4;
        buyPrice = 900;
        sellPrice = 450;
        illegal = false;
        edible = -1;
        drinkable = -1;
        icon = "icons\ico_defibrillator.paa";
        object = "Land_Suitcase_F";
    };

    class toolkit {
        variable = VITEM_MISC_TOOLKIT;
        displayName = "STR_Item_Toolkit";
        weight = 4;
        buyPrice = 350;
        sellPrice = 100;
        illegal = false;
        edible = -1;
        drinkable = -1;
        icon = "\a3\weapons_f\items\data\UI\gear_toolkit_ca.paa";
        object = "Land_Suitcase_F";
    };

    class tentKit {
        variable = VITEM_MISC_TENTKIT;
        displayName = "STR_Item_Tentkit";
        weight = 30;
        buyPrice = 12000;
        sellPrice = 8000;
        illegal = false;
        edible = -1;
        drinkable = -1;
        icon = "";//TODO: make icon
        object = "Land_Ground_sheet_folded_khaki_F";
    };

    class fuelEmpty {
        variable = VITEM_MISC_FUELCAN_EMPTY;
        displayName = "STR_Item_FuelE";
        weight = 2;
        buyPrice = -1;
        sellPrice = 10;
        illegal = false;
        edible = -1;
        drinkable = -1;
        icon = "icons\ico_fuelEmpty.paa";
        object = "Land_CanisterFuel_F";
    };

    class fuelFull {
        variable = VITEM_MISC_FUELCAN_FULL;
        displayName = "STR_Item_FuelF";
        weight = 5;
        buyPrice = 850;
        sellPrice = 500;
        illegal = false;
        edible = -1;
        drinkable = -1;
        icon = "icons\ico_fuel.paa";
        object = "Land_CanisterFuel_F";
    };

    class spikeStrip {
        variable = VITEM_MISC_SPIKESTRIP;
        displayName = "STR_Item_SpikeStrip";
        weight = 15;
        buyPrice = 2500;
        sellPrice = 1200;
        illegal = true;
        edible = -1;
        drinkable = -1;
        icon = "icons\ico_spikeStrip.paa";
        object = "Land_Suitcase_F";
    };

    class lockpick {
        variable = VITEM_MISC_LOCKPICK;
        displayName = "STR_Item_Lockpick";
        weight = 1;
        buyPrice = 150;
        sellPrice = 75;
        illegal = true;
        edible = -1;
        drinkable = -1;
        icon = "icons\ico_lockpick.paa";
        object = "Land_Suitcase_F";
    };

    class goldbar {
        variable = VITEM_MISC_GOLDBAR;
        displayName = "STR_Item_GoldBar";
        weight = 12;
        buyPrice = -1;
        sellPrice = 95000;
        illegal = true;
        edible = -1;
        drinkable = -1;
        icon = "icons\ico_goldBar.paa";
        object = "Land_Suitcase_F";
    };

    class blastingcharge {
        variable = "blastingCharge";
        displayName = "STR_Item_BCharge";
        weight = 15;
        buyPrice = 35000;
        sellPrice = 10000;
        illegal = true;
        edible = -1;
        drinkable = -1;
        icon = "icons\ico_blastingCharge.paa";
        object = "Land_Suitcase_F";
    };

    class boltcutter {
        variable = VITEM_MISC_BOLTCUTTERS;
        displayName = "STR_Item_BCutter";
        weight = 5;
        buyPrice = 7500;
        sellPrice = 1000;
        illegal = true;
        edible = -1;
        drinkable = -1;
        icon = "icons\ico_boltCutter.paa";
        object = "Land_Suitcase_F";
    };

    class defusekit {
        variable = VITEM_MISC_DEFUSEKIT;
        displayName = "STR_Item_DefuseKit";
        weight = 2;
        buyPrice = 2500;
        sellPrice = 2000;
        illegal = true;
        edible = -1;
        drinkable = -1;
        icon = "icons\ico_defuseKit.paa";
        object = "Land_Suitcase_F";
    };

    class storagesmall {
        variable = VITEM_MISC_STORAGEBOX_S;
        displayName = "STR_Item_StorageBS";
        weight = 5;
        buyPrice = 75000;
        sellPrice = 50000;
        illegal = false;
        edible = -1;
        drinkable = -1;
        icon = "icons\ico_storageSmall.paa";
        object = "Land_Suitcase_F";
    };

    class storagebig {
        variable = VITEM_MISC_STORAGEBOX_L;
        displayName = "STR_Item_StorageBL";
        weight = 10;
        buyPrice = 150000;
        sellPrice = 125000;
        illegal = false;
        edible = -1;
        drinkable = -1;
        icon = "icons\ico_storageBig.paa";
        object = "Land_Suitcase_F";
    };

    //---Mined Items
    class oil_unprocessed {
        variable = VITEM_MINED_CRUDE_OIL;
        displayName = "STR_Item_OilU";
        weight = 7;
        buyPrice = -1;
        sellPrice = -1;
        illegal = false;
        edible = -1;
        drinkable = -1;
        icon = "icons\ico_oilUnprocessed.paa";
        object = "Land_Suitcase_F";
    };

    class oil_processed {
        variable = VITEM_MINED_OIL;
        displayName = "STR_Item_OilP";
        weight = 6;
        buyPrice = -1;
        sellPrice = 3200;
        illegal = false;
        edible = -1;
        drinkable = -1;
        icon = "icons\ico_oilProcessed.paa";
        object = "Land_Suitcase_F";
    };

    class copper_unrefined {
        variable = VITEM_MINED_COPPER_SULFIDE_ORES;
        displayName = "STR_Item_CopperOre";
        weight = 4;
        buyPrice = -1;
        sellPrice = -1;
        illegal = false;
        edible = -1;
        drinkable = -1;
        icon = "icons\ico_copperOre.paa";
        object = "Land_Suitcase_F";
    };

    class copper_refined {
        variable = VITEM_MINED_COPPER;
        displayName = "STR_Item_CopperIngot";
        weight = 3;
        buyPrice = -1;
        sellPrice = 1500;
        illegal = false;
        edible = -1;
        drinkable = -1;
        icon = "icons\ico_copper.paa";
        object = "Land_Suitcase_F";
    };

    class iron_unrefined {
        variable = VITEM_MINED_IRON_ORE;
        displayName = "STR_Item_IronOre";
        weight = 5;
        buyPrice = -1;
        sellPrice = -1;
        illegal = false;
        edible = -1;
        drinkable = -1;
        icon = "icons\ico_ironOre.paa";
        object = "Land_Suitcase_F";
    };

    class iron_refined {
        variable = VITEM_MINED_IRON;
        displayName = "STR_Item_IronIngot";
        weight = 3;
        buyPrice = -1;
        sellPrice = 3200;
        illegal = false;
        edible = -1;
        drinkable = -1;
        icon = "icons\ico_iron.paa";
        object = "Land_Suitcase_F";
    };

    class salt_unrefined {
        variable = VITEM_MINED_SALT_BRINE;
        displayName = "STR_Item_Salt";
        weight = 3;
        buyPrice = -1;
        sellPrice = -1;
        illegal = false;
        edible = -1;
        drinkable = -1;
        icon = "icons\ico_saltUnprocessed.paa";
        object = "Land_Suitcase_F";
    };

    class salt_refined {
        variable = VITEM_MINED_SALT;
        displayName = "STR_Item_SaltR";
        weight = 1;
        buyPrice = -1;
        sellPrice = 1450;
        illegal = false;
        edible = -1;
        drinkable = -1;
        icon = "icons\ico_saltProcessed.paa";
        object = "Land_Suitcase_F";
    };

    class sand {
        variable = VITEM_MINED_SAND;
        displayName = "STR_Item_Sand";
        weight = 3;
        buyPrice = -1;
        sellPrice = -1;
        illegal = false;
        edible = -1;
        drinkable = -1;
        icon = "icons\ico_sand.paa";
        object = "Land_Suitcase_F";
    };

    class glass {
        variable = VITEM_MINED_GLASS;
        displayName = "STR_Item_Glass";
        weight = 1;
        buyPrice = -1;
        sellPrice = 1450;
        illegal = false;
        edible = -1;
        drinkable = -1;
        icon = "icons\ico_glass.paa";
        object = "Land_Suitcase_F";
    };

    class diamond_uncut {
        variable = VITEM_MINED_DIAMOND_ORE;
        displayName = "STR_Item_DiamondU";
        weight = 4;
        buyPrice = -1;
        sellPrice = 750;
        illegal = false;
        edible = -1;
        drinkable = -1;
        icon = "icons\ico_diamondUncut.paa";
        object = "Land_Suitcase_F";
    };

    class diamond_cut {
        variable = VITEM_MINED_DIAMOND;
        displayName = "STR_Item_DiamondC";
        weight = 2;
        buyPrice = -1;
        sellPrice = 2000;
        illegal = false;
        edible = -1;
        drinkable = -1;
        icon = "icons\ico_diamondCut.paa";
        object = "Land_Suitcase_F";
    };

    class rock {
        variable = VITEM_MINED_ROCK;
        displayName = "STR_Item_Rock";
        weight = 6;
        buyPrice = -1;
        sellPrice = -1;
        illegal = false;
        edible = -1;
        drinkable = -1;
        icon = "icons\ico_rock.paa";
        object = "Land_Suitcase_F";
    };

    class cement {
        variable = VITEM_MINED_CEMENT;
        displayName = "STR_Item_CementBag";
        weight = 5;
        buyPrice = -1;
        sellPrice = 1950;
        illegal = false;
        edible = -1;
        drinkable = -1;
        icon = "icons\ico_cement.paa";
        object = "Land_Suitcase_F";
    };

    //--- Drugs
    class opium_poppy {
        variable = VITEM_DRUG_OPIUM_POPPY;
        displayName = "STR_Item_OpiumpoppyU";
        weight = 6;
        buyPrice = -1;
        sellPrice = -1;
        illegal = true;
        edible = -1;
        drinkable = -1;
        icon = "icons\ico_opiumpoppy.paa";
        object = "Land_Suitcase_F";
    };

    class heroin_processed {
        variable = VITEM_DRUG_HEROIN;
        displayName = "STR_Item_HeroinP";
        weight = 4;
        buyPrice = 3500;
        sellPrice = 2560;
        illegal = true;
        edible = -1;
        drinkable = -1;
        icon = "icons\ico_heroinProcessed.paa";
        object = "Land_Suitcase_F";
    };

    class morphine {
        variable = VITEM_DRUG_MORPHINE;
        displayName = "Morphine";
        weight = 4;
        buyPrice = -1;
        sellPrice = 10000;
        illegal = true;
        edible = -1;
        drinkable = -1;
        icon = "icons\ico_morpine.paa";//need image
        object = "Land_Suitcase_F";
    };

    class codeine {
        variable = VITEM_DRUG_CODEINE;
        displayName = "Codeine";
        weight = 1;
        buyPrice = 2000;
        sellPrice = 2700;
        illegal = false;
        edible = 1;
        drinkable = 1;
        icon = "icons\ico_codeine.paa";//need image
        object = "Land_Suitcase_F";
    };

    class marijuanaWet {
        variable = VITEM_DRUG_CANNABIS_WET;
        displayName = "Marijuana Wet";
        weight = 4;
        buyPrice = -1;
        sellPrice = -1;
        illegal = true;
        edible = -1;
        drinkable = -1;
        icon = "icons\ico_cannabis.paa";
        object = "Land_Suitcase_F";
    };

    class marijuana {
        variable = VITEM_DRUG_CANNABIS;
        displayName = "Marijuana";
        weight = 3;
        buyPrice = 2800;
        sellPrice = 2350;
        illegal = true;
        edible = -1;
        drinkable = -1;
        icon = "icons\ico_marijuana.paa";
        object = "Land_Suitcase_F";
    };

    class cocaine_unprocessed {
        variable = VITEM_DRUG_COCA_LEAFS;
        displayName = "STR_Item_CocaineU";
        weight = 6;
        buyPrice = -1;
        sellPrice = -1;
        illegal = true;
        edible = -1;
        drinkable = -1;
        icon = "icons\ico_cocaineUnprocessed.paa";
        object = "Land_Suitcase_F";
    };

    class cocaine_processed {
        variable = VITEM_DRUG_COCAINE;
        displayName = "STR_Item_CocaineP";
        weight = 4;
        buyPrice = -1;
        sellPrice = 5000;
        illegal = true;
        edible = -1;
        drinkable = -1;
        icon = "icons\ico_cocaineProcessed.paa";
        object = "Land_Suitcase_F";
    };

    //--- Drinks
    class redgull {
        variable = VITEM_DRINK_REDGULL;
        displayName = "STR_Item_RedGull";
        weight = 1;
        buyPrice = 1500;
        sellPrice = 200;
        illegal = false;
        edible = -1;
        drinkable = 50;
        icon = "icons\ico_redgull.paa";
        object = "Land_Can_V3_F";
    };

    class coffee {
        variable = VITEM_DRINK_COFFEE;
        displayName = "STR_Item_Coffee";
        weight = 1;
        buyPrice = 10;
        sellPrice = 5;
        illegal = false;
        edible = -1;
        drinkable = 100;
        icon = "icons\ico_coffee.paa";
        object = "Land_Can_V3_F";
    };

    class waterBottle {
        variable = VITEM_DRINK_WATER;
        displayName = "STR_Item_WaterBottle";
        weight = 1;
        buyPrice = 10;
        sellPrice = 5;
        illegal = false;
        edible = -1;
        drinkable = 100;
        icon = "icons\ico_waterBottle.paa";
        object = "Land_BottlePlastic_V1_F";
    };

    //---Food
    class apple {
        variable = VITEM_FOOD_APPLE;
        displayName = "STR_Item_Apple";
        weight = 1;
        buyPrice = 65;
        sellPrice = 50;
        illegal = false;
        edible = 10;
        drinkable = -1;
        icon = "icons\ico_apple.paa";
        object = "Land_Suitcase_F";
    };

    class peach {
        variable = VITEM_FOOD_PEACH;
        displayName = "STR_Item_Peach";
        weight = 1;
        buyPrice = 68;
        sellPrice = 55;
        illegal = false;
        edible = 10;
        drinkable = -1;
        icon = "icons\ico_peach.paa";
        object = "Land_Suitcase_F";
    };

    class tbacon {
        variable = VITEM_FOOD_BACON;
        displayName = "STR_Item_TBacon";
        weight = 1;
        buyPrice = 75;
        sellPrice = 25;
        illegal = false;
        edible = 40;
        drinkable = -1;
        icon = "icons\ico_tBacon.paa";
        object = "Land_TacticalBacon_F";
    };

    class donuts {
        variable = VITEM_FOOD_DONUTS;
        displayName = "STR_Item_Donuts";
        weight = 1;
        buyPrice = 120;
        sellPrice = 60;
        illegal = false;
        edible = 30;
        drinkable = -1;
        icon = "icons\ico_donuts.paa";
        object = "Land_Suitcase_F";
    };

    class rabbit_raw {
        variable = VITEM_FOOD_RAW_RABBIT;
        displayName = "STR_Item_RabbitRaw";
        weight = 2;
        buyPrice = -1;
        sellPrice = 95;
        illegal = false;
        edible = -1;
        drinkable = -1;
        icon = "icons\ico_rabbitRaw.paa";
        object = "Land_Suitcase_F";
    };

    class rabbit {
        variable = VITEM_FOOD_RABBIT;
        displayName = "STR_Item_Rabbit";
        weight = 1;
        buyPrice = 150;
        sellPrice = 115;
        illegal = false;
        edible = 20;
        drinkable = -1;
        icon = "icons\ico_rabbit.paa";
        object = "Land_Suitcase_F";
    };

    class salema_raw {
        variable = VITEM_FOOD_RAW_SALEMA;
        displayName = "STR_Item_SalemaRaw";
        weight = 2;
        buyPrice = -1;
        sellPrice = 45;
        illegal = false;
        edible = -1;
        drinkable = -1;
        icon = "icons\ico_salemaRaw.paa";
        object = "Land_Suitcase_F";
    };

    class salema {
        variable = VITEM_FOOD_SALEMA;
        displayName = "STR_Item_Salema";
        weight = 1;
        buyPrice = 75;
        sellPrice = 55;
        illegal = false;
        edible = 30;
        drinkable = -1;
        icon = "icons\ico_cookedFish.paa";
        object = "Land_Suitcase_F";
    };

    class ornate_raw {
        variable = VITEM_FOOD_RAW_ORNATE;
        displayName = "STR_Item_OrnateRaw";
        weight = 2;
        buyPrice = -1;
        sellPrice = 40;
        illegal = false;
        edible = -1;
        drinkable = -1;
        icon = "icons\ico_ornateRaw.paa";
        object = "Land_Suitcase_F";
    };

    class ornate {
        variable = VITEM_FOOD_ORNATE;
        displayName = "STR_Item_Ornate";
        weight = 1;
        buyPrice = 175;
        sellPrice = 150;
        illegal = false;
        edible = 25;
        drinkable = -1;
        icon = "icons\ico_cookedFish.paa";
        object = "Land_Suitcase_F";
    };

    class mackerel_raw {
        variable = VITEM_FOOD_RAW_MACKREL;
        displayName = "STR_Item_MackerelRaw";
        weight = 4;
        buyPrice = -1;
        sellPrice = 175;
        illegal = false;
        edible = -1;
        drinkable = -1;
        icon = "icons\ico_mackerelRaw.paa";
        object = "Land_Suitcase_F";
    };

    class mackerel {
        variable = VITEM_FOOD_MACKREL;
        displayName = "STR_Item_Mackerel";
        weight = 2;
        buyPrice = 250;
        sellPrice = 200;
        illegal = false;
        edible = 30;
        drinkable = -1;
        icon = "icons\ico_cookedFish.paa";
        object = "Land_Suitcase_F";
    };

    class tuna_raw {
        variable = VITEM_FOOD_RAW_TUNA;
        displayName = "STR_Item_TunaRaw";
        weight = 6;
        buyPrice = -1;
        sellPrice = 700;
        illegal = false;
        edible = -1;
        drinkable = -1;
        icon = "icons\ico_tunaRaw.paa";
        object = "Land_Suitcase_F";
    };

    class tuna {
        variable = VITEM_FOOD_TUNA;
        displayName = "STR_Item_Tuna";
        weight = 3;
        buyPrice = 1250;
        sellPrice = 1000;
        illegal = false;
        edible = 100;
        drinkable = -1;
        icon = "icons\ico_cookedFish.paa";
        object = "Land_Suitcase_F";
    };

    class mullet_raw {
        variable = VITEM_FOOD_RAW_MULLET;
        displayName = "STR_Item_MulletRaw";
        weight = 4;
        buyPrice = -1;
        sellPrice = 250;
        illegal = false;
        edible = -1;
        drinkable = -1;
        icon = "icons\ico_mulletRaw.paa";
        object = "Land_Suitcase_F";
    };

    class mullet {
        variable = VITEM_FOOD_MULLET;
        displayName = "STR_Item_Mullet";
        weight = 2;
        buyPrice = 600;
        sellPrice = 400;
        illegal = false;
        edible = 80;
        drinkable = -1;
        icon = "icons\ico_cookedFish.paa";
        object = "Land_Suitcase_F";
    };

    class catshark_raw {
        variable = VITEM_FOOD_RAW_CATSHARK;
        displayName = "STR_Item_CatSharkRaw";
        weight = 6;
        buyPrice = -1;
        sellPrice = 300;
        illegal = false;
        edible = -1;
        drinkable = -1;
        icon = "icons\ico_catsharkRaw.paa";
        object = "Land_Suitcase_F";
    };

    class catshark {
        variable = VITEM_FOOD_CATSHARK;
        displayName = "STR_Item_CatShark";
        weight = 3;
        buyPrice = 750;
        sellPrice = 500;
        illegal = false;
        edible = 100;
        drinkable = -1;
        icon = "icons\ico_cookedFish.paa";
        object = "Land_Suitcase_F";
    };

    class turtle_raw {
        variable = VITEM_FOOD_RAW_TURTLE;
        displayName = "STR_Item_TurtleRaw";
        weight = 6;
        buyPrice = -1;
        sellPrice = 3000;
        illegal = true;
        edible = -1;
        drinkable = -1;
        icon = "icons\ico_turtleRaw.paa";
        object = "Land_Suitcase_F";
    };

    class turtle_soup {
        variable = VITEM_FOOD_TURTLESOUP;
        displayName = "STR_Item_TurtleSoup";
        weight = 2;
        buyPrice = 1000;
        sellPrice = 750;
        illegal = false;
        edible = 100;
        drinkable = -1;
        icon = "icons\ico_turtleSoup.paa";
        object = "Land_Suitcase_F";
    };

    class hen_raw {
        variable = VITEM_FOOD_RAW_HEN;
        displayName = "STR_Item_HenRaw";
        weight = 1;
        buyPrice = -1;
        sellPrice = 65;
        illegal = false;
        edible = -1;
        drinkable = -1;
        icon = "icons\ico_wholeChickenRaw.paa";
        object = "Land_Suitcase_F";
    };

    class hen {
        variable = VITEM_FOOD_HEN;
        displayName = "STR_Item_Hen";
        weight = 1;
        buyPrice = 115;
        sellPrice = 85;
        illegal = false;
        edible = 65;
        drinkable = -1;
        icon = "icons\ico_wholeChicken.paa";
        object = "Land_Suitcase_F";
    };

    class rooster_raw {
        variable = VITEM_FOOD_RAW_ROOSTER;
        displayName = "STR_Item_RoosterRaw";
        weight = 1;
        buyPrice = -1;
        sellPrice = 65;
        illegal = false;
        edible = -1;
        drinkable = -1;
        icon = "icons\ico_chickenDrumstickRaw.paa";
        object = "Land_Suitcase_F";
    };

    class rooster {
        variable = VITEM_FOOD_ROOSTER;
        displayName = "STR_Item_Rooster";
        weight = 115;
        buyPrice = 90;
        sellPrice = 85;
        illegal = false;
        edible = 45;
        drinkable = -1;
        icon = "icons\ico_chickenDrumstick.paa";
        object = "Land_Suitcase_F";
    };

    class sheep_raw {
        variable = VITEM_FOOD_RAW_SHEEP;
        displayName = "STR_Item_SheepRaw";
        weight = 2;
        buyPrice = -1;
        sellPrice = 95;
        illegal = false;
        edible = -1;
        drinkable = -1;
        icon = "icons\ico_lambChopRaw.paa";
        object = "Land_Suitcase_F";
    };

    class sheep {
        variable = VITEM_FOOD_SHEEP;
        displayName = "STR_Item_Sheep";
        weight = 2;
        buyPrice = 155;
        sellPrice = 115;
        illegal = false;
        edible = 100;
        drinkable = -1;
        icon = "icons\ico_lambChop.paa";
        object = "Land_Suitcase_F";
    };

    class goat_raw {
        variable = VITEM_FOOD_RAW_GOAT;
        displayName = "STR_Item_GoatRaw";
        weight = 2;
        buyPrice = -1;
        sellPrice = 115;
        illegal = false;
        edible = -1;
        drinkable = -1;
        icon = "icons\ico_muttonLegRaw.paa";
        object = "Land_Suitcase_F";
    };

    class goat {
        variable = VITEM_FOOD_GOAT;
        displayName = "STR_Item_Goat";
        weight = 2;
        buyPrice = 175;
        sellPrice = 135;
        illegal = false;
        edible = 100;
        drinkable = -1;
        icon = "icons\ico_muttonLeg.paa";
        object = "Land_Suitcase_F";
    };
};
