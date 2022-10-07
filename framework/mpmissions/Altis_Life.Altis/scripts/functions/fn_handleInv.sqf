#include "..\..\clientDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
    ## fn_handleInv.sqf
*/

params [
    ["_set",false,[false]],
    ["_item","",[""]],
    ["_amount",0,[0]]
];

//-- Check valid input
if (count _item isEqualTo 0 OR _amount isEqualTo 0) exitWith {false};
if (not(isClass(missionConfigFile >> "cfgVirtualItems" >> _item))) exitWith {false};

//-- Check if we are adding and if they are enough space
_amount = [_amount, [_item,_amount,life_var_carryWeight,life_maxWeight] call MPClient_fnc_calWeightDiff] select _set;
if (_set AND _amount < 1) exitWith {false};

private _var = ITEM_VARNAME(_item);
private _weight = ([_item] call MPClient_fnc_itemWeight) * _amount;
private _value = ITEM_VALUE(_item);
private _return = false;

switch (_set) do {
    case true: 
    {
        private _rankHighEnough = switch (playerSide) do {
            case west: {(call life_copLevel) >= 10};
            case independent: {(call life_medLevel) >= 4};
            case east: {(call life_rebLevel) >= 1};
            case civilian: {license_civ_rebel};
            default {false};
        };

        if(toLower _item in [VITEM_DRUG_MORPHINE] AND (_value + 1) > 3 AND _rankHighEnough)exitWith{
            systemChat format["You are not a skilled enough to carry this quantity of %1",ITEM_DISPLAYNAME(_item)];
        };

        if ((life_var_carryWeight + _weight) <= life_maxWeight) then {
            missionNamespace setVariable [_var,(_value + _amount)];

            if ((missionNamespace getVariable _var) > _value) then {
                life_var_carryWeight = life_var_carryWeight + _weight;
                _return = true;
            };
        };
    };
    case false: 
    {
        if ((_value - _amount) > 0) then {
            missionNamespace setVariable [_var,(_value - _amount)];
            if ((missionNamespace getVariable _var) < _value) then {
                life_var_carryWeight = life_var_carryWeight - _weight;
                _return = true;
            };
        };
    };
};

_return;
