#include "..\..\clientDefines.hpp"

/*
    File: fn_giveItem.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Gives the selected item & amount to the selected player and
    removes the item & amount of it from the players virtual
    inventory.
*/

ctrlShow [112,false];

private _value = ctrlText 110;

if ((lbCurSel 111) isEqualTo -1) exitWith {
    hint localize "STR_NOTF_noOneSelected";
};

if ((lbCurSel 109) isEqualTo -1) exitWith {
    hint localize "STR_NOTF_didNotSelectItemToGive";
};


private _unit = lbData [111, lbCurSel 111];
_unit = call compile format ["%1",_unit];

if (isNil "_unit") exitWith {
    hint localize "STR_NOTF_notWithinRange";
};
if (isNull _unit || {_unit isEqualTo player}) exitWith {};

private _item = lbData [109, lbCurSel 109];

if !([_value] call MPServer_fnc_isNumber) exitWith {
    hint localize "STR_NOTF_notNumberFormat";
};
if (parseNumber _value <= 0) exitWith {
    hint localize "STR_NOTF_enterAmountGive";
};
if !([false,_item, parseNumber _value] call MPClient_fnc_handleInv) exitWith {
    hint localize "STR_NOTF_couldNotGive";
};

[_unit, _value, _item, player] remoteExecCall ["MPClient_fnc_receiveItem", _unit];
private _type = M_CONFIG(getText,"cfgVirtualItems",_item,"displayName");
hint format [localize "STR_NOTF_youGaveItem", _unit getVariable ["realname", name _unit], _value, TEXT_LOCALIZE(_type)];

[] call MPClient_fnc_updateInventoryMenu;


ctrlShow[112,true];
