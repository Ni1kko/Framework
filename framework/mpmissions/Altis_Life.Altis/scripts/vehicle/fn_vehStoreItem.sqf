#include "..\..\clientDefines.hpp"
#define ctrlSelData(ctrl) (lbData[##ctrl,(lbCurSel ##ctrl)])
/*
    File: fn_vehStoreItem.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Used in the vehicle trunk menu, stores the selected item and puts it in the vehicles virtual inventory
    if the vehicle has room for the item.
*/
private ["_ctrl","_num","_totalWeight","_itemWeight","_veh_data","_inv","_index","_val"];
disableSerialization;
if ((life_var_vehicleTrunk getVariable ["trunk_in_use_by",player]) != player) exitWith { closeDialog 0; hint localize "STR_MISC_VehInvUse"; };

_ctrl = ctrlSelData(3503);
_num = ctrlText 3506;
if (!([_num] call MPServer_fnc_isNumber)) exitWith {hint localize "STR_MISC_WrongNumFormat";};
_num = parseNumber(_num);
if (_num < 1) exitWith {hint localize "STR_MISC_Under1";};

_totalWeight = [life_var_vehicleTrunk] call MPClient_fnc_vehicleWeight;

_itemWeight = ([_ctrl] call MPClient_fnc_itemWeight) * _num;
_veh_data = life_var_vehicleTrunk getVariable ["Trunk",[[],0]];
_inv = _veh_data select 0;

if (_ctrl == "goldbar" && {!(life_var_vehicleTrunk isKindOf "LandVehicle")}) exitWith {hint localize "STR_NOTF_canOnlyStoreInLandVeh";};

if (_ctrl == "money") then {
    _index = [_ctrl,_inv] call MPServer_fnc_index;
    if (MONEY_CASH < _num) exitWith {hint localize "STR_NOTF_notEnoughCashToStoreInVeh";};
    if (_index isEqualTo -1) then {
        _inv pushBack [_ctrl,_num];
    } else {
        _val = _inv select _index select 1;
        _inv set[_index,[_ctrl,_val + _num]];
    };

    ["SUB","CASH",_num] call MPClient_fnc_handleMoney;
    
    life_var_vehicleTrunk setVariable ["Trunk",[_inv,(_veh_data select 1) + _itemWeight],true];
    [life_var_vehicleTrunk] call MPClient_fnc_vehInventory;
} else {
    if (((_totalWeight select 1) + _itemWeight) > (_totalWeight select 0)) exitWith {hint localize "STR_NOTF_VehicleFullOrInsufCap";};

    if not(["TAKE",_ctrl,_num] call MPClient_fnc_handleVitrualItem) exitWith {hint localize "STR_CouldNotRemoveItemsToPutInVeh";};
    _index = [_ctrl,_inv] call MPServer_fnc_index;
    if (_index isEqualTo -1) then {
        _inv pushBack [_ctrl,_num];
    } else {
        _val = _inv select _index select 1;
        _inv set[_index,[_ctrl,_val + _num]];
    };

    life_var_vehicleTrunk setVariable ["Trunk",[_inv,(_veh_data select 1) + _itemWeight],true];
    [life_var_vehicleTrunk] call MPClient_fnc_vehInventory;
};