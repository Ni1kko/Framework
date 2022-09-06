#include "..\..\script_macros.hpp"
/*
    File: fn_gangLeave.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    32 hours later...
*/
private ["_unitID ","_members"];
if (getPlayerUID player isEqualTo (group player getVariable "gang_owner")) exitWith {hint localize "STR_GNOTF_LeaderLeave"};

_unitID = getPlayerUID player;
_members = group player getVariable "gang_members";
if (isNil "_members") exitWith {};
if (!(_members isEqualType [])) exitWith {};

_members = _members - [_unitID];
group player setVariable ["gang_members",_members,true];

[player,group player] remoteExec ["MPServer_fnc_clientGangLeft",player];

if (count extdb_var_database_headless_clients > 0) then {
    [4,group player] remoteExec ["HC_fnc_updateGang",extdb_var_database_headless_client]; //Update the database.
} else {
    [4,group player] remoteExec ["MPServer_fnc_updateGang",RSERV]; //Update the database.
};

closeDialog 0;
