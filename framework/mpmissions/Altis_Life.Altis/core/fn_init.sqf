#include "..\script_macros.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/Framework
*/

waitUntil{uiSleep 0.5;(getClientState isEqualTo "BRIEFING READ") && !isNull findDisplay 46};
enableSentences false;

private _MPClient_fnc_exit = compile '
    _this call MPClient_fnc_setLoadingText;
    uiSleep 5;
    endLoadingScreen;
    endMission "END1"; 
    disableUserInput false;
';

// -- Make it so they are now allowed to walk on debug
disableUserInput true;

// -- Start Loading Screen
startLoadingScreen ["","life_Rsc_DisplayLoading"];
["Setting up client,", "Please Wait..."] call MPClient_fnc_setLoadingText; uiSleep(random[0.5,3,6]);

[] call MPClient_fnc_configuration;
[] call MPClient_fnc_setupEVH;
[] call MPClient_fnc_setupActions;

diag_log "[Life Client] Waiting for the server to be ready...";
waitUntil {!isNil "life_var_serverLoaded" && {!isNil "extdb_var_database_error"}};
if (extdb_var_database_error) exitWith {["Database failed to load,", "Please contact an administrator"] call _MPClient_fnc_exit};
waitUntil {
    ["Waiting for the server to be ready"] call MPClient_fnc_setLoadingText; 
    uiSleep 0.2;
    ["Waiting for the server to be ready."] call MPClient_fnc_setLoadingText; 
    uiSleep 0.2;
    ["Waiting for the server to be ready.."] call MPClient_fnc_setLoadingText;  
    uiSleep 0.2;
    ["Waiting for the server to be ready..."] call MPClient_fnc_setLoadingText;
    uiSleep(random[0.5,3,6]);
    life_var_serverLoaded
};

["Requesting client data..."] call MPClient_fnc_setLoadingText; uiSleep(random[0.5,3,6]);
[] call MPClient_fnc_dataQuery;
waitUntil {life_session_completed};
 
["Setting up player..."] call MPClient_fnc_setLoadingText; uiSleep(random[0.5,3,6]);
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

MPServer_fnc_requestClientId = player;
publicVariableServer "MPServer_fnc_requestClientId";

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

//-- 
[] spawn {
    for "_i" from 0 to 1 step 0 do {
        waitUntil {(!isNull (findDisplay 49)) && {(!isNull (findDisplay 602))}}; // Check if Inventory and ESC dialogs are open
        (findDisplay 49) closeDisplay 2; // Close ESC dialog
        (findDisplay 602) closeDisplay 2; // Close Inventory dialog
    };
};

//-- 
[] spawn MPClient_fnc_escInterupt;

//-- Input handlers
(findDisplay 46) displayAddEventHandler ["KeyDown", "_this call MPClient_fnc_keydownHandler"];
(findDisplay 46) displayAddEventHandler ["KeyUp", "_this call MPClient_fnc_keyupHandler"];

[("Welcome " + profilename),"Have Fun And Respect The Rules!..."] call MPClient_fnc_setLoadingText; uiSleep(5);

//--
switch (playerSide) do {
    case west: {0 call MPClient_fnc_initCop};
    case civilian: {0 call MPClient_fnc_initCiv};
    case independent: {0 call MPClient_fnc_initMedic};
};

//-- Paychecks
[playerSide] call MPClient_fnc_paychecks;

//-- Update wanted prifle
[getPlayerUID player, profileName] remoteExec ["MPServer_fnc_wantedProfUpdate", 2];

//--
[player, life_settings_enableSidechannel, playerSide] remoteExecCall ["MPServer_fnc_managesc", 2];

[] spawn MPClient_fnc_setupStationService;
[] spawn MPClient_fnc_cellphone;//temp
[] spawn MPClient_fnc_survival;
[] spawn MPClient_fnc_initTents;

addMissionEventHandler ["EachFrame", MPClient_fnc_playerTags];
addMissionEventHandler ["EachFrame", MPClient_fnc_revealObjects];
 