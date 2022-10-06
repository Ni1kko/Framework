#include "..\..\clientDefines.hpp"
/*
    File: fn_removeItem.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Removes the selected item & amount to remove from the players
    virtual inventory.
*/
private ["_data","_value","_obj"];
disableSerialization;
_data = lbData[109,(lbCurSel 109)];
_value = ctrlText 110;

if (_data isEqualTo "") exitWith {hint localize "STR_NOTF_didNotSelectToRemove";};
if (!([_value] call MPServer_fnc_isNumber)) exitWith {hint localize "STR_NOTF_notNumberFormat";};
if (parseNumber(_value) <= 0) exitWith {hint localize "STR_NOTF_enterAmountRemove";};
if (ITEM_ILLEGAL(_data) isEqualTo 1 && ([west,visiblePosition player,100] call MPClient_fnc_nearUnits)) exitWith {titleText[localize "STR_NOTF_illegalItemCannotDispose","PLAIN"]};
if !(isNull objectParent player) exitWith {titleText[localize "STR_NOTF_cannotRemoveInVeh","PLAIN"]};
if (!([false,_data,(parseNumber _value)] call MPClient_fnc_handleInv)) exitWith {hint localize "STR_NOTF_couldNotRemoveThatMuch";};

hint format [localize "STR_NOTF_removedFromInventory",(parseNumber _value),(localize ITEM_NAME(_data))];

[] call MPClient_fnc_updateInventoryMenu;
