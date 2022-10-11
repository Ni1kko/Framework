#include "..\..\clientDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
	## fn_receiveItem.sqf
*/

params [
    ["_selectedPlayer", objNull, [objNull]],
    ["_selectedAmount", 0, ["",0]],
    ["_selectedItem", "", [""]],
    ["_senderObject", objNull, [objNull]]
];

if (_selectedPlayer isNotEqualTo player) exitWith {false};

if(typeName _selectedAmount isEqualTo "STRING") then {
    _selectedAmount = parseNumber _selectedAmount;
};

private _diff = [_selectedItem,_selectedAmount,life_var_carryWeight,life_maxWeight] call MPClient_fnc_calWeightDiff;
private _senderName = _senderObject getVariable ["realname",name _senderObject];

//-- 
if (_diff isNotEqualTo _selectedAmount) then 
{
    //-- If the player carry more than they can try add max that we can and return rest
    if (["ADD",_selectedItem,_diff] call MPClient_fnc_handleVitrualItem) then 
    {
        private _adjustment = _selectedAmount - _diff;
        hint format [localize "STR_MISC_TooMuch_3",_senderName,_selectedAmount,_diff,_adjustment];
        if (_selectedItem == VITEM_MISC_MONEY) then { 
            ["ADD","CASH",_diff] call MPClient_fnc_handleMoney;
        };
        [_senderObject,_selectedItem,_adjustment,_selectedPlayer,"SPLIT"] remoteExecCall ["MPClient_fnc_giveDiff",_senderObject];
    } else {
        //-- If we can't add the item at all then return all to sender
        [_senderObject,_selectedItem,_selectedAmount,_selectedPlayer,"NONE"] remoteExecCall ["MPClient_fnc_giveDiff",_senderObject];
    };
} else {
    if (["ADD",_selectedItem,(parseNumber _selectedAmount)] call MPClient_fnc_handleVitrualItem) then {
        private _itemDisplayName = LICENSE_DISPLAYNAME(_selectedItem);
        if (_selectedItem == VITEM_MISC_MONEY) then { 
            ["ADD","CASH",_selectedAmount] call MPClient_fnc_handleMoney;
        };
        hint format [localize "STR_NOTF_GivenItem",_senderName,_selectedAmount,_itemDisplayName];
    } else {
        [_senderObject,_selectedItem,_selectedAmount,_selectedPlayer,"NONE"] remoteExecCall ["MPClient_fnc_giveDiff",_senderObject];
    };
};