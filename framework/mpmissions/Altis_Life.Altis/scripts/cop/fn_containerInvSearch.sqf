#include "..\..\clientDefines.hpp"
/*
    File: fn_containerInvSearch.sqf
    Author: NiiRoZz
    Inspired : Bryan "Tonic" Boardwine

    Description:
    Searches the container for illegal items.
*/
private ["_container","_containerInfo","_value"];
_container = [_this,0,objNull,[objNull]] call BIS_fnc_param;
if (isNull _container) exitWith {};

_containerInfo = _container getVariable ["Trunk",[]];
if (count _containerInfo isEqualTo 0) exitWith {hint localize "STR_Cop_ContainerEmpty"};

_value = 0;
_illegalValue = 0;
{
    _var = _x select 0;
    _val = _x select 1;
    _isIllegalItem = M_CONFIG(getNumber,"cfgVirtualItems",_var,"illegal");
    if (_isIllegalItem isEqualTo 1 ) then {
        _illegalPrice = M_CONFIG(getNumber,"cfgVirtualItems",_var,"sellPrice");
        /*
        if (!isNull (missionConfigFile >> "cfgVirtualItems" >> _var >> "processedItem")) then {
            _illegalItemProcessed = M_CONFIG(getText,"cfgVirtualItems",_var,"processedItem");
            _illegalPrice = M_CONFIG(getNumber,"cfgVirtualItems",_illegalItemProcessed,"sellPrice");
        };
        */

        _illegalValue = _illegalValue + (round(_val * _illegalPrice / 2));
    };
} forEach (_containerInfo select 0);
_value = _illegalValue;
if (_value > 0) then {
    [0,"STR_NOTF_ContainerContraband",true,[[_value] call MPClient_fnc_numberText]] remoteExecCall ["MPClient_fnc_broadcast",RE_CLIENT];
    ["ADD","BANK",_value] call MPClient_fnc_handleMoney;
    _container setVariable ["Trunk",[[],0],true];
    [_container] remoteExecCall ["MPServer_fnc_updateHouseTrunk",2];
} else {
    hint localize "STR_Cop_NoIllegalContainer";
};

true