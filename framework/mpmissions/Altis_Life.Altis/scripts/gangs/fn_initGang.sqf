#include "..\..\clientDefines.hpp"
/*
    File: fn_initGang.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Main initialization for gangs.
*/
private ["_exitLoop","_group","_wait"];
if !(playerSide isEqualTo civilian) exitWith {}; //What in the hell?
[player] join (createGroup civilian);
if (count life_var_gangData isEqualTo 0) exitWith {}; //Dafuq?

_wait = round(random(8));
sleep _wait;

//Loop through to make sure there is not a group already created with the gang.
_exitLoop = false;
{
    _groupName = _x getVariable "gang_name";
    if (!isNil "_groupName") then {
        _groupOwner = _x getVariable ["gang_owner",""];
        _groupID = _x getVariable "gang_id";
        if (_groupOwner isEqualTo "" || isNil "_groupID") exitWith {}; //Seriously?
        if ((life_var_gangData select 0) isEqualTo _groupID && {(life_var_gangData select 1) isEqualTo _groupOwner}) exitWith {_group = _x; _exitLoop = true;};
    };
} forEach allGroups;

if (!isNil "_group") then {
    [player] join _group;
    if ((life_var_gangData select 1) isEqualTo getPlayerUID player) then {
        _group selectLeader player;
        [player,_group] remoteExecCall ["MPServer_fnc_clientGangLeader",(units _group)];
    };
} else {
    _group = group player;
    _group setVariable ["gang_id",(life_var_gangData select 0),true];
    _group setVariable ["gang_owner",(life_var_gangData select 1),true];
    _group setVariable ["gang_name",(life_var_gangData select 2),true];
    _group setVariable ["gang_maxMembers",(life_var_gangData select 3),true];
    ["SET","GANG",(life_var_gangData select 4)] call MPClient_fnc_handleMoney;
    _group setVariable ["gang_members",(life_var_gangData select 5),true];
};
