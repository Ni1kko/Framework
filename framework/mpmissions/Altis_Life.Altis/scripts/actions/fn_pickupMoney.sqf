#include "..\..\clientDefines.hpp"
/*
    File: fn_pickupMoney.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Picks up money
*/

params [
    ["_itemObject", objNull, [objNull]]
];

if ((time - life_var_actionDelay) < 1.5) exitWith {hint localize "STR_NOTF_ActionDelay"; _itemObject setVariable ["inUse",false,true];};
if (isNull _itemObject || {player distance _itemObject > 3}) exitWith {_itemObject setVariable ["inUse",false,true];};

private _value = ((_itemObject getVariable "item") select 1);

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

if (!isNil "_value") exitWith {
    [_itemObject] call _fnc_deleteItem;

    switch (true) do {
        case (_value > 20000000) : {_value = 100000;}; //VAL>20mil->100k
        case (_value > 5000000) : {_value = 250000;}; //VAL>5mil->250k
        default {};
    };

    player playMove "AinvPknlMstpSlayWrflDnon";
    titleText[format [localize "STR_NOTF_PickedMoney",[_value] call MPClient_fnc_numberText],"PLAIN"];
    ["ADD","CASH",_value] call MPClient_fnc_handleMoney;
    life_var_actionDelay = time;

    if (CFG_MASTER(getNumber,"player_moneyLog") isEqualTo 1) then {
        if (CFG_MASTER(getNumber,"battlEye_friendlyLogging") isEqualTo 1) then {
            money_log = format [localize "STR_DL_ML_pickedUpMoney_BEF",[_value] call MPClient_fnc_numberText,[MONEY_BANK] call MPClient_fnc_numberText,[MONEY_CASH] call MPClient_fnc_numberText];
        } else {
            money_log = format [localize "STR_DL_ML_pickedUpMoney",profileName,(getPlayerUID player),[_value] call MPClient_fnc_numberText,[MONEY_BANK] call MPClient_fnc_numberText,[MONEY_CASH] call MPClient_fnc_numberText];
        };
        publicVariableServer "money_log";
    };
};