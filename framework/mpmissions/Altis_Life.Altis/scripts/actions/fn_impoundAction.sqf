#include "..\..\clientDefines.hpp"
/*
    File: fn_impoundAction.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Impounds the vehicle
*/
private ["_vehicle","_type","_time","_value","_vehicleData","_upp","_ui","_progress","_pgText","_cP","_filters","_impoundValue","_price","_impoundMultiplier"];
_vehicle = param [0,objNull,[objNull]];
_filters = ["Car","Air","Ship"];
if (!((KIND_OF_ARRAY(_vehicle,_filters)))) exitWith {};
if (player distance cursorObject > 10) exitWith {};
if (_vehicle getVariable "NPC") exitWith {hint localize "STR_NPC_Protected"};

_vehicleData = _vehicle getVariable ["vehicle_info_owners",[]];
if (_vehicleData isEqualTo 0) exitWith {deleteVehicle _vehicle}; //Bad vehicle.
_vehicleName = FETCH_CONFIG2(getText,"CfgVehicles",(typeOf _vehicle),"displayName");
_price = M_CONFIG(getNumber,"cfgVehicleArsenal",(typeOf _vehicle),"price");
[0,"STR_NOTF_BeingImpounded",true,[((_vehicleData select 0) select 1),_vehicleName]] remoteExecCall ["MPClient_fnc_broadcast",RE_CLIENT];
life_var_isBusy = true;

_upp = localize "STR_NOTF_Impounding";
//Setup our progress bar.
disableSerialization;
"progressBar" cutRsc ["RscTitleProgressBar","PLAIN"];
_ui = uiNamespace getVariable "RscTitleProgressBar";
_progress = _ui displayCtrl 38201;
_pgText = _ui displayCtrl 38202;
_pgText ctrlSetText format ["%2 (1%1)...","%",_upp];
_progress progressSetPosition 0.01;
_cP = 0.01;

for "_i" from 0 to 1 step 0 do {
    sleep 0.09;
    _cP = _cP + 0.01;
    _progress progressSetPosition _cP;
    _pgText ctrlSetText format ["%3 (%1%2)...",round(_cP * 100),"%",_upp];
    if (_cP >= 1) exitWith {};
    if (player distance _vehicle > 10) exitWith {};
    if (!alive player) exitWith {};
};

"progressBar" cutText ["","PLAIN"];

if (player distance _vehicle > 10) exitWith {hint localize "STR_NOTF_ImpoundingCancelled"; life_var_isBusy = false;};
if (!alive player) exitWith {life_var_isBusy = false;};

if (count crew _vehicle isEqualTo 0) then {
    if (!(KIND_OF_ARRAY(_vehicle,_filters))) exitWith {life_var_isBusy = false;};
    _type = FETCH_CONFIG2(getText,"CfgVehicles",(typeOf _vehicle),"displayName");

    life_var_sessionGarageImpoundRequest = true;

    if (count extdb_var_database_headless_clients > 0) then {
        [_vehicle,true,player] remoteExec ["HC_fnc_vehicleStore",extdb_var_database_headless_client];
    } else {
        [_vehicle,true,player] remoteExec ["MPServer_fnc_vehicleStore",RE_SERVER];
    };

    waitUntil {!life_var_sessionGarageImpoundRequest};
    if (playerSide isEqualTo west) then {
        _impoundMultiplier = CFG_MASTER(getNumber,"vehicle_cop_impound_multiplier");
        _value = _price * _impoundMultiplier;
        [0,"STR_NOTF_HasImpounded",true,[profileName,((_vehicleData select 0) select 1),_vehicleName]] remoteExecCall ["MPClient_fnc_broadcast",RE_CLIENT];
        if (_vehicle in life_var_vehicles) then {
            hint format [localize "STR_NOTF_OwnImpounded",[_value] call MPClient_fnc_numberText,_type];
            ["SUB","BANK",_value] call MPClient_fnc_handleMoney;
        } else {
            hint format [localize "STR_NOTF_Impounded",_type,[_value] call MPClient_fnc_numberText];
            ["ADD","BANK",_value] call MPClient_fnc_handleMoney;
        }; 
    };
} else {
    hint localize "STR_NOTF_ImpoundingCancelled";
};

life_var_isBusy = false;
