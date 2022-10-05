#include "..\..\script_macros.hpp"
/*
    File: fn_vehInvSearch.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Searches the vehicle for illegal items.
*/
private ["_vehicle","_vehicleInfo","_value","_list"];
_vehicle = cursorObject;
_list = ["Air","Ship","LandVehicle"];
if (isNull _vehicle || {!(KINDOF_ARRAY(_vehicle,_list))}) exitWith {};

_vehicleInfo = _vehicle getVariable ["Trunk",[]];
if (count _vehicleInfo isEqualTo 0) exitWith {hint localize "STR_Cop_VehEmpty"};

_value = 0;
_illegalValue = 0;
{
    _var = _x select 0;
    _val = _x select 1;
    _isIllegalItem = M_CONFIG(getNumber,"cfgVirtualItems",_var,"illegal");
    if (_isIllegalItem isEqualTo 1 ) then{
        _illegalPrice = M_CONFIG(getNumber,"cfgVirtualItems",_var,"sellPrice");
        /*
        if (!isNull (missionConfigFile >> "cfgVirtualItems" >> _var >> "processedItem")) then {
            _illegalItemProcessed = M_CONFIG(getText,"cfgVirtualItems",_var,"processedItem");
            _illegalPrice = M_CONFIG(getNumber,"cfgVirtualItems",_illegalItemProcessed,"sellPrice");
        };
        */

        _illegalValue = _illegalValue + (round(_val * _illegalPrice / 2));
    };
} forEach (_vehicleInfo select 0);
_value = _illegalValue;
if (_value > 0) then {
    [0,"STR_NOTF_VehContraband",true,[[_value] call MPClient_fnc_numberText]] remoteExecCall ["MPClient_fnc_broadcast",RE_CLIENT];
    ["ADD","BANK",_value] call MPClient_fnc_handleMoney;
    _vehicle setVariable ["Trunk",[[],0],true];
} else {
    hint localize "STR_Cop_NoIllegalVeh";
};
