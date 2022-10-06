#include "..\..\clientDefines.hpp"
/*
    File: fn_pickupMoney.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Picks up money
*/
private "_value";
if ((time - life_var_actionDelay) < 1.5) exitWith {hint localize "STR_NOTF_ActionDelay"; _this setVariable ["inUse",false,true];};
if (isNull _this || {player distance _this > 3}) exitWith {_this setVariable ["inUse",false,true];};

_value = ((_this getVariable "item") select 1);
if (!isNil "_value") exitWith {
    deleteVehicle _this;

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