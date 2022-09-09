#include "..\script_macros.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

waitUntil{uiSleep 0.5;(getClientState isEqualTo "BRIEFING READ") && !isNull findDisplay 46};
enableSentences false;

private _MPClient_fnc_exit = compile '
    params [
       ["_title",""],
       ["_text",""],
       ["_ending","END1"]
    ];
    _this call MPClient_fnc_setLoadingText;
    uiSleep 5;
    endLoadingScreen;
    [_ending,false,true] call BIS_fnc_endMission;
    disableUserInput false;
    true
';

// -- Start Loading Screen
startLoadingScreen ["","life_Rsc_DisplayLoading"];
["Setting up client", "Please Wait..."] call MPClient_fnc_setLoadingText; uiSleep(random[0.5,3,6]);

// --
diag_log "[Life Client] Waiting for the server to be ready...";
waitUntil {!isNil "life_var_serverLoaded" && {!isNil "extdb_var_database_error"}};
if (extdb_var_database_error) exitWith {["Database failed to load", "Please contact an administrator"] call _MPClient_fnc_exit};
if !life_var_serverLoaded then { 
    waitUntil {
        if(life_var_serverTimeout > MAX_SECS_TOO_WAIT_FOR_SERVER) exitWith {["Server failed to load", "Please try again"] call _MPClient_fnc_exit};
        ["Waiting for the server to be ready", "Please wait"] call MPClient_fnc_setLoadingText; 
        uiSleep 0.2;
        ["Waiting for the server to be ready", "Please wait."] call MPClient_fnc_setLoadingText; 
        uiSleep 0.2;
        ["Waiting for the server to be ready", "Please wait.."] call MPClient_fnc_setLoadingText;  
        uiSleep 0.2;
        ["Waiting for the server to be ready", "Please wait..."] call MPClient_fnc_setLoadingText;
        uiSleep 0.4;
        life_var_serverTimeout = life_var_serverTimeout + 1;
        life_var_serverLoaded
    }; 
};

[] spawn MPClient_fnc_dataQuery;
waitUntil {
    if(life_var_session_attempts > MAX_ATTEMPTS_TOO_QUERY_DATA) exitWith {["Unable to load player data", "Please try again"] call _MPClient_fnc_exit};
    uiSleep 1;    
    life_session_completed
};

MPServer_fnc_requestClientId = player;
publicVariableServer "MPServer_fnc_requestClientId";

["Setting up player", "Please wait..."] call MPClient_fnc_setLoadingText; uiSleep(random[0.5,3,6]);
{player setVariable _x} forEach [
    ['restrained', false, true],
    ['Escorting', false, true],
    ['transporting', false, true],
    ['playerSurrender', false, true],
    ['realname', profileName, true],
    ['lifeState','HEALTHY',true]
];

if (LIFE_SETTINGS(getNumber,"enable_fatigue") isEqualTo 0) then {
    player enableFatigue false;
    if (LIFE_SETTINGS(getNumber,"enable_autorun") isEqualTo 1) then {
        [] spawn MPClient_fnc_autoruninit;
    }; 
};

{
    /*
        https://feedback.bistudio.com/T117205 - disableChannels settings cease to work when leaving/rejoining mission
        Universal workaround for usage in a preInit function. - AgentRev
        Remove if Bohemia actually fixes the issue.
    */
    _x params [["_chan",-1,[0]], ["_noText","false",[""]], ["_noVoice","false",[""]]];
    _noText = [false,true] select ((["false","true"] find toLower _noText) max 0);
    _noVoice = [false,true] select ((["false","true"] find toLower _noVoice) max 0);
    _chan enableChannel [!_noText, !_noVoice];
} forEach getArray (missionConfigFile >> "disableChannels");

[] spawn {
    for "_i" from 0 to 1 step 0 do {
        waitUntil {(!isNull (findDisplay 49)) && {(!isNull (findDisplay 602))}}; // Check if Inventory and ESC dialogs are open
        (findDisplay 49) closeDisplay 2; // Close ESC dialog
        (findDisplay 602) closeDisplay 2; // Close Inventory dialog
    };
};
 
[] call MPClient_fnc_setupEVH;
[] call MPClient_fnc_setupActions;
[] spawn MPClient_fnc_briefing;
[] spawn MPClient_fnc_escInterupt;
[] spawn MPClient_fnc_setupStationService;
[] spawn MPClient_fnc_initTents;

//-- Input handlers
(findDisplay 46) displayAddEventHandler ["KeyDown", "_this call MPClient_fnc_keydownHandler"];
(findDisplay 46) displayAddEventHandler ["KeyUp", "_this call MPClient_fnc_keyupHandler"];

//-- Update wanted prifle
[getPlayerUID player, profileName] remoteExec ["MPServer_fnc_wantedProfUpdate", 2];

private _side = side player;
private _sideVar = [_side,true] call MPServer_fnc_util_getSideString;
private _sideCode = missionNamespace getVariable [format["MPClient_fnc_init%1",_sideVar],{}];


//-- 
[player, _MPClient_fnc_exit] call _sideCode;
[("Welcome " + profilename),"Have Fun And Respect The Rules!..."] call MPClient_fnc_setLoadingText; uiSleep(5);
private _spawnPlayerThread = [life_is_alive,life_position] spawn MPClient_fnc_spawnPlayer;
waitUntil{scriptDone _spawnPlayerThread};

//-- Paychecks
[_side] call MPClient_fnc_paychecks;

//--
[player, life_settings_enableSidechannel, playerSide] remoteExecCall ["MPServer_fnc_managesc", 2];

[] spawn MPClient_fnc_cellphone;//temp
[] spawn MPClient_fnc_survival;

["objects", 1] call MPClient_fnc_s_onCheckedChange;
["tags", 1] call MPClient_fnc_s_onCheckedChange;

true
 