#include "..\..\clientDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
	## fn_dropItem.sqf
*/

params [
	["_selectedPlayer",objNull,[objNull]],
	["_selectedItem","",[""]],
	["_selectedAmount",0,[0]]
];

private _pos = _selectedPlayer modelToWorld[0,3,0];
private _amountOwned = ITEM_VALUE(_selectedItem);
private _itemName = ITEM_VARNAME(_selectedItem);
private _itemClass = ITEM_OBJECT(_selectedItem);
private _itemPos = [_pos#0,_pos#1,0];
private _didDrop = false;

//Handle droping cash.
if(_selectedItem isEqualTo VITEM_MISC_MONEY)then
{
	//-- Remove that cash
	if(_selectedAmount > 0 AND MONEY_CASH > 0 AND MONEY_CASH >= _selectedAmount)then{
		["SUB","CASH", _selectedAmount] call MPClient_fnc_handleMoney;
	}else{
		["ZERO","CASH"] call MPClient_fnc_handleMoney;
	};
};

//Handle droping item.
if (_amountOwned > 0 AND _amountOwned >= _selectedAmount) then 
{
	
	private _allvitems = virtualNamespace getVariable ["allvitems",[]];
	private _vitemIndex = _allvitems find (netID _object);
	
	if(["TAKE",_selectedItem,_selectedAmount] call MPClient_fnc_handleVitrualItem)then
	{
		//-- Create object
		if(_vitemIndex isEqualTo -1 AND count _itemClass > 0)then{
			//["DROP"] remoteExecCall ["MPServer_fnc_handleVirtualItemRequest",2];// TodDo create server function to handle this serverside
			_allvitems pushBackUnique netID(_itemClass createVehicle _itemPos);
			_itemObject enableDynamicSimulation true;
			_itemObject enableSimulationGlobal true;
		};
		
		//-- Get object
		private _itemObject = objectFromNetId(_allvitems param [_vitemIndex,""]);
		
		//-- do we have an object?
		if not(isNull _itemObject)then
		{ 
			[_itemObject] remoteExecCall ["MPClient_fnc_simDisable",RE_GLOBAL];
			_itemObject setPos _itemPos;

			(_itemObject getVariable ["item",[]]) params [
				["_item",""],
				["_amount",0]
			];
			
			if(_item isEqualTo _selectedItem)then{
				//-- Update it 
				_itemObject setVariable ["item",[_selectedItem,(_amount + _selectedAmount)],true];
			}else{
				//-- Add it 
				_itemObject setVariable ["item",[_selectedItem,_selectedAmount],true];
			};
			
			//-- Add object to array
			private _allvitems = virtualNamespace getVariable ["allvitems",[]];
			_allvitems pushBackUnique netID _itemObject;
			virtualNamespace setvariable ["allvitems",_allvitems,true];
		};
	};

	_didDrop = true;
};

_didDrop