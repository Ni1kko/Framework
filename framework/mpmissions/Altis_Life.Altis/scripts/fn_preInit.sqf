#include "..\clientDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

RUN_CLIENT_ONLY;
FORCE_SUSPEND("MPClient_fnc_preInit");
AH_CHECK_FINAL("life_var_preInitTime");

private _scriptWhitelisted = [
	"MPClient_fnc_BEGuidCheck",
    "MPClient_fnc_autoSave",
    "MPClient_fnc_vehicleTrunkUpdate",
    "MPClient_fnc_vehicleHouseUpdate",
    "MPClient_fnc_typeicatorsThread",
    "MPClient_fnc_canAffordBail",
    "MPClient_fnc_autorunScript",
    "MPClient_fnc_deliveringPackage",
    "MPClient_fnc_escorting",
    "MPClient_fnc_redGullEffect",
    "MPClient_fnc_inventoryResetUser",
    "MPClient_fnc_busyFailSafe",
    "MPClient_fnc_viewSafeContents",
    "MPClient_fnc_ticketPaid",
    "MPClient_fnc_restrainmentMonitor",
    "MPClient_fnc_guiHookAutohide",
    "MPClient_fnc_paycheckScript",
    "MPClient_fnc_flashbangActive",
    "MPClient_fnc_sirenActive",
    "MPClient_fnc_inventoryOpenScript",
    "MPClient_fnc_bankruptTime",
    "MPClient_fnc_blockInput",
    "MPClient_fnc_say3DVar",
    "MPClient_fnc_say3DTimer",
    "MPClient_fnc_bleedoutTimer",
    "MPClient_fnc_wildlifePatch",
    "MPClient_fnc_gangCreateMenuScript",
    "MPClient_fnc_deleteOldCharacter",
    "MPClient_fnc_helperScript",
    "MPClient_fnc_helperScript1",
    "MPClient_fnc_helperScript2",
    "MPClient_fnc_helperScript3",
    "MPClient_fnc_helperScript3_1",
    "MPClient_fnc_adminTools", 
    "MPClient_fnc_cdmenu", 
    "MPClient_fnc_cdvars",
    "MPClient_fnc_spitEffects",
    "MPClient_fnc_telported",
    "MPClient_fnc_godMode",
    "DBUG_fnc_IntelliSysUncached",
    "fn_animalBehaviour_mainLoop",
    "BIS_fnc_moduleCurator",
	"BIS_fnc_debugProfile",
    "BIS_fnc_logFormat",
    "BIS_fnc_typeText2",
    "/temp/bin/A3/Functions_F/GUI/fn_dynamicText.sqf",
    "/temp/bin/A3/Functions_F/GUI/fn_typeText2.sqf",
    "/temp/bin/A3/Functions_F/Modules/fn_moduleExecute.sqf",
    "/temp/bin/A3/Functions_F/Debug/fn_preload.sqf",
    "A3\functions_f\initFunctions.sqf",
    "A3\functions_f_EPA\Misc\fn_blackOut.sqf"
];

//-- player object Namespace
private _playerVariables = [
    [GET_CASH_VAR, 0,true],
    ['restrained', false, true],
    ['Escorting', false, true],
    ['transporting', false, true],
    ['playerSurrender', false, true],
    ['realname', profileName, true],
    ['lifeState','HEALTHY',true],
    ["arrested", false,true],
    ['life_var_hidden',false,true],
    ['teleported',false,true],
    ["combatTime", diag_tickTime,true],
    ["newLifeTime", diag_tickTime,true]
];
//-- missionNamespace
private _missionVariables = [ 
    ["life_var_preInitTime", compileFinal str(diag_tickTime)],
    ["life_var_postInitTime", compile str(-1)],
    ["life_var_initTime", compile str(-1)],
    ["life_var_clientTimeout", 0],
    ["life_var_serverTimeout", 0],
    ["life_var_loadingScreenActive", false],
    ["life_var_inventoryLoading", false],
    ["life_var_actionDelay", time],
    ["life_var_vehicleTrunk", objNull],
    ["life_var_sirenActive", false],
    ["life_var_effectEnergyDrink", time],
    ["life_var_processingResource", false],
    ["life_var_gatheringResource", false],
    ["life_var_bailPaid", false],
    ["life_var_isBusy", false],
    ["life_var_vehicleStinger", objNull],
    ["life_var_knockoutBusy", false],
    ["life_var_interrupted", false],
    ["life_var_removeWanted", false],
    ["life_var_adminFrozen", false],
    ["life_var_gearWhenDied", []],
    ["life_var_activeContaineObject", objNull],
    ["life_var_preventGetIn", false],
    ["life_var_preventGetOut", false],
    ["life_var_position", []],
    ["life_var_markers", false],
    ["life_var_markers_active", false],
    ["life_var_canAffordBail", true],
    ["life_var_syncThread", scriptNull],
    ["life_var_storagePlacing", scriptNull],
    ["life_var_firstSpawn", true],
    ["life_var_earplugs", false],
    ["life_var_autorun", false],
    ["life_var_autorun_thread", scriptNull],
    ["life_var_autorun_inventoryOpened", false], 
    ["life_var_autorun_interrupt", false],
    ["life_var_lastSynced", time],
    ["life_var_indicatorLasttick", -999999],
    ["life_var_indicatorsThread", scriptNull],
    ["life_var_weaponHolders", []],
    ["life_var_syncScript",  compileFinal "[] call MPClient_fnc_syncData"],
    ["life_var_abortScript", compileFinal "_this spawn MPClient_fnc_abort"],
    
    //--- Session
    ["life_var_sessionAttempts", 0],
    ["life_var_sessionDone", false],
    ["life_var_sessionGarageRequest", false],
    ["life_var_sessionGarageImpoundRequest", false],

    //--- Hud
    ["life_var_hud_threads", nil],
    ["life_var_hud_layer1shown", false],
    ["life_var_hud_layer1mode", 0],
    ["life_var_hud_partyespmode", 0],
    ["life_var_hud_eventhandle", -1],
    ["life_var_hud_lastgrprendered_at", diag_tickTime],
    ["life_var_hud_laststatsrendered_at", diag_tickTime],
    ["life_var_hud_lastvehrendered_at", diag_tickTime],
    ["life_var_hud_lastrendered_muzzle", ""],
    ["life_var_hud_lastrendered_grenadeclassname", ""],
    ["life_var_hud_lastrendered_vehclassname", ""],
    ["life_var_hud_lastrendered_vehfueltanksize", 0],
    ["life_var_hud_activelayer", 1],
    ["life_var_hud_thirst_lastval", 100],
    ["life_var_hud_hunger_lastval", 100],
    ["life_var_hud_lastlocation", ""],
    ["life_var_hud_waypoints", []],

    //--- Death system
    ["life_var_medicstatus", -1],
    ["life_var_medicstatusby", ""],
     
    //-- Hypothalamus
    ["life_var_thirst", 100],
    ["life_var_hunger", 100],
    ["life_var_bleeding", false],
    ["life_var_painShock", false],
    ["life_var_painShockRunning",false],
    ["life_var_critHit", false],
    ["life_var_critHitRunning",false],

    //--- cellphone
    ["life_var_phoneContacts", []],
    ["life_var_phoneMessages", []],
    ["life_var_phoneTarget", []],
    ["life_var_phoneFilter", false],

    //--- Settings
    ["life_var_enableNewsBroadcast", profileNamespace getVariable ["life_var_enableNewsBroadcast", true]],
    ["life_var_enableSidechannel", profileNamespace getVariable ["life_var_enableSidechannel", true]],
    ["life_var_enablePlayerTags", profileNamespace getVariable ["life_var_enablePlayerTags", true]],
    ["life_var_enableRevealObjects", profileNamespace getVariable ["life_var_enableRevealObjects", true]],
    ["life_var_viewDistanceFoot", profileNamespace getVariable ["life_var_viewDistanceFoot", 1250]],
    ["life_var_viewDistanceCar", profileNamespace getVariable ["life_var_viewDistanceCar", 1250]],
    ["life_var_viewDistanceAir", profileNamespace getVariable ["life_var_viewDistanceAir", 1250]],
    
    //--- Weight Variables
    ["life_var_maxCarryWeight", CFG_MASTER(getNumber, "total_maxWeight")],
    ["life_var_carryWeight", 0], //Represents the players current inventory weight (MUST START AT 0).

    //--- Life Variables
    ["life_var_fishingNetOut", false],
    ["life_var_ATMEnabled", true],
    ["life_var_deliveringPackage", false],
    ["life_var_tazed", false],
    ["life_var_unconscious", false],
    ["life_var_lastBalance",[0,0,0,0]],
    ["life_var_bankrupt", false],
    ["life_var_bankruptTime", nil],
 
    //--- Owned house, vehicles are added to this array
    ["life_var_vehicles", []],

    //--- Settings EVH
    ["life_var_playerTagsEVH", -1],
    ["life_var_revealObjectsEVH", -1],

    //--- RemoteExec related
    ["life_var_serverRequest",false],
    
    //--- Shop related
    ["life_var_clothingTraderData", [-1, -1, -1, -1, -1]],
    ["life_var_clothingTraderFilter", 0],
    ["life_var_vehicleTraderData",["",[],"Undefined",true]],
    ["life_var_adminShop",false],

    //
    ["life_var_licenses",createHashMap],

    //--- Money related
    [GET_BANK_VAR(player), 0],
    [GET_DEBT_VAR(player), 0],

    //-- Setup Gangs
    ["life_var_gangData", []],
    ["life_var_gangHideoutBuildings", (CFG_MASTER(getArray,"gang_area")) apply {nearestBuilding(getMarkerPos _x)}],
    
    ["life_fnc_enterCombat", compileFinal '["combatTime", param [1, 20], param [0, player], true] call MPClient_fnc_addTimer'],
    ["life_fnc_leaveCombat", compileFinal '["combatTime", param [0, player], true] call MPClient_fnc_endTimer'],
    ["life_fnc_inCombat", compileFinal 'not(["combatTime", param [0, player]] call MPClient_fnc_isTimerFinished)'],

    ["life_fnc_enterNewLife", compileFinal '["newLifeTime", ((param [1, 20]) * 60), param [0, player], true] call MPClient_fnc_addTimer'],
    ["life_fnc_leaveNewLife", compileFinal '["newLifeTime", param [0, player], true] call MPClient_fnc_endTimer'],
    ["life_fnc_inNewLife", compileFinal 'not(["newLifeTime", param [0, player]] call MPClient_fnc_isTimerFinished)']
];
//-- parsingNamespace
private _parserVariables = [
    
];
//-- profileNamespace
private _profileVariables = [
    //--- Menu Title Background Colour
    ['GUI_BCG_RGB_R', 0.1],
    ['GUI_BCG_RGB_G', 0.1],
    ['GUI_BCG_RGB_B', 0.1],
    ['GUI_BCG_RGB_A', 0.9]
];
//-- missionProfileNamespace
private _missionProfileVariables = [
    
];
//-- localNamespace
private _localVariables = [
    ["MPClient_FunctionGroups", []]
];
//-- uiNamespace
private _uiVariables = [
    //--- RscDisplays
    ["RscDisplayATM", displayNull],
    ["RscDisplayAdminMenu", displayNull],
    ["RscDisplayCellPhone", displayNull],
    ["RscDisplayChopShop", displayNull],
    ["RscDisplayClothingShop", displayNull],
    ["RscDisplayFederalBank", displayNull],
    ["RscDisplayFuelShop", displayNull],
    ["RscDisplayLicenseShop", displayNull],
    ["RscDisplayGang", displayNull],
    ["RscDisplayInteractionMenu", displayNull],
    ["RscDisplayPlayerInventory", displayNull],
    ["RscDisplayPlayerInventoryKeyManagement", displayNull],
    ["RscDisplayPlayerInventorySettings", displayNull],
    ["RscDisplayLoadingScreen", displayNull],
    ["RscDisplayNewsBroadcast", displayNull],
    ["RscDisplayPoliceTicket", displayNull],
    ["RscDisplayPoliceWanted", displayNull],
    ["RscDisplaySpawnSelection", displayNull],
    ["RscDisplayVehicleGarage", displayNull],
    ["RscDisplayVirtualShop", displayNull],
    ["RscDisplayVehicleShop", displayNull],
    ["RscDisplayVehicleShop3D", displayNull],
    ["RscDisplayVehicleTrunk", displayNull],
    ["RscDisplayWeaponShop", displayNull],
    
    //--- RscTiltes
    ["RscTitleNameTags", displayNull],
    ["RscTitleDeathScreen", displayNull],
    ["RscTitleHUD", displayNull],
    ["RscTitleProgressBar", displayNull],
    ["RscTitleSpitScreen", displayNull]
]; 

//-- Setup VirtualItems
_missionVariables append (([objNull,false] call MPClient_fnc_getGear)#1);

//-- Setup Licenses
_missionVariables append ([objNull,false,false,false,false] call MPClient_fnc_getLicenses);

["Loading client preInit"] call MPClient_fnc_log;
["Life_var_initBlackout"] call BIS_fnc_blackOut;//fail safe for loading screen

private _threadsToMonitor = [/*DON'T EDIT*/];
private _variablesFlagged = [/*DON'T EDIT*/];
private _reWhiteListed = [/*DON'T EDIT*/];
private _jipWhiteListed = [/*DON'T EDIT*/];
private _functions = [/*DON'T EDIT*/];
private _functionGroups = [/*DON'T EDIT*/];

//-- init Variables
{
    _x params ["_namespace", "_varlist"];
    
    if(count _varlist > 0)then 
    {
        private _broadcast = false;
        private _checkNil = false;
        
        switch (true) do
        {
            //--- Object 
            case (typeName _namespace isEqualTo "OBJECT"):
            {
                _broadcast = true;
                _checkNil = true;
            };
            //--- Namespace 
            case (typeName _namespace isEqualTo "NAMESPACE"):
            {
                _broadcast = _namespace isEqualTo missionNamespace;
                _checkNil = not(_namespace in [profileNamespace, missionProfileNamespace, uiNamespace]);
            };
            //--- Invalid namespace 
            default {_varlist resize 0};
        };
    
        {
            private _varName = _x param [0, ""];

            if(count _varName > 0)then
            {
                private _varValue =  _namespace getVariable [_varName,nil];
                private _data = [_varName, _x param [1, nil], _x param [2, false]];

                //-- Flag variable
                if(not(isNil {_varValue}) AND _checkNil)then{ 
                    _variablesFlagged pushBackUnique [_varName,_varValue];
                };

                //-- can namespace can broadcast
                if !_broadcast then {_data resize 2};

                //-- Set variable
                _namespace setVariable _data;
            };
        }forEach _varlist;
    };
} forEach [
    [missionNamespace,_missionVariables],
    [uiNamespace,_uiVariables],
    [profileNamespace,_profileVariables],
    [missionProfileNamespace,_missionProfileVariables],
    [parsingNamespace,_parserVariables],
    [localNamespace,_localVariables],
    [player,_playerVariables]
];

//-- Register mission event handlers
["mission"] call MPClient_fnc_setupEventHandlers;


//-- Check Client function are final and RemoteExec status
{
    _x params [
        ["_functionsTag", "", [""]], 
        ["_config",configNull, [configNull]]
    ];

    
    private _cfgFunctions = _config >> "cfgFunctions" >> _functionsTag;
    
    for "_currentIndex" from 0 to (count(_cfgFunctions) - 1) do 
    {
        private _functionClassList = (_cfgFunctions select _currentIndex);
        private _groupName = configName _functionClassList;
        private _functionGroupIndex = _functionGroups pushBackUnique [_groupName, []];
        private _classesData = createHashMap;

        for "_currentInnerIndex" from 0 to (count(_functionClassList) - 1) do 
        {
            private _currentInnerItem = (_functionClassList select _currentInnerIndex);

            if(isClass _currentInnerItem)then { 
                private _classes = _classesData getOrDefault ["Functions", []];
                _classes pushBackUnique _currentInnerItem;
                _classesData set ["Functions", _classes];
            }else{
                switch (toLower(configName _currentInnerItem)) do {
                    case "tag": {
                        private _tag = getText(_currentInnerItem);
                        
                        if(count _tag > 0 AND toLower _tag isNotEqualTo toLower _functionsTag)then{
                            _classesData set ["Tag", _tag];
                        };
                    };
                    case "file": {_classesData set ["Path", getText(_currentInnerItem)]};
                };
            };
        };

        {
            private _fileName = configName _x;
            private _fileTag = _classesData getOrDefault ["Tag",_functionsTag];
            private _filePath = format ["%1\%2.sqf", _classesData getOrDefault ["Path",""], _fileName];
            private _filePreInit = getNumber(_x >> "preInit") isEqualTo 1;
            private _filePostInit = getNumber(_x >> "postInit") isEqualTo 1;
            private _functionName = format ["%1_fnc_%2",_fileTag,_fileName];
            _functions pushBackUnique _functionName;

            private _cfgRemoteExec = [ConfigFile >> "CfgRemoteExec",missionConfigFile >> "CfgRemoteExec"] select (isclass(missionConfigFile >> "CfgRemoteExec" >> "Functions" >> _functionName));
    
            if(isclass(_cfgRemoteExec >> "Functions" >> _functionName))then{
                _reWhiteListed pushBackUnique _functionName;
                if(getNumber(_cfgRemoteExec >> "Functions" >> _functionName >> "jip") isEqualTo 1)then{
                    _jipWhiteListed pushBackUnique _functionName;   
                };
            }else{
                if(getNumber(_cfgRemoteExec >> "Functions" >> "mode") >= 2)then{
                    _reWhiteListed pushBackUnique _functionName;
                    _jipWhiteListed pushBackUnique _functionName;   
                    //[format["Warning Function (%1) can be RemoteExecuted, Major Security Risk!",_functionName],false,true] call MPClient_fnc_log;
                };
            };

            //-- Add to script whitelist no point the bellow line handle this plus more, Redundacncy incase of a bug with file path
            _scriptWhitelisted pushBackUnique _functionName;
            
            //-- This catches most scripts that are spawned from inner scopes too without whitelisting every spawned scope
            if(fileExists _filePath)then{ 
                _scriptWhitelisted pushBackUnique _filePath;
                _scriptWhitelisted pushBackUnique format["mpmissions\__CUR_MP.Altis\",_filePath];
            };

            if(_functionGroupIndex isNotEqualTo -1)then{
                (_functionGroups#_functionGroupIndex) params ["_groupName", "_fileList"];
                private _fileNameIndex = _fileList pushBackUnique _fileName;

                if(_fileNameIndex isNotEqualTo -1)then{
                    _functionGroups set [_functionGroupIndex, [_groupName, _fileList]];
                };
            };
        }forEach (_classesData getOrDefault ["Functions",[]]);
    };

    private _nonFinalFunctions = [];
    private _totalFunctions = count _functions;
    private _totalFinalFunctions = {if(isFinal (format["%1",_x]))then{true}else{_nonFinalFunctions pushBackUnique _x;false}} count _functions;
    private _totalNonFinalFunctions = count _nonFinalFunctions;

    localNamespace setVariable [format["%1_FunctionGroups",_functionsTag], _functionGroups];

    //-- Check all client function are final
    if (_totalFunctions isNotEqualTo _totalFinalFunctions AND _totalNonFinalFunctions > 0)then{
        {
            uiSleep 0.2;
            [format["Warning Client Function (%1) Is Not Final, Major Security Risk!",_x],false,true] call MPClient_fnc_log;
        }forEach _nonFinalFunctions;
    };
}forEach [
    ["MPClient", missionConfigFile]
];

//-- Check RemoteExec Functions whitelist mode
if(getNumber(missionConfigFile >> "CfgRemoteExec" >> "Functions" >> "mode") >= 2)then{
    RPT_FILE_LB;
    ["Warning RemoteExec Functions whitelist disabled, Major Security Risk!",false,true] call MPClient_fnc_log;
};

//-- Check RemoteExec Functions whitelist mode
if(getNumber(missionConfigFile >> "CfgRemoteExec" >> "Commands" >> "mode") >= 2)then{
    RPT_FILE_LB;
    ["Warning RemoteExec Commands whitelist disabled, Major Security Risk!",false,true] call MPClient_fnc_log;
};

//-- flagged variable found. TODO: handle this through anticheat on server once detected
if(count _variablesFlagged > 0)exitWith{
    RPT_FILE_LB;
    [0,format["[Antihack] Hacker Detected %1 Variables flagged",getPlayerUID player],true,[profileNameSteam, profileName]] remoteExecCall ["MPClient_fnc_broadcast",-2];
    [format ["[LIFE] %1 Variables flagged",count _variablesFlagged]] call MPClient_fnc_log;
    {[format ["[LIFE] %1 = %2;",_x#0,_x#1]] call MPClient_fnc_log; uiSleep 0.6}forEach _variablesFlagged;
    ["Hack Detected", "Variables flagged", "Antihack"] call MPClient_fnc_endMission;
};

//-- save proflie vars
if(count _profileVariables > 0)then{
    saveProfileNamespace;
};

//-- save mission proflie vars
if(count _missionProfileVariables > 0)then{
    saveMissionProfileNamespace;
};

//-- Monitor money vars TODO: handle this through anticheat 
_threadsToMonitor pushBackUnique (["bank"] spawn MPClient_fnc_checkMoneyScript);
_threadsToMonitor pushBackUnique (["cash"] spawn MPClient_fnc_checkMoneyScript);
_threadsToMonitor pushBackUnique (["gang"] spawn MPClient_fnc_checkMoneyScript);
_threadsToMonitor pushBackUnique (["debt"] spawn MPClient_fnc_checkMoneyScript);

private _fnc_null = compileFinal "";

//-- Exploit patch - Revert to engine comamand if filePatching is enabled
private _fnc_endMission = ([
    compileScript ["\a3\functions_f\Misc\fn_endMission.sqf",true], 
    compileFinal "scriptName 'BIS_fnc_endMission'; endMission (_this#0); true"
] select isFilePatchingEnabled);

//-- Exploit patch - Ensure that bis function are final and null routed OR default code
{
    if(not(isFinal (missionNamespace getVariable [_x#0,{}])))then{
        missionNamespace setVariable _x;
    };
}forEach [
    ["BIS_fnc_MP",_fnc_null],
    ["BIS_fnc_endMission", _fnc_endMission]
];

//-- Exploit patch - Ensure that "BIS_fnc_MP" requests are null routed.
"BIS_fnc_MP_packet" addPublicVariableEventHandler _fnc_null;

//-- Load main init
[serverName,missionName,worldName,worldSize] spawn MPClient_fnc_init;

//-- Thread set 2
{
    private _threadName = format["MPClient_fnc_tSetIndex%1",_forEachIndex];
    _scriptWhitelisted pushBackUnique _threadName;
    _threadsToMonitor set [_forEachIndex, [_threadName,_x] spawn {
        params ["_threadName","_thread"];
        scriptName _threadName; 
        waitUntil {uiSleep floor(random 15);isNull _thread};
        ["Hack Detected", "Protected Thread Set 2 Terminated", "Antihack"] call MPClient_fnc_endMission
    }]
}forEach _threadsToMonitor;

[_scriptWhitelisted] spawn {
    params ["_scriptWhitelisted"];
    private _threadName = "MPClient_fnc_hSystem";
	scriptName _threadName;

    _scriptWhitelisted pushBackUnique _threadName;

    _scriptWhitelisted = _scriptWhitelisted apply {toLower _x};

    waitUntil{getClientStateNumber >= 9};
    uiSleep round(random[5,10,15]);

	while {true} do 
	{
		{
			_x params [
				["_scriptName", "", [""]],
				["_filePath", "", [""]],
				["_isRunning", false, [false]],
				["_currentLine", 0, [0]]
			];

            private _code = "";

            if(((toLower _scriptName) select [0,7]) isEqualTo "<spawn>")then{
                _code = _scriptName;
                if(count _scriptName isEqualTo 0)then{_scriptName = "<spawn>"};
                if(count _filePath isEqualTo 0)then{_scriptName = "<null>"};
            }else{
                if(fileExists _filePath)then{
                    _code = preprocessFileLineNumbers _filePath;
                };
            };

			if not(toLower _scriptName in _scriptWhitelisted OR toLower _filePath in _scriptWhitelisted)then
            {
                //-- I used joinString over format due to format having a 8kb buffer limit, and i want to log the full script that was found running
                private _string = [
                    "Warning non whitelisted function running",
                    "|","Name:", _scriptName,
                    "|","Code:", _code,
                    "|","File:", _filePath,
                    "|","Line:", _currentLine
                ] joinString " ";

				[_string,false,true] call MPClient_fnc_log;

				if(assert _isRunning)then{
                    ["Hack Detected", format["Warning non whitelisted function (%1) running",_scriptName], "Antihack"] call MPClient_fnc_endMission;
				};
			};
		}forEach diag_activeSQFScripts;
        uiSleep round(random(7));
	};
};

//--
[format["Client preInit completed! Took %1 seconds",diag_tickTime - (call life_var_preInitTime)]] call MPClient_fnc_log;

//-- Preinit complete
true