#include "..\..\script_macros.hpp"
/*
    File: fn_onPlayerKilled.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    When the player dies collect various information about that player
    and pull up the death dialog / camera functionality.
*/
params [
    ["_unit",objNull,[objNull]],
    ["_killer",objNull,[objNull]]
];

disableSerialization;

//-- Log death
//[format ["%1(%2) killed %1(%2)",_killer getVariable["realname",""],getPlayerUID _killer,_unit getVariable["realname",""],getPlayerUID _unit],true,true] call MPClient_fnc_log;

if  !((vehicle _unit) isEqualTo _unit) then {
    UnAssignVehicle _unit;
    _unit action ["getOut", vehicle _unit];
    _unit setPosATL [(getPosATL _unit select 0) + 3, (getPosATL _unit select 1) + 1, 0];
};

//Set some vars
{_unit setVariable _x} forEach [
    ["Revive",true,true],
    ['restrained',false,true],
    ['Escorting',false,true],
    ['transporting',false,true],
    ['playerSurrender',false,true],
    ['steam64id',getPlayerUID _unit,true],
    ['realname',profileName,true]
];

life_is_alive = false;
life_var_isBusy = false;
life_var_hunger = 0;
life_var_thirst = 0;

//-- Drop items and strip player
[_unit,true] call MPClient_fnc_stripDownPlayer;

//close the esc dialog
if (dialog) then {
    closeDialog 0;
};

//Make the killer wanted
if (!isNull _killer && {!(_killer isEqualTo _unit)} && {!(side _killer isEqualTo west)} && {alive _killer}) then {
    if (vehicle _killer isKindOf "LandVehicle") then {
        if (count extdb_var_database_headless_clients > 0) then {
            [getPlayerUID _killer,_killer getVariable ["realname",name _killer],"187V"] remoteExecCall ["HC_fnc_wantedAdd",extdb_var_database_headless_client];
        } else {
            [getPlayerUID _killer,_killer getVariable ["realname",name _killer],"187V"] remoteExecCall ["MPServer_fnc_wantedAdd",RE_SERVER];
        };

        //Get rid of this if you don't want automatic vehicle license removal.
        if (!local _killer) then {
            [2] remoteExecCall ["MPClient_fnc_removeLicenses",_killer];
        };
    } else {
        if (count extdb_var_database_headless_clients > 0) then {
            [getPlayerUID _killer,_killer getVariable ["realname",name _killer],"187"] remoteExecCall ["HC_fnc_wantedAdd",extdb_var_database_headless_client];
        } else {
            [getPlayerUID _killer,_killer getVariable ["realname",name _killer],"187"] remoteExecCall ["MPServer_fnc_wantedAdd",RE_SERVER];
        };

        if (!local _killer) then {
            [3] remoteExecCall ["MPClient_fnc_removeLicenses",_killer];
        };
    };
};

//Killed by cop stuff...
if (side _killer isEqualTo west && !(playerSide isEqualTo west)) then {
    life_copRecieve = _killer;
    //Did I rob the federal reserve?
    if (!life_var_ATMEnabled && {life_var_cash > 0}) then {
        [format [localize "STR_Cop_RobberDead",[life_var_cash] call MPClient_fnc_numberText]] remoteExecCall ["MPClient_fnc_broadcast",RE_CLIENT];
        ["ZERO","CASH"] call MPClient_fnc_handleMoney;
    };
};

if (!isNull _killer && {!(_killer isEqualTo _unit)}) then {
    life_removeWanted = true;
};
 
[player,life_settings_enableSidechannel,playerSide] remoteExecCall ["MPServer_fnc_managesc",RE_SERVER];

//-- Stop bleeding
["all"] call MPClient_fnc_removeBuff;

//-- Reset any damage
player setDamage 0;

//-- remove death screen
["RscDisplayDeathScreen"] call MPClient_fnc_destroyRscLayer;
closeDialog 0;		
titleCut ["", "BLACK IN", 1];

//--
[] spawn MPClient_fnc_respawned;

true