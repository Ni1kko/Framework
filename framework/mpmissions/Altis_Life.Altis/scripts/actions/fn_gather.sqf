#include "..\..\clientDefines.hpp"
/*
    File: fn_gather.sqf
    Author: Devilfloh

    Description:
    Main functionality for gathering.
*/
private ["_maxGather","_resource","_amount","_maxGather","_requiredItem"];
if (life_var_isBusy) exitWith {};
if !(isNull objectParent player) exitWith {};
if (player getVariable "restrained") exitWith {hint localize "STR_NOTF_isrestrained";};
if (player getVariable "playerSurrender") exitWith {hint localize "STR_NOTF_surrender";};

life_var_isBusy = true;
_zone = "";
_requiredItem = "";
_exit = false;

_resourceCfg = missionConfigFile >> "CfgGather" >> "Resources";
for "_i" from 0 to count(_resourceCfg)-1 do {

    _curConfig = _resourceCfg select _i;
    _resource = configName _curConfig;
    _maxGather = getNumber(_curConfig >> "amount");
    _zoneSize = getNumber(_curConfig >> "zoneSize");
    _resourceZones = getArray(_curConfig >> "zones");
    _requiredItem = getText(_curConfig >> "item");
    {
        if ((player distance (getMarkerPos _x)) < _zoneSize) exitWith {_zone = _x;};
    } forEach _resourceZones;

    if (_zone != "") exitWith {};
};

if (_zone isEqualTo "") exitWith {life_var_isBusy = false;};

if (_requiredItem != "") then {
    _valItem = missionNamespace getVariable "life_inv_" + _requiredItem;

    if (_valItem < 1) exitWith {
        switch (_requiredItem) do {
         //Messages here
        };
        life_var_isBusy = false;
        _exit = true;
    };
};

if (_exit) exitWith {life_var_isBusy = false;};

_amount = round(random(_maxGather)) + 1;
_diff = [_resource,_amount,life_var_carryWeight,life_maxWeight] call MPClient_fnc_calWeightDiff;
if (_diff isEqualTo 0) exitWith {
    hint localize "STR_NOTF_InvFull";
    life_var_isBusy = false;
};

switch (_requiredItem) do {
    case "pickaxe": {[player,"mining",35,1] remoteExecCall ["MPClient_fnc_say3D",RE_CLIENT]};
    default {[player,"harvest",35,1] remoteExecCall ["MPClient_fnc_say3D",RE_CLIENT]};
};

for "_i" from 0 to 4 do {
    player playMoveNow "AinvPercMstpSnonWnonDnon_Putdown_AmovPercMstpSnonWnonDnon";
    waitUntil{animationState player != "AinvPercMstpSnonWnonDnon_Putdown_AmovPercMstpSnonWnonDnon";};
    sleep 0.5;
};

if (["ADD",_resource,_diff] call MPClient_fnc_handleVitrualItem) then {
    _itemName = M_CONFIG(getText,"cfgVirtualItems",_resource,"displayName");
    titleText[format [localize "STR_NOTF_Gather_Success",TEXT_LOCALIZE(_itemName),_diff],"PLAIN"];
};

sleep 1;
life_var_isBusy = false;
