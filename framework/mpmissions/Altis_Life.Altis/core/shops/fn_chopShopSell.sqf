#include "..\..\script_macros.hpp"
/*
    File: fn_chopShopSell.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Sells the selected vehicle off.
*/
disableSerialization;

private _control = CONTROL(39400,39402);
private _price = _control lbValue (lbCurSel _control);
private _vehicle = objectFromNetId (_control lbData (lbCurSel _control));
if (isNull _vehicle) exitWith {};

systemChat localize "STR_Shop_ChopShopSelling";
life_var_isBusy = true;

if (count extdb_var_database_headless_clients > 0) then {
    [player,_vehicle,_price] remoteExecCall ["HC_fnc_chopShopSell",extdb_var_database_headless_client];
} else {
    [player,_vehicle,_price] remoteExecCall ["TON_fnc_chopShopSell",RSERV];
};

if (LIFE_SETTINGS(getNumber,"player_advancedLog") isEqualTo 1) then {
    if (LIFE_SETTINGS(getNumber,"battlEye_friendlyLogging") isEqualTo 1) then {
        advanced_log = format [localize "STR_DL_AL_choppedVehicle_BEF",_vehicle,[_price] call life_fnc_numberText,[life_var_cash] call life_fnc_numberText];
    } else {
        advanced_log = format [localize "STR_DL_AL_choppedVehicle",profileName,(getPlayerUID player),_vehicle,[_price] call life_fnc_numberText,[life_var_cash] call life_fnc_numberText];
    };
    publicVariableServer "advanced_log";
};

closeDialog 0;