#include "..\..\clientDefines.hpp"
#define ctrlSelData(ctrl) (lbData[##ctrl,(lbCurSel ##ctrl)])
/*
    File: fn_vehTakeItem.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Used in the vehicle trunk menu, takes the selected item and puts it in the players virtual inventory
    if the player has room.
*/
private ["_ctrl","_num","_index","_data","_old","_value","_weight","_diff"];
disableSerialization;
if (isNull life_var_vehicleTrunk || !alive life_var_vehicleTrunk) exitWith {hint localize "STR_MISC_VehDoesntExist"};
if (!alive player) exitWith {closeDialog 0;};
if ((life_var_vehicleTrunk getVariable ["trunk_in_use_by",player]) != player) exitWith {  closeDialog 0; hint localize "STR_MISC_VehInvUse"; };

if ((lbCurSel 3502) isEqualTo -1) exitWith {hint localize "STR_Global_NoSelection";};
_ctrl = ctrlSelData(3502);
_num = ctrlText 3505;
if (!([_num] call MPServer_fnc_isNumber)) exitWith {hint localize "STR_MISC_WrongNumFormat";};
_num = parseNumber(_num);
if (_num < 1) exitWith {hint localize "STR_MISC_Under1";};

_index = [_ctrl,((life_var_vehicleTrunk getVariable "virtualInventory") select 0)] call MPServer_fnc_index;
_data = (life_var_vehicleTrunk getVariable "virtualInventory") select 0;
_old = life_var_vehicleTrunk getVariable "virtualInventory";
if (_index isEqualTo -1) exitWith {};
_value = _data select _index select 1;
if (_num > _value) exitWith {hint localize "STR_MISC_NotEnough"};
_num = [_ctrl,_num,life_var_carryWeight,life_maxWeight] call MPClient_fnc_calWeightDiff;
if (_num isEqualTo 0) exitWith {hint localize "STR_NOTF_InvFull"};
_weight = ([_ctrl] call MPClient_fnc_itemWeight) * _num;
if (_ctrl == "money") then {
    if (_num == _value) then {
        _data deleteAt _index;
    } else {
        _data set[_index,[_ctrl,(_value - _num)]];
    };

    ["ADD","CASH",_num] call MPClient_fnc_handleMoney;
    life_var_vehicleTrunk setVariable ["virtualInventory",[_data,(_old select 1) - _weight],true];
    [life_var_vehicleTrunk] call MPClient_fnc_vehInventory;
} else {
    if (["ADD",_ctrl,_num] call MPClient_fnc_handleVitrualItem) then {
        if (_num == _value) then {
            _data deleteAt _index;
        } else {
            _data set[_index,[_ctrl,(_value - _num)]];
        };
        life_var_vehicleTrunk setVariable ["virtualInventory",[_data,(_old select 1) - _weight],true];
        [life_var_vehicleTrunk] call MPClient_fnc_vehInventory;
    } else {
        hint localize "STR_NOTF_InvFull";
    };
};
