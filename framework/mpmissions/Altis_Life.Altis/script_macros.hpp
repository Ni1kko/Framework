/* System Wide Stuff */
#define SYSTEM_TAG "life"
#define ITEM_TAG format ["%1%2",SYSTEM_TAG,"item_"]
#define GANG_FUNDS group player getVariable ["gang_bank",0];
#define REVEAL_DISTANCE 12

//RemoteExec Macros
#define RSERV 2 //Only server
#define RCLIENT -2 //Except server
#define RANY 0 //Global

//Scripting Macros
#define CONST(var1,var2) var1 = compileFinal (if (var2 isEqualType "") then {var2} else {str(var2)})
#define CONSTVAR(var) var = compileFinal (if (var isEqualType "") then {var} else {str(var)})
#define FETCH_CONST(var) (call var)

//Display Macros
#define CONTROL(disp,ctrl) ((findDisplay ##disp) displayCtrl ##ctrl)
#define CONTROL_DATA(ctrl) (lbData[ctrl,lbCurSel ctrl])
#define CONTROL_DATAI(ctrl,index) ctrl lbData index

//System Macros
#define LICENSE_VARNAME(varName,flag) format ["license_%1_%2",flag,M_CONFIG(getText,"Licenses",varName,"variable")]
#define LICENSE_VALUE(varName,flag) missionNamespace getVariable [LICENSE_VARNAME(varName,flag),false]
#define ITEM_VARNAME(varName) format ["life_inv_%1",M_CONFIG(getText,"VirtualItems",varName,"variable")]
#define ITEM_VALUE(varName) missionNamespace getVariable [ITEM_VARNAME(varName),0]
#define ITEM_ILLEGAL(varName) M_CONFIG(getNumber,"VirtualItems",varName,"illegal")
#define ITEM_SELLPRICE(varName) M_CONFIG(getNumber,"VirtualItems",varName,"sellPrice")
#define ITEM_BUYPRICE(varName) M_CONFIG(getNumber,"VirtualItems",varName,"buyPrice")
#define ITEM_NAME(varName) M_CONFIG(getText,"VirtualItems",varName,"displayName")
#define ITEM_OBJECT(varName) M_CONFIG(getText,"VirtualItems",varName,"object")
#define TEXT_LOCALIZE(textStr) if(isLocalized textStr)then{localize textStr}else{textStr}

//Condition Macros
#define KINDOF_ARRAY(a,b) [##a,##b] call {_veh = _this select 0;_types = _this select 1;_res = false; {if (_veh isKindOf _x) exitWith { _res = true };} forEach _types;_res}

//Config Macros
#define FETCH_CONFIG(TYPE,CFG,SECTION,CLASS,ENTRY) TYPE(configFile >> CFG >> SECTION >> CLASS >> ENTRY)
#define FETCH_CONFIG2(TYPE,CFG,CLASS,ENTRY) TYPE(configFile >> CFG >> CLASS >> ENTRY)
#define FETCH_CONFIG3(TYPE,CFG,SECTION,CLASS,ENTRY,SUB) TYPE(configFile >> CFG >> SECTION >> CLASS >> ENTRY >> SUB)
#define FETCH_CONFIG4(TYPE,CFG,SECTION,CLASS,ENTRY,SUB,SUB2) TYPE(configFile >> CFG >> SECTION >> CLASS >> ENTRY >> SUB >> SUB2)
#define M_CONFIG(TYPE,CFG,CLASS,ENTRY) TYPE(missionConfigFile >> CFG >> CLASS >> ENTRY)
#define BASE_CONFIG(CFG,CLASS) inheritsFrom(configFile >> CFG >> CLASS)
#define LIFE_SETTINGS(TYPE,SETTING) TYPE(missionConfigFile >> "Life_Settings" >> SETTING)

//--- Misc Virtual Items
#define VITEM_MISC_MONEY "money"
#define VITEM_MISC_PICKAXE "pickaxe"
#define VITEM_MISC_DEFIBILLATOR "defibrillator"
#define VITEM_MISC_TOOLKIT "toolkit"
#define VITEM_MISC_TENTKIT "tentKit"
#define VITEM_MISC_FUELCAN_EMPTY "fuelEmpty"
#define VITEM_MISC_FUELCAN_FULL "fuelFull"
#define VITEM_MISC_SPIKESTRIP "spikeStrip"
#define VITEM_MISC_LOCKPICK "lockpick"
#define VITEM_MISC_GOLDBAR "goldbar"
#define VITEM_MISC_BLASTINGCHARGE "blastingcharge"
#define VITEM_MISC_BOLTCUTTERS "boltcutter"
#define VITEM_MISC_DEFUSEKIT "defusekit"
#define VITEM_MISC_STORAGEBOX_S "storagesmall"
#define VITEM_MISC_STORAGEBOX_L "storagebig"
//--- Mined Virtual Items
#define VITEM_MINED_CRUDE_OIL "oilUnprocessed" 
#define VITEM_MINED_OIL "oilProcessed"
#define VITEM_MINED_COPPER_SULFIDE_ORES "copperUnrefined"
#define VITEM_MINED_COPPER "copperRefined"
#define VITEM_MINED_IRON_ORE "ironUnrefined"
#define VITEM_MINED_IRON "ironRefined" 
#define VITEM_MINED_SALT_BRINE "saltUnrefined"
#define VITEM_MINED_SALT "saltRefined"
#define VITEM_MINED_SAND "sand"
#define VITEM_MINED_GLASS "glass"
#define VITEM_MINED_DIAMOND_ORE "diamondUncut" 
#define VITEM_MINED_DIAMOND "diamondCut"
#define VITEM_MINED_ROCK "rock"
#define VITEM_MINED_CEMENT "cement"
//--- Drugs Virtual Items
#define VITEM_DRUG_OPIUM_POPPY "opiumpoppy"
#define VITEM_DRUG_HEROIN "heroinProcessed"
#define VITEM_DRUG_CANNABIS_WET "marijuanaWet"
#define VITEM_DRUG_CANNABIS "marijuana"
#define VITEM_DRUG_COCA_LEAFS "cocaineUnprocessed"
#define VITEM_DRUG_COCAINE "cocaineProcessed"
#define VITEM_DRUG_MORPHINE "morphineProcessed"
#define VITEM_DRUG_CODEINE "codeineProcessed"
//--- Drinks Virtual Items
#define VITEM_DRINK_REDGULL "redgull"
#define VITEM_DRINK_COFFEE "coffee"
#define VITEM_DRINK_WATER "waterBottle"
//--- FOODS Virtual Items 
#define VITEM_FOOD_APPLE "apple"
#define VITEM_FOOD_PEACH "peach"
#define VITEM_FOOD_BACON "tbacon"
#define VITEM_FOOD_DONUTS "donuts"
#define VITEM_FOOD_RAW_RABBIT "rabbitRaw"
#define VITEM_FOOD_RABBIT "rabbit"
#define VITEM_FOOD_RAW_SALEMA "salemaRaw"
#define VITEM_FOOD_SALEMA "salema"
#define VITEM_FOOD_RAW_ORNATE "ornateRaw"
#define VITEM_FOOD_ORNATE "ornate"
#define VITEM_FOOD_RAW_MACKREL "mackerelRaw"
#define VITEM_FOOD_MACKREL "mackerel"
#define VITEM_FOOD_RAW_TUNA "tunaRaw"
#define VITEM_FOOD_TUNA "tuna"
#define VITEM_FOOD_RAW_MULLET "mulletRaw"
#define VITEM_FOOD_MULLET "mullet"
#define VITEM_FOOD_RAW_CATSHARK "catsharkRaw"
#define VITEM_FOOD_CATSHARK "catshark"
#define VITEM_FOOD_RAW_TURTLE "turtleRaw"
#define VITEM_FOOD_TURTLESOUP "turtleSoup"
#define VITEM_FOOD_RAW_HEN "henRaw"
#define VITEM_FOOD_HEN "hen"
#define VITEM_FOOD_RAW_ROOSTER "roosterRaw"
#define VITEM_FOOD_ROOSTER "rooster"
#define VITEM_FOOD_RAW_SHEEP "sheepRaw"
#define VITEM_FOOD_SHEEP "sheep"
#define VITEM_FOOD_RAW_GOAT "goatRaw"
#define VITEM_FOOD_GOAT "goat"


#define MAX_SECS_TOO_WAIT_FOR_SERVER 30
#define MAX_ATTEMPTS_TOO_QUERY_DATA 3