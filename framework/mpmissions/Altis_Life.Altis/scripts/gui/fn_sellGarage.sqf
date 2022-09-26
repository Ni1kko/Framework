#include "..\..\script_macros.hpp"
/*
    File: fn_sellGarage.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Sells a vehicle from the garage.
*/
private ["_vehicle","_vehicleLife","_vid","_pid","_sellPrice","_multiplier","_price","_purchasePrice"];
disableSerialization;
if ((lbCurSel 2802) isEqualTo -1) exitWith {hint localize "STR_Global_NoSelection"};
_vehicle = lbData[2802,(lbCurSel 2802)];
_vehicle = (call compile format ["%1",_vehicle]) select 0;
_vehicleLife = _vehicle;
_vid = lbValue[2802,(lbCurSel 2802)];
_pid = getPlayerUID player;

if (isNil "_vehicle") exitWith {hint localize "STR_Garage_Selection_Error"};
if ((time - life_action_delay) < 1.5) exitWith {hint localize "STR_NOTF_ActionDelay";};
if (!isClass (missionConfigFile >> "cfgVehicleArsenal" >> _vehicleLife)) then {
    _vehicleLife = "Default"; //Use Default class if it doesn't exist
    [format ["%1: cfgVehicleArsenal class doesn't exist",_vehicle],true,true] call MPClient_fnc_log;
};

_price = M_CONFIG(getNumber,"cfgVehicleArsenal",_vehicleLife,"price");
switch (playerSide) do {
    case civilian: {
        _multiplier = LIFE_SETTINGS(getNumber,"vehicle_sell_multiplier_CIVILIAN");
        _purchasePrice = _price * LIFE_SETTINGS(getNumber,"vehicle_purchase_multiplier_CIVILIAN");
    };
    case west: {
        _multiplier = LIFE_SETTINGS(getNumber,"vehicle_sell_multiplier_COP");
        _purchasePrice = _price * LIFE_SETTINGS(getNumber,"vehicle_purchase_multiplier_COP");
    };
    case independent: {
        _multiplier = LIFE_SETTINGS(getNumber,"vehicle_sell_multiplier_MEDIC");
        _purchasePrice = _price * LIFE_SETTINGS(getNumber,"vehicle_purchase_multiplier_MEDIC");
    };
    case east: {
        _multiplier = LIFE_SETTINGS(getNumber,"vehicle_sell_multiplier_OPFOR");
        _purchasePrice = _price * LIFE_SETTINGS(getNumber,"vehicle_purchase_multiplier_OPFOR");
    };
};

_sellPrice = _purchasePrice * _multiplier;

if (!(_sellPrice isEqualType 0) || _sellPrice < 1) then {_sellPrice = 500;};

if (count extdb_var_database_headless_clients > 0) then {
    [_vid,_pid,_sellPrice,player,life_garage_type] remoteExecCall ["HC_fnc_vehicleDelete",extdb_var_database_headless_client];
} else {
    [_vid,_pid,_sellPrice,player,life_garage_type] remoteExecCall ["MPServer_fnc_vehicleDelete",RE_SERVER];
};

hint format [localize "STR_Garage_SoldCar",[_sellPrice] call MPClient_fnc_numberText];
["ADD","BANK",_sellPrice] call MPClient_fnc_handleMoney;

if (LIFE_SETTINGS(getNumber,"player_advancedLog") isEqualTo 1) then {
    if (LIFE_SETTINGS(getNumber,"battlEye_friendlyLogging") isEqualTo 1) then {
        advanced_log = format [localize "STR_DL_AL_soldVehicle_BEF",_vehicleLife,[_sellPrice] call MPClient_fnc_numberText,[MONEY_BANK] call MPClient_fnc_numberText,[MONEY_CASH] call MPClient_fnc_numberText];
    } else {
        advanced_log = format [localize "STR_DL_AL_soldVehicle",profileName,(getPlayerUID player),_vehicleLife,[_sellPrice] call MPClient_fnc_numberText,[MONEY_BANK] call MPClient_fnc_numberText,[MONEY_CASH] call MPClient_fnc_numberText];
    };
    publicVariableServer "advanced_log";
};

life_action_delay = time;
closeDialog 0;