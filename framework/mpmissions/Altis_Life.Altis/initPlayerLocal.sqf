#include "script_macros.hpp"
/*
    File: initPlayerLocal.sqf
    Author:

    Description:
    Starts the initialization of the player.
*/
if (!hasInterface && !isServer) exitWith {};

[] spawn MPClient_fnc_init;
[] spawn MPClient_fnc_briefing;
