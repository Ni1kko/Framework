#include "..\..\script_macros.hpp"
/*
    File: fn_syncData.sqf
    Author: Bryan "Tonic" Boardwine"

    Description:
    Used for player manual sync to the server.
*/
_fnc_scriptName = "Player Synchronization";
if (isNil "life_session_time") then {life_session_time = false;};
if (life_session_time) exitWith {hint localize "STR_Session_SyncdAlready";};

life_var_lastSynced = time;
[] call MPClient_fnc_updateRequest;
hint "Syncing player information to Hive.\n\nPlease wait atleast 10 seconds before leaving";

//allow admins to sync anytime
if life_isdev then{ 
    life_session_time = false;
    life_var_lastSynced = (time + (5 * 60));
}else{
    [] spawn {
        life_session_time = true;
        sleep (5 * 60);
        life_session_time = false;
    };
};