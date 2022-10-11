#include "..\..\clientDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
    ## fn_handleVitrualItem.sqf
*/

params [
    ["_mode","TAKE",[""]],
    ["_selectedItem","",[""]],
    ["_selectedAmount",0,[0]],
    ["_inventoryType","Player",[""]]
];

//-- Check valid input
if (count _selectedItem isEqualTo 0 OR _selectedAmount isEqualTo 0) exitWith {false};
if not(isClass(missionConfigFile >> "cfgVirtualItems" >> _selectedItem)) exitWith {false};
if not(_mode in ["ADD","TAKE","GIVE"]) exitWith {false};

private _itemVarName = ITEM_VARNAME(_selectedItem);
private _itemWeight = ([_selectedItem] call MPClient_fnc_itemWeight) * _selectedAmount;
private _currentValue = ITEM_VALUE(_selectedItem);
private _return = false;

//-- Check if we are adding and if they are enough space
if (_mode isEqualTo "ADD") then {
    _selectedAmount = [_selectedItem,_selectedAmount,life_var_carryWeight,life_maxWeight] call MPClient_fnc_calWeightDiff;
};

//--
if (_selectedAmount < 1) exitWith {_return};

//-- Handle muliple inventory types
if(_inventoryType in ["House","Vehicle","Tent"])then
{
    private _selectedObject = param [4,objNull,[objNull]];
    
    if not(isNull _selectedObject)then
    {
        private _inventory = _selectedObject getVariable ["virtualInventory",[]];
        switch _mode do
        {
            case "ADD": {};
            case "TAKE": {};
            case "GIVE": {};
        };
    };
}else{
    switch _inventoryType do 
    {
        case "Player": 
        { 
            switch _mode do 
            {
                case "ADD": 
                {
                    if(toLower _selectedItem in [VITEM_DRUG_MORPHINE] AND (_currentValue + 1) > 3 AND {(call life_copLevel) < 10 AND {(call life_medLevel) < 4 AND {(call life_rebLevel) < 1 AND {not(license_civ_rebel)}}}})exitWith{
                        systemChat format["You are not a skilled enough to carry this quantity of %1",ITEM_DISPLAYNAME(_selectedItem)];
                    }; 
                    
                    private _adjustment = ADD(_currentValue, _selectedAmount);
                    private _adjustmentWeight = ADD(life_var_carryWeight, _itemWeight);

                    if (_adjustmentWeight <= life_maxWeight) then 
                    {
                        missionNamespace setVariable [_itemVarName,_adjustment];
                        if (_adjustment > _currentValue) then {
                            life_var_carryWeight = _adjustmentWeight;
                            _currentValue = _adjustment;
                            if (_selectedItem == VITEM_MISC_MONEY) then { 
                                ["ADD","CASH",_selectedAmount] call MPClient_fnc_handleMoney;
                            };
                            _return = true;
                        };
                    };
                };
                case "TAKE":
                {
                    private _adjustment = SUB(_currentValue, _selectedAmount);
                    if (_adjustment >= 0) then 
                    {
                        missionNamespace setVariable [_itemVarName,_adjustment];
                        if (_adjustment < _currentValue) then {
                            life_var_carryWeight = SUB(life_var_carryWeight, _itemWeight);
                            _currentValue = _adjustment;
                            if (_selectedItem == VITEM_MISC_MONEY) then { 
                                ["SUB","CASH",_selectedAmount] call MPClient_fnc_handleMoney;
                            };
                            _return = true;
                        };
                    };
                };
                case "GIVE":
                {
                    private _selectedPlayer = param [4,objNull,[objNull]];
                    private _adjustment = SUB(_currentValue, _selectedAmount);
                    if (_adjustment >= 0 AND not(isNull(_selectedPlayer)) AND {_selectedPlayer isNotEqualTo player}) then 
                    {
                        missionNamespace setVariable [_itemVarName,_adjustment];
                        if (_adjustment < _currentValue) then {
                            life_var_carryWeight = SUB(life_var_carryWeight, _itemWeight);
                            if (_selectedItem == VITEM_MISC_MONEY) then { 
                                ["SUB","CASH",_selectedAmount] call MPClient_fnc_handleMoney;
                            };
                            [_selectedPlayer, _selectedAmount, _selectedItem,  player] remoteExecCall ["MPClient_fnc_receiveItem", owner _selectedPlayer];
                            _currentValue = _adjustment;
                            _return = true;
                        };
                    };
                };
            }; 
        };
        case "Ground": 
        { 
            private _selectedContainer = param [4,objNull,[objNull]];

            if not(isNull _selectedContainer)then
            {
                switch _mode do 
                {
                    case "ADD": {};
                    case "TAKE": {};
                    case "GIVE": {};
                };
            };
        };
    };
};

//--

_return;



