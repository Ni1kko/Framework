#include "..\..\script_macros.hpp"
/*
    File: fn_updatePartial.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Sends specific information to the server to update on the player,
    meant to keep the network traffic down with large sums of data flowing
    through remoteExec
*/

private _mode = param [0,-1];
private _flag = [playerSide,true] call MPServer_fnc_util_getSideString;
private _packet = [player,_mode];

switch (_mode) do 
{
    //-- Cash
    case 0: {_packet set[2,life_var_lastBalance#0]};
    //-- Bank
    case 1: {_packet set[2,life_var_lastBalance#1]};
    //-- Licenses    
    case 2: {_packet set[2,([player] call MPClient_fnc_getLicenses)]};
    //-- Gear
    case 3: {_packet set[2,([player] call MPClient_fnc_getGear)]};
    //-- Position
    case 4: {_packet append [life_is_alive, getPosATL player]};
    //-- Arrested
    case 5: {_packet set[2,life_is_arrested]};
    //-- Money
    case 6: {_packet append life_var_lastBalance};
    //-- Used for keychain
    case 7: {};
};

_packet remoteExecCall ["MPServer_fnc_updatePartial",RE_SERVER];

true