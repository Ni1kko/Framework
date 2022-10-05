#include "..\..\script_macros.hpp"
/*
    File: fn_buyHouseGarage.sqf
    Author: BoGuu
    Description:
    Buy functionality for house garages.
*/

private _house = param [0,objNull,[objNull]];
private _uid = getPlayerUID player;

if (isNull _house) exitWith {};
if (_house getVariable ["garageBought",false]) exitWith {hint localize "STR_Garage_alreadyOwned";};
if ((_house getVariable "house_owner") select 0 != getPlayerUID player) exitWith {hint localize "STR_Garage_NotOwner";};
if (_house getVariable ["blacklistedGarage",false]) exitWith {};
closeDialog 0;

private _price = CFG_MASTER(getNumber,"houseGarage_buyPrice");

_action = [
    format [localize "STR_Garage_HouseBuyMSG",
    [_price] call MPClient_fnc_numberText],
    localize "STR_House_GaragePurchase",
    localize "STR_Global_Buy",
    localize "STR_Global_Cancel"
] call BIS_fnc_guiMessage;

if (_action) then {

    if (MONEY_BANK < _price) exitWith {hint format [localize "STR_House_NotEnough"]};
    
    ["SUB","BANK",_price] call MPClient_fnc_handleMoney;

    if (count extdb_var_database_headless_clients > 0) then {
        [_uid,_house,0] remoteExec ["HC_fnc_houseGarage",extdb_var_database_headless_client];
    } else {
        [_uid,_house,0] remoteExec ["MPServer_fnc_houseGarage",RE_SERVER];
    };

    _house setVariable ["garageBought",true,true];

};