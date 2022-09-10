#include "..\..\script_macros.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

params [
	["_player",objNull,[objNull]],
	["_item","",[""]],
	["_count",0,[0]]
];

//Is money var?
if(_item isEqualTo _cashvar)then{
	_item = VITEM_MISC_MONEY;
};

private _pos = _player modelToWorld[0,3,0];
private _itemName = ITEM_VARNAME(_item);
private _itemValue = ITEM_VALUE(_item);
private _itemObject = ITEM_OBJECT(_item);
private _itemObjectPos = [_pos#0,_pos#1,0];
private _didDrop = false;

//Handle droping cash.
if(_item isEqualTo VITEM_MISC_MONEY)then{
	private _cashvar = "life_var_cash";
	_itemValue = missionNamespace getVariable [_cashvar,0];
	_itemName = _cashvar;
	
	//-- Remove that cash
	if(_count > 0 AND _itemValue > 0 AND _itemValue >= _count)then{
		["SUB","CASH", _count] call MPClient_fnc_handleMoney;
	}else{
		["ZERO","CASH"] call MPClient_fnc_handleMoney;
	};
};

//Handle droping item.
if (_itemValue > 0 AND _itemValue >= _count) then {
	private _obj = _itemObject createVehicle _itemObjectPos;
	[_obj] remoteExecCall ["MPClient_fnc_simDisable",RE_GLOBAL];
	_obj setPos _itemObjectPos;
	_obj setVariable ["item",[_item,_itemValue],true];
	[false,_itemName,(_itemValue - _count)] call MPClient_fnc_handleInv;
	_didDrop = true;
};

_didDrop