#include "..\..\clientDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
	## fn_giveDiff.sqf
*/

params [
    ["_selectedPlayer", objNull, [objNull]],
    ["_selectedItem", "", [""]],
    ["_selectedAmount", 0, ["",0]],
    ["_senderObject", objNull, [objNull]],
    ["_selectedType", "", [""]]
];

if (_selectedPlayer isNotEqualTo player) exitWith {false};
 
private _type = M_CONFIG(getText,"cfgVirtualItems",_selectedItem,"displayName");

if(typeName _selectedAmount isEqualTo "STRING") then {
    _selectedAmount = parseNumber _selectedAmount;
};

if (["ADD",_selectedItem,_selectedAmount] call MPClient_fnc_handleVitrualItem) then {
    switch _selectedType do 
    {
        case "SPLIT": {hint format [localize "STR_MISC_TooMuch",    _senderObject getVariable ["realname",name _senderObject],  _selectedAmount,  TEXT_LOCALIZE(_type)]};
        case "NONE": {hint format[localize "STR_MISC_TooMuch_2",  _senderObject getVariable ["realname",name _senderObject],  _selectedAmount,  TEXT_LOCALIZE(_type)]};
    };

    if (_selectedItem == VITEM_MISC_MONEY) then { 
        ["ADD","CASH",_selectedAmount] call MPClient_fnc_handleMoney;
    };
};

true