#include "..\..\script_macros.hpp"
/*
    File: fn_gangInvite.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Prompts the player about an invite.
*/
private ["_action","_grpMembers"];
params [
    ["_name","",[""]],
    ["_group",grpNull,[grpNull]]
];

if (_name isEqualTo "" || isNull _group) exitWith {}; //Fail horn anyone?
if (!isNil {(group player) getVariable "gang_name"}) exitWith {hint localize "STR_GNOTF_AlreadyInGang";};

_gangName = _group getVariable "gang_name";
_action = [
    format [localize "STR_GNOTF_InviteMSG",_name,_gangName],
    localize "STR_Gang_Invitation",
    localize "STR_Global_Yes",
    localize "STR_Global_No"
] call BIS_fnc_guiMessage;

if (_action) then {
    [player] join _group;
} else {
    _grpMembers = _group getVariable "gang_members";
    _grpMembers = _grpMembers - [getPlayerUID player];
    _group setVariable ["gang_members",_grpMembers,true];
};

[4,_group] remoteExecCall ["MPServer_fnc_updateGangDataRequestPartial",RE_SERVER];

true
