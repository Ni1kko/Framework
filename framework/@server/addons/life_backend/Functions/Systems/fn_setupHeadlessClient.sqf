/*
    Author: Nanou
    File: fn_initHC.sqf

    Description:
    Written for Altis Life RPG.
*/

HC_UID = nil;

// JIP integration of an hc
"life_var_hc_connected" addPublicVariableEventHandler {
    if (_this select 1) then {
        HC_UID = getPlayerUID hc_1;
        life_var_headlessClient = owner hc_1;
        publicVariable "life_var_headlessClient";
        life_var_headlessClient publicVariableClient "life_var_severVehicles";
        cleanupFSM setFSMVariable ["stopfsm",true];
        terminate cleanup;
        terminate aiSpawn;
        [true] call TON_fnc_transferOwnership;
        life_var_headlessClient publicVariableClient "animals";
        diag_log "Headless client is connected and ready to work!";
    };
};

HC_DC = addMissionEventHandler ["PlayerDisconnected",
    {
        if (!isNil "HC_UID" && {_uid == HC_UID}) then {
            life_var_hc_connected = false;
            publicVariable "life_var_hc_connected";
            life_var_headlessClient = false;
            publicVariable "life_var_headlessClient";
            cleanup = [] spawn TON_fnc_cleanup;
            cleanupFSM = [] execFSM "\life_backend\FSM\cleanup.fsm";
            [false] call TON_fnc_transferOwnership;
            aiSpawn = ["hunting_zone",30] spawn TON_fnc_huntingZone;
            diag_log "Headless client disconnected! Broadcasted the vars!";
            diag_log "Ready for receiving queries on the server machine.";
        };
    }
];
