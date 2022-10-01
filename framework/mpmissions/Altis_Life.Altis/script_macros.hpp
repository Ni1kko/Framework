/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
    ## mpmission\script_macros.hpp
*/

#define REVEAL_DISTANCE 12

//RemoteExec Macros
#define RE_SERVER 2 //Only server
#define RE_CLIENT -2 //Except server
#define RE_GLOBAL 0 //Global

//Display Macros
#define GETDisplayNumber(var) getNumber(([missionConfigFile,missionConfigFile >> "RscTitles"] select isClass (missionConfigFile >> "RscTitles" >> var)) >> var >> "idd")
#define GETControlNumber(var, var2) getNumber(([missionConfigFile,missionConfigFile >> "RscTitles"] select isClass (missionConfigFile >> "RscTitles" >> var)) >> var >> "controls" >> var2 >> "idc")
#define GETControlBGNumber(var, var2) getNumber(([missionConfigFile,missionConfigFile >> "RscTitles"] select isClass (missionConfigFile >> "RscTitles" >> var)) >> var >> "controlsBackground" >> var2 >> "idc")
#define GETControlGroupNumber(var, var2, var3) getNumber(([missionConfigFile,missionConfigFile >> "RscTitles"] select isClass (missionConfigFile >> "RscTitles" >> var)) >> var >> var2 >> "controls" >> var3 >> "idc")
#define GETControlGroupBGNumber(var, var2, var3) getNumber(([missionConfigFile,missionConfigFile >> "RscTitles"] select isClass (missionConfigFile >> "RscTitles" >> var)) >> var >> var2 >> "controlsBackground" >> var3 >> "idc")

#define GETDisplay(var) (uiNamespace getVariable [var, findDisplay (GETDisplayNumber(var))])
#define GETControl(var, var2) GETDisplay(var) displayCtrl GETControlNumber(var, var2)
#define GETControlBG(var, var2) GETDisplay(var) displayCtrl GETControlBGNumber(var, var2)
#define GETControlGroup(var, var2, var3) GETDisplay(var) displayCtrl GETControlGroupNumber(var, var2, var3)
#define GETControlGroupBG(var, var2, var3) GETDisplay(var) displayCtrl GETControlGroupBGNumber(var, var2, var3)

#define CONTROL(disp,ctrl) ((findDisplay ##disp) displayCtrl ##ctrl)
#define CONTROL_DATA(ctrl) (lbData[ctrl,lbCurSel ctrl])
#define CONTROL_DATAI(ctrl,index) ctrl lbData index

//System Macros
#define LICENSE_VARNAME(varName,flag) format ["license_%1_%2",flag,M_CONFIG(getText,"cfgLicenses",varName,"variable")]
#define LICENSE_VALUE(varName,flag) (missionNamespace getVariable [LICENSE_VARNAME(varName,flag),false])
#define LICENSE_DISPLAYNAME(varName) localize M_CONFIG(getText,"cfgLicenses",varName,"displayName")
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

//--- Databse related helpers
#define MAX_SECS_TOO_WAIT_FOR_SERVER 30
#define MAX_ATTEMPTS_TOO_QUERY_DATA 3

//--- Reveal Objects helpers
#define CACHE_VAR "Life_var_revealObjectsCache"
#define CACHE2_VAR format["%1%2",CACHE_VAR,"2"]
#define CACHE_POS_VAR format["%1_pos",CACHE_VAR]

//--
#define INFINTE 1e+011

#define GET_BANK_VAR(target) format["money_bank_%1", getPlayerUID target]
#define GET_DEBT_VAR(target) format["money_debt_%1", getPlayerUID target]
#define GET_CASH_VAR "money_cash"
#define GET_GANG_MONEY_VAR "money_gang"

#define GET_MONEY_CASH(target) (target getVariable [GET_CASH_VAR,0])
#define GET_MONEY_DEBT(target) (target getVariable [GET_DEBT_VAR(target),0])
#define GET_MONEY_BANK(target) (missionNamespace getVariable [GET_BANK_VAR(target),0])
#define GET_MONEY_GANG(target) ((group target) getVariable [GET_GANG_MONEY_VAR,0])

#define GET_MONEY_CASH_FORMATTED(target) [GET_MONEY_CASH(target)] call MPClient_fnc_numberText
#define GET_MONEY_DEBT_FORMATTED(target) [GET_MONEY_DEBT(target)] call MPClient_fnc_numberText
#define GET_MONEY_BANK_FORMATTED(target) [GET_MONEY_BANK(target)] call MPClient_fnc_numberText
#define GET_MONEY_GANG_FORMATTED(target) [GET_MONEY_GANG(target)] call MPClient_fnc_numberText

#define SET_MONEY_CASH(target, value) target setVariable [GET_CASH_VAR,##value,true]
#define SET_MONEY_DEBT(target, value) target setVariable [GET_DEBT_VAR(target),##value,true]
#define SET_MONEY_BANK(target, value) missionNamespace setVariable [GET_BANK_VAR(target),##value,true]
#define SET_MONEY_GANG(target, value) (group target) setVariable [GET_GANG_MONEY_VAR,##value,true]

#define ADD_MONEY_CASH(target, value) SET_MONEY_CASH(target, GET_MONEY_CASH(target) + value)
#define ADD_MONEY_DEBT(target, value) SET_MONEY_DEBT(target, GET_MONEY_DEBT(target) + value)
#define ADD_MONEY_BANK(target, value) SET_MONEY_BANK(target, GET_MONEY_BANK(target) + value)
#define ADD_MONEY_GANG(target, value) SET_MONEY_GANG(target, GET_MONEY_GANG(target) + value)

#define SUB_MONEY_CASH(target, value) SET_MONEY_CASH(target, GET_MONEY_CASH(target) - value)
#define SUB_MONEY_DEBT(target, value) SET_MONEY_DEBT(target, GET_MONEY_DEBT(target) - value)
#define SUB_MONEY_BANK(target, value) SET_MONEY_BANK(target, GET_MONEY_BANK(target) - value)
#define SUB_MONEY_GANG(target, value) SET_MONEY_GANG(target, GET_MONEY_GANG(target) - value)

#define MONEY_CASH GET_MONEY_CASH(player)
#define MONEY_DEBT GET_MONEY_DEBT(player)
#define MONEY_BANK GET_MONEY_BANK(player)
#define MONEY_GANG GET_MONEY_GANG(player)

#define MONEY_CASH_FORMATTED GET_MONEY_CASH_FORMATTED(player)
#define MONEY_DEBT_FORMATTED GET_MONEY_DEBT_FORMATTED(player)
#define MONEY_BANK_FORMATTED GET_MONEY_BANK_FORMATTED(player)
#define MONEY_GANG_FORMATTED GET_MONEY_GANG_FORMATTED(player)

#define FORCE_SUSPEND(fnc) if !canSuspend exitWith{_this spawn (missionNamespace getVariable [fnc,{}]); true}

#define RUN_SERVER_ONLY (if (hasInterface OR not(isServer))exitWith{false})
#define RUN_DEDI_SERVER_ONLY (if (hasInterface OR not(isServer) OR not(isDedicated))exitWith{false})
#define RUN_CLIENT_ONLY (if not(hasInterface)exitWith{false})

#define AH_CHECK(var) (if (missionNamespace getVariable [var,false])exitWith{["Hack Detected", format["`%1` already set, Client looping or hacker detected",var], "Antihack"] call MPClient_fnc_endMission; false})
#define AH_CHECK_FINAL(var) (if (isFinal var)exitWith{["Hack Detected", format["`%1` already final, Client looping or hacker detected",var], "Antihack"] call MPClient_fnc_endMission;false})
#define AH_BAN_REMOTE_EXECUTED(var) (if(isRemoteExecuted AND (missionNamespace getVariable ["life_var_rcon_passwordOK",false]))exitwith{[remoteExecutedOwner,format["RemoteExecuted `%1`",var]] call MPServer_fnc_rcon_ban;})
