#include "..\..\script_macros.hpp"
/*
    File: fn_s_onCheckedChange.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Switching it up and making it prettier..
*/
private ["_option","_state"];
_option = _this select 0;
_state = _this select 1;

switch (_option) do {
    case "tags": {
        if (_state isEqualTo 1) then {
            life_var_enablePlayerTags = true;
            profileNamespace setVariable ["life_var_enablePlayerTags",true];
            life_var_playerTagsEVH = addMissionEventHandler ["EachFrame", MPClient_fnc_playerTags];
        } else {
            life_var_enablePlayerTags = false;
            profileNamespace setVariable ["life_var_enablePlayerTags",false];
            removeMissionEventHandler ["EachFrame", life_var_playerTagsEVH];
        };
    };

    case "objects": {
        if (_state isEqualTo 1) then {
            life_var_enableRevealObjects = true;
            profileNamespace setVariable ["life_var_enableRevealObjects",true];
            life_var_revealObjectsEVH = addMissionEventHandler ["EachFrame",{_this call MPClient_fnc_revealObjects}];
        } else {
            life_var_enableRevealObjects = false;
            profileNamespace setVariable ["life_var_enableRevealObjects",false];
            removeMissionEventHandler ["EachFrame",  life_var_revealObjectsEVH];
        };
    };

    case "sidechat": {
        if (_state isEqualTo 1) then {
            life_enableSidechannel = true;
            profileNamespace setVariable ["life_enableSidechannel",true];
            life_var_enableSidechannel = profileNamespace getVariable ["life_enableSidechannel",true];
        } else {
            life_enableSidechannel = false;
            profileNamespace setVariable ["life_enableSidechannel",false];
            life_var_enableSidechannel = profileNamespace getVariable ["life_enableSidechannel",false];
        };
        [player,life_var_enableSidechannel,playerSide] remoteExecCall ["MPServer_fnc_managesc",RE_SERVER];
    };

    case "broadcast": {
        if (_state isEqualTo 1) then {
            life_enableNewsBroadcast = true;
            profileNamespace setVariable ["life_enableNewsBroadcast",true];
            life_var_enableNewsBroadcast = profileNamespace getVariable ["life_enableNewsBroadcast",true];
        } else {
            life_enableNewsBroadcast = false;
            profileNamespace setVariable ["life_enableNewsBroadcast",false];
            life_var_enableNewsBroadcast = profileNamespace getVariable ["life_enableNewsBroadcast",false];
        };
    };
};
