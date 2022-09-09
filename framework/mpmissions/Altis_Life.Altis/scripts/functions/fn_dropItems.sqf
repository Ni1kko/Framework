#include "..\..\script_macros.hpp"
/*
    File: fn_dropItems.sqf
    Author: Tonic & Ni1kko

    Description:
    Called on death, player drops any 'virtual' items they may be carrying.
*/

params [
    ["_unit",objNull]
];

private _cashvar = "life_var_cash";
private _pos = _unit modelToWorld[0,3,0];

{
    private _item = (if(_x isEqualType "")then{_x}else{configName _x});
    
    //Is money var?
    if(_item isEqualTo _cashvar)then{
        _item = VITEM_MISC_MONEY;
    };

    //Get item info.
    private _itemName = ITEM_VARNAME(_item);
    private _itemValue = ITEM_VALUE(_item);
    private _itemObject = ITEM_OBJECT(_item);
    private _itemObjectPos = [_pos#0,_pos#1,0];

    //Handle droping cash.
    if(_item isEqualTo VITEM_MISC_MONEY)then{
        _itemValue = missionNamespace getVariable [_cashvar,0];
        _itemName = _cashvar; 
    };

    //Handle droping item.
    if (_itemValue > 0) then {
        private _obj = _itemObject createVehicle _itemObjectPos;
        [_obj] remoteExecCall ["MPClient_fnc_simDisable",RANY];
        _obj setPos _itemObjectPos;
        _obj setVariable ["item",[_item,_itemValue],true];
        missionNamespace setVariable [_itemName,0];
    };
} forEach ("true" configClasses (missionConfigFile >> "VirtualItems"));


life_var_carryWeight = 0;

true