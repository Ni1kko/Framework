#include "..\..\clientDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
    ## fn_handleVitrualItem.sqf
*/

params [
    ["_mode","USE",[""]],
    ["_selectedItem","",[""]],
    ["_selectedAmount",0,[0]],
    ["_inventoryType","Player",[""]]
];

//-- Check valid input
if (count _selectedItem isEqualTo 0 OR _selectedAmount isEqualTo 0) exitWith {false};
if not(_mode in ["ADD","USE","GIVE","PUT","DROP"]) exitWith {false};

if(count (_selectedItem splitString "_") >= 2) then {
    {
        private _classname = configName _x;
        
        if(toLower _selectedItem in [toLower _classname,toLower(ITEM_VARNAME(_selectedItem))])exitWith{
            _selectedItem = _classname;
        };
    }forEach ("true" configClasses (missionConfigFile >> "cfgVirtualItems"));
};

if not(isClass(missionConfigFile >> "cfgVirtualItems" >> _selectedItem)) exitWith {false};

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
if(_inventoryType isEqualTo "Player")then
{
    switch _mode do 
    {
        //-- Put item into (player) virtualItems
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
        //-- Take item from (player) virtualItems (gets deleted)
        case "USE":
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
        //-- Give item from (player) virtualItems to (x target) virtualItems
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
        //-- Drop item from (player) virtualItems to (ground)
        case "DROP":
        { 
           if([player,_selectedItem,_selectedAmount] call MPClient_fnc_dropItem)then{
                _return = true;
            };
        };
        //-- Put item from (player) virtualItems to (vehicle\house\ground\tent) virtualItems
        case "PUT": 
        {
            private _selectedObject = param [4,objNull,[objNull]];
    
            if not(isNull _selectedObject)then
            {
                (_selectedObject getVariable ["virtualInventory",[]]) params [
                    ["_invArray",[],[[]]],
                    ["_invWeight",0,[0]]
                ];

                ([_selectedObject] call MPClient_fnc_vehicleWeight) params [
                    ["_maxWeight",0,[0]],
                    ["_actualWeight",-1,[0]]
                ];

                //-- Dafuq happened? item added manual and weight not tracked...
                if(_invWeight isNotEqualTo _actualWeight)then {
                    _invWeight = _actualWeight;
                };
                private _arrayIndex = _invArray find _selectedItem;
                private _selectedArray = [_invArray param [_arrayIndex,["",-1]], ["",-1]] select (_arrayIndex isEqualTo -1);
                private _currentValue = _selectedArray param [1,0];
                private _adjustment = SUB(_currentValue, _selectedAmount);
                private _adjustmentWeight = ADD(_invWeight, _itemWeight);

                if (_adjustmentWeight <= _maxWeight  AND _adjustment > _currentValue) then 
                {
                    missionNamespace setVariable [_itemVarName,_adjustment];
                    if (_adjustment < _currentValue) then {
                        life_var_carryWeight = SUB(life_var_carryWeight, _itemWeight);
                        _invWeight = ADD(_invWeight, _itemWeight); 

                        if (_selectedItem == VITEM_MISC_MONEY) then { 
                            ["SUB","CASH",_selectedAmount] call MPClient_fnc_handleMoney;
                        };

                        if(_arrayIndex isEqualTo -1)then {
                            // Item not found in array, add it
                            _arrayIndex = _invArray pushBackUnique [_selectedItem,_selectedAmount];
                        }else{
                            // Item found in array, update amount
                            _invArray set [_arrayIndex,[_selectedItem,_selectedAmount]];
                        };

                        _selectedObject setVariable ["virtualInventory",[_invArray,_invWeight],true];

                        _return = true;
                    };
                };
            };
        };
    };
}else{
    private _selectedObject = param [4,objNull,[objNull]];
    
    if not(isNull _selectedObject)then
    {
        (_selectedObject getVariable ["virtualInventory",[]]) params [
            ["_invArray",[],[[]]],
            ["_invWeight",0,[0]]
        ];

        ([_selectedObject] call MPClient_fnc_vehicleWeight) params [
            ["_maxWeight",0,[0]],
            ["_actualWeight",-1,[0]]
        ];

        //-- Dafuq happened? item added manual and weight not tracked...
        if(_invWeight isNotEqualTo _actualWeight)then {
            _invWeight = _actualWeight;
        };

        switch _mode do
        {
            //-- Take item from (vehicle\house\ground\tent) virtualItems to (player) virtualItems
            case "USE":
            {
                private _arrayIndex = _invArray find _selectedItem;
                private _selectedArray = [_invArray param [_arrayIndex,["",-1]], ["",-1]] select (_arrayIndex isEqualTo -1);
                private _currentValue = _selectedArray param [1,0];
                private _adjustment = ADD(_currentValue, _selectedAmount);
                private _adjustmentWeight = ADD(life_var_carryWeight, _itemWeight);

                if (_adjustmentWeight <= life_maxWeight AND _adjustment > _currentValue AND _arrayIndex isNotEqualTo -1) then 
                {
                    missionNamespace setVariable [_itemVarName,_adjustment];
                    
                    life_var_carryWeight = _adjustmentWeight;
                    _invWeight = SUB(_invWeight, _itemWeight); 

                    if (_selectedItem == VITEM_MISC_MONEY) then { 
                        ["ADD","CASH",_selectedAmount] call MPClient_fnc_handleMoney;
                    };
 
                    _invArray deleteAt _arrayIndex;

                    _selectedObject setVariable ["virtualInventory",[_invArray,_invWeight],true];

                    _return = true;
                
                }; 
            };
        };
    };
};

//--

_return;



