#include "..\..\..\script_macros.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
    ## fn_chopShopSell.sqf
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
    [player,_vehicle,_price] remoteExecCall ["MPServer_fnc_chopShopSell",RE_SERVER];
};

if (CFG_MASTER(getNumber,"player_advancedLog") isEqualTo 1) then {
    if (CFG_MASTER(getNumber,"battlEye_friendlyLogging") isEqualTo 1) then {
        advanced_log = format [localize "STR_DL_AL_choppedVehicle_BEF",_vehicle,[_price] call MPClient_fnc_numberText,[MONEY_CASH] call MPClient_fnc_numberText];
    } else {
        advanced_log = format [localize "STR_DL_AL_choppedVehicle",profileName,(getPlayerUID player),_vehicle,[_price] call MPClient_fnc_numberText,[MONEY_CASH] call MPClient_fnc_numberText];
    };
    publicVariableServer "advanced_log";
};

closeDialog 0;