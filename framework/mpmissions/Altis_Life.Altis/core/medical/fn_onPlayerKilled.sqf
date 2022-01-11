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

diag_log format ["You got killed by %1(%2)",_killer getVariable["realname",""],getPlayerUID _killer];
if  !((vehicle _unit) isEqualTo _unit) then {
    UnAssignVehicle _unit;
    _unit action ["getOut", vehicle _unit];
    _unit setPosATL [(getPosATL _unit select 0) + 3, (getPosATL _unit select 1) + 1, 0];
};

//Set some vars
_unit setVariable ["Revive",true,true];
_unit setVariable ["name",profileName,true]; //Set my name so they can say my name.
_unit setVariable ["restrained",false,true];
_unit setVariable ["Escorting",false,true];
_unit setVariable ["transporting",false,true];
_unit setVariable ["playerSurrender",false,true];
_unit setVariable ["steam64id",(getPlayerUID player),true]; //Set the UID.

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
            [getPlayerUID _killer,_killer getVariable ["realname",name _killer],"187V"] remoteExecCall ["life_fnc_wantedAdd",RSERV];
        };

        //Get rid of this if you don't want automatic vehicle license removal.
        if (!local _killer) then {
            [2] remoteExecCall ["life_fnc_removeLicenses",_killer];
        };
    } else {
        if (count extdb_var_database_headless_clients > 0) then {
            [getPlayerUID _killer,_killer getVariable ["realname",name _killer],"187"] remoteExecCall ["HC_fnc_wantedAdd",extdb_var_database_headless_client];
        } else {
            [getPlayerUID _killer,_killer getVariable ["realname",name _killer],"187"] remoteExecCall ["life_fnc_wantedAdd",RSERV];
        };

        if (!local _killer) then {
            [3] remoteExecCall ["life_fnc_removeLicenses",_killer];
        };
    };
};

life_save_gear = [player] call life_fnc_fetchDeadGear;

if (LIFE_SETTINGS(getNumber,"drop_weapons_onDeath") isEqualTo 0) then {
    _unit removeWeapon (primaryWeapon _unit);
    _unit removeWeapon (handgunWeapon _unit);
    _unit removeWeapon (secondaryWeapon _unit);
};

//Killed by cop stuff...
if (side _killer isEqualTo west && !(playerSide isEqualTo west)) then {
    life_copRecieve = _killer;
    //Did I rob the federal reserve?
    if (!life_use_atm && {life_var_cash > 0}) then {
        [format [localize "STR_Cop_RobberDead",[life_var_cash] call life_fnc_numberText]] remoteExecCall ["life_fnc_broadcast",RCLIENT];
        life_var_cash = 0;
    };
};

if (!isNull _killer && {!(_killer isEqualTo _unit)}) then {
    life_removeWanted = true;
};

[_unit] call life_fnc_dropItems;

life_action_inUse = false;
life_hunger = 100;
life_thirst = 100;
life_carryWeight = 0;
life_var_cash = 0;
life_is_alive = false;

[player,life_settings_enableSidechannel,playerSide] remoteExecCall ["TON_fnc_manageSC",RSERV];

[0] call SOCK_fnc_updatePartial;
[3] call SOCK_fnc_updatePartial;
if (playerSide isEqualTo civilian) then {
    [4] call SOCK_fnc_updatePartial;
};