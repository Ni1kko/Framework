#include "..\..\clientDefines.hpp"
#define INUSE(ENTITY) ENTITY setVariable ["inUse",false,true]
/*
    File: fn_pickupItem.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Master handling for picking up an item.
*/

params [
    ["_itemObject", objNull, [objNull]]
];

if ((time - life_var_actionDelay) < 2) exitWith {hint localize "STR_NOTF_ActionDelay"; INUSE(_itemObject)};
if (isNull _itemObject || {player distance _itemObject > 3}) exitWith {INUSE(_itemObject)};

private _fnc_deleteItem = {
    params [
        ["_object", objNull, [objNull]]
    ];

    if (isNull _object) exitWith {};

    private _allvitems = virtualNamespace getVariable ["allvitems",[]];
    private _vitemIndex = _allvitems find (netID _object);

    //-- Remove the item from the virtual items array
    if(_vitemIndex isNotEqualTo -1) then { 
        _allvitems deleteAt _vitemIndex; 
        virtualNamespace setvariable ["allvitems",_allvitems,true];
    };

    //-- Delete the vitrual data
    _object setVariable ["item",nil];
    
    //-- Delete the object
    deleteVehicle _object;
     
    //-- Return called
    if not(canSuspend)exitWith{ 
        isNull _object
    };

    waitUntil{isNull _itemObject};
    
    //-- Return spawned
    true
};

private _itemInfo = _itemObject getVariable ["item",[]]; if (count _itemInfo isEqualTo 0) exitWith {[_itemObject] call _fnc_deleteItem};
private _illegal = ITEM_ILLEGAL(_itemInfo select 0);
private _itemName = ITEM_DISPLAYNAME(_itemInfo select 0);

if (isLocalized _itemName) then {
    _itemName = (localize _itemName);
};

if (playerSide isEqualTo west && _illegal isEqualTo 1) exitWith {
    titleText[format [localize "STR_NOTF_PickedEvidence",_itemName,[round(ITEM_SELLPRICE(_itemInfo select 0) / 2)] call MPClient_fnc_numberText],"PLAIN"];
    ["ADD","BANK",round(ITEM_SELLPRICE(_itemInfo select 0) / 2)] call MPClient_fnc_handleMoney;
    [_itemObject] call _fnc_deleteItem;
    life_var_actionDelay = time;
};

life_var_actionDelay = time;
_diff = [(_itemInfo select 0),(_itemInfo select 1),life_var_carryWeight,life_maxWeight] call MPClient_fnc_calWeightDiff;
if (_diff <= 0) exitWith {hint localize "STR_NOTF_InvFull"; INUSE(_itemObject);};

if (!(_diff isEqualTo (_itemInfo select 1))) then {
    if (["ADD",(_itemInfo select 0),_diff] call MPClient_fnc_handleVitrualItem) then {
        player playMove "AinvPknlMstpSlayWrflDnon";

        _itemObject setVariable ["item",[(_itemInfo select 0),(_itemInfo select 1) - _diff],true];
        titleText[format [localize "STR_NOTF_Picked",_diff,_itemName],"PLAIN"];
        INUSE(_itemObject);
    } else {
        INUSE(_itemObject);
    };
} else {
    if (["ADD",(_itemInfo select 0),(_itemInfo select 1)] call MPClient_fnc_handleVitrualItem) then {
        [_itemObject] call _fnc_deleteItem;
        player playMove "AinvPknlMstpSlayWrflDnon";

        titleText[format [localize "STR_NOTF_Picked",_diff,_itemName],"PLAIN"];
    } else {
        INUSE(_itemObject);
    };
};

if (CFG_MASTER(getNumber,"player_advancedLog") isEqualTo 1) then {
    if (CFG_MASTER(getNumber,"battlEye_friendlyLogging") isEqualTo 1) then {
        advanced_log = format [localize "STR_DL_AL_pickedUp_BEF",_diff,_itemName];
    } else {
        advanced_log = format [localize "STR_DL_AL_pickedUp",profileName,(getPlayerUID player),_diff,_itemName];
    };
    publicVariableServer "advanced_log";
};
