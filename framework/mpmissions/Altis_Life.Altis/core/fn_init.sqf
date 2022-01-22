#include "..\script_macros.hpp"
/*
    File: init.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Master client initialization file
*/
diag_log "----------------------------------------------------------------------------------------------------";
diag_log "--------------------------------- Starting Altis Life Client Init ----------------------------------";
diag_log format["------------------------------------------ Version %1 -------------------------------------------",(LIFE_SETTINGS(getText,"framework_version"))];
diag_log "----------------------------------------------------------------------------------------------------";

private _timeStamp = diag_tickTime;

waitUntil{uiSleep 0.5;(getClientState isEqualTo "BRIEFING READ") && !isNull findDisplay 46};
enableSentences false;

private _life_fnc_exit = compile '
    _this call life_fnc_setLoadingText;
    uiSleep 5;
    endLoadingScreen;
    endMission "END1"; 
';

startLoadingScreen ["","life_Rsc_DisplayLoading"];
["Setting up client,", "Please Wait..."] call life_fnc_setLoadingText; uiSleep(random[0.5,3,6]);

diag_log "[Life Client] Initialization Variables";
[] call life_fnc_configuration;
diag_log "[Life Client] Variables initialized";

diag_log "[Life Client] Setting up Eventhandlers";
[] call life_fnc_setupEVH;
diag_log "[Life Client] Eventhandlers completed";

diag_log "[Life Client] Setting up user actions";
[] call life_fnc_setupActions;
diag_log "[Life Client] User actions completed";

diag_log "[Life Client] Waiting for the server to be ready...";
waitUntil {!isNil "life_var_serverLoaded" && {!isNil "extdb_var_database_error"}};

if (extdb_var_database_error) exitWith {
    ["Database failed to load,", "Please contact an administrator"] call _life_fnc_exit;
};

waitUntil {life_var_serverLoaded};
diag_log "[Life Client] Server loading completed ";
["Waiting for the server to be ready"] call life_fnc_setLoadingText; uiSleep(random[0.5,3,6]);

[] call SOCK_fnc_dataQuery;
waitUntil {life_session_completed};
["Finishing client setup procedure..."] call life_fnc_setLoadingText; uiSleep(random[0.5,3,6]);

[] spawn life_fnc_escInterupt;

switch (playerSide) do {
    case west: {
        life_paycheck = LIFE_SETTINGS(getNumber,"paycheck_cop");
        [] call life_fnc_initCop;
    };
    case civilian: {
        life_paycheck = LIFE_SETTINGS(getNumber,"paycheck_civ");
        [] call life_fnc_initCiv;
    };
    case independent: {
        life_paycheck = LIFE_SETTINGS(getNumber,"paycheck_med");
        [] call life_fnc_initMedic;
    };
};
CONSTVAR(life_paycheck);

player setVariable ["restrained", false, true];
player setVariable ["Escorting", false, true];
player setVariable ["transporting", false, true];
player setVariable ["playerSurrender", false, true];
player setVariable ["realname", profileName, true];
player setVariable ["lifeState","HEALTHY",true];

diag_log "[Life Client] Past Settings Init";
[] call life_fnc_client;
diag_log "[Life Client] Executing client.fsm";

(findDisplay 46) displayAddEventHandler ["KeyDown", "_this call life_fnc_keydownHandler"];
(findDisplay 46) displayAddEventHandler ["KeyUp", "_this call life_fnc_keyupHandler"];
[player, life_settings_enableSidechannel, playerSide] remoteExecCall ["TON_fnc_manageSC", RSERV];

[] spawn life_fnc_survival;

//0 cutText ["","BLACK IN"];  

[] spawn {
    for "_i" from 0 to 1 step 0 do {
        waitUntil {(!isNull (findDisplay 49)) && {(!isNull (findDisplay 602))}}; // Check if Inventory and ESC dialogs are open
        (findDisplay 49) closeDisplay 2; // Close ESC dialog
        (findDisplay 602) closeDisplay 2; // Close Inventory dialog
    };
};

addMissionEventHandler ["EachFrame", life_fnc_playerTags];
addMissionEventHandler ["EachFrame", life_fnc_revealObjects];

if (LIFE_SETTINGS(getNumber,"enable_fatigue") isEqualTo 0) then {
    player enableFatigue false;
    if (LIFE_SETTINGS(getNumber,"enable_autorun") isEqualTo 1) then {
        [] spawn life_fnc_autoruninit;
    }; 
};
if (LIFE_SETTINGS(getNumber,"pump_service") isEqualTo 1) then {
    [] spawn life_fnc_setupStationService;
};

life_fnc_RequestClientId = player;
publicVariableServer "life_fnc_RequestClientId";

/*
    https://feedback.bistudio.com/T117205 - disableChannels settings cease to work when leaving/rejoining mission
    Universal workaround for usage in a preInit function. - AgentRev
    Remove if Bohemia actually fixes the issue.
*/
{
    _x params [["_chan",-1,[0]], ["_noText","false",[""]], ["_noVoice","false",[""]]];

    _noText = [false,true] select ((["false","true"] find toLower _noText) max 0);
    _noVoice = [false,true] select ((["false","true"] find toLower _noVoice) max 0);

    _chan enableChannel [!_noText, !_noVoice];

} forEach getArray (missionConfigFile >> "disableChannels");

if (count extdb_var_database_headless_clients > 0) then {
    [getPlayerUID player, player getVariable ["realname", name player]] remoteExec ["HC_fnc_wantedProfUpdate", extdb_var_database_headless_client];
} else {
    [getPlayerUID player, player getVariable ["realname", name player]] remoteExec ["life_fnc_wantedProfUpdate", RSERV];
};

[true] call life_fnc_gui_hook_management;
[] spawn life_fnc_cellphone;//temp

diag_log "----------------------------------------------------------------------------------------------------";
diag_log format ["               End of Altis Life Client Init :: Total Execution Time %1 seconds ",(diag_tickTime - _timeStamp)];
diag_log "----------------------------------------------------------------------------------------------------";