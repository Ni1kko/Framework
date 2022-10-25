#include "..\..\clientDefines.hpp"
/*
    File: fn_jail.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Starts the initial process of jailing.
*/
private ["_illegalItems"];
params [
    ["_unit",objNull,[objNull]],
    ["_bad",false,[false]]
];

if (isNull _unit) exitWith {}; //Dafuq?
if (_unit isNotEqualTo player) exitWith {}; //Dafuq?
if (player getVariable ["arrested",false]) exitWith {}; //Dafuq i'm already arrested
_illegalItems = CFG_MASTER(getArray,"jail_seize_vItems");

player setVariable ["restrained",false,true];
player setVariable ["Escorting",false,true];
player setVariable ["transporting",false,true];
player setVariable ["teleported",true,true];


titleText[localize "STR_Jail_Warn","PLAIN"];
hint localize "STR_Jail_LicenseNOTF";
player setPos (getMarkerPos "jail_marker");

if (_bad) then {
    waitUntil {alive player};
    sleep 1;
};

//Check to make sure they goto check
if (player distance (getMarkerPos "jail_marker") > 40) then {
    player setPos (getMarkerPos "jail_marker");
};

[player, ["gun", "driver", "rebel"]] call MPClient_fnc_removeLicenses;

{
    _amount = ITEM_VALUE(_x);
    if (_amount > 0) then {
        ["USE",_x,_amount] call MPClient_fnc_handleVitrualItem;
    };
} forEach _illegalItems;

player setVariable ["arrested",true,true];

if (CFG_MASTER(getNumber,"jail_seize_inventory") isEqualTo 1) then {
    [] spawn MPClient_fnc_seizeClient;
} else {
    removeAllWeapons player;
    {player removeMagazine _x} forEach (magazines player);
};

if (count extdb_var_database_headless_clients > 0) then {
    [player,_bad] remoteExecCall ["HC_fnc_jailSys",extdb_var_database_headless_client];
} else {
    [player,_bad] remoteExecCall ["MPServer_fnc_jailSys",RE_SERVER];
};

[5] call MPClient_fnc_updatePlayerDataPartial;
[]spawn{
    sleep 5;
    player setVariable ["teleported",false,true];
};