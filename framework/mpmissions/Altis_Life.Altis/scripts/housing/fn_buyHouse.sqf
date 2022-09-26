#include "..\..\script_macros.hpp"
/*
    File: fn_buyHouse.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Buys the house?
*/
private ["_house","_uid","_action","_houseCfg"];
private _house = param [0,objNull,[objNull]];
private _uid = getPlayerUID player;

if (isNull _house) exitWith {};
if (!(_house isKindOf "House_F")) exitWith {};
if (_house getVariable ["house_owned",false]) exitWith {hint localize "STR_House_alreadyOwned";};
if (!isNil {(_house getVariable "house_sold")}) exitWith {hint localize "STR_House_Sell_Process"};
if (!license_civ_home) exitWith {hint localize "STR_House_License"};
if (count life_houses >= (LIFE_SETTINGS(getNumber,"house_limit"))) exitWith {hint format [localize "STR_House_Max_House",LIFE_SETTINGS(getNumber,"house_limit")]};
closeDialog 0;
 
private _houseCfg = [(typeOf _house)] call MPClient_fnc_houseConfig;
if (count _houseCfg isEqualTo 0) exitWith {};
private _cost = _houseCfg#0;

_action = [
    format [localize "STR_House_BuyMSG",
    [_cost] call MPClient_fnc_numberText,
    (_houseCfg select 1)],localize "STR_House_Purchase",localize "STR_Global_Buy",localize "STR_Global_Cancel"
] call BIS_fnc_guiMessage;

if (_action) then {
    if (MONEY_BANK < _cost) exitWith {hint format [localize "STR_House_NotEnough"]};

    ["SUB","BANK",_cost] call MPClient_fnc_handleMoney;

    if (count extdb_var_database_headless_clients > 0) then {
        [_uid,_house] remoteExec ["HC_fnc_addHouse",extdb_var_database_headless_client];
    } else {
        [_uid,_house] remoteExec ["MPServer_fnc_addHouse",RE_SERVER];
    };

    if (LIFE_SETTINGS(getNumber,"player_advancedLog") isEqualTo 1) then {
        if (LIFE_SETTINGS(getNumber,"battlEye_friendlyLogging") isEqualTo 1) then {
            advanced_log = format [localize "STR_DL_AL_boughtHouse_BEF",[_cost] call MPClient_fnc_numberText, MONEY_BANK_FORMATTED, MONEY_CASH_FORMATTED];
        } else {
            advanced_log = format [localize "STR_DL_AL_boughtHouse",profileName,(getPlayerUID player),[_cost] call MPClient_fnc_numberText, MONEY_BANK_FORMATTED, MONEY_CASH_FORMATTED];
        };
        publicVariableServer "advanced_log";
    };

    _house setVariable ["house_owner",[_uid,profileName],true];
    _house setVariable ["locked",true,true];
    _house setVariable ["containers",[],true];
    _house setVariable ["uid",floor(random 99999),true];

    life_vehicles pushBack _house;
    life_houses pushBack [str(getPosATL _house),[]];
    _marker = createMarkerLocal [format ["house_%1",(_house getVariable "uid")],getPosATL _house];
    _houseName = FETCH_CONFIG2(getText,"CfgVehicles",(typeOf _house), "displayName");
    _marker setMarkerTextLocal _houseName;
    _marker setMarkerColorLocal "ColorBlue";
    _marker setMarkerTypeLocal "loc_Lighthouse";
    _numOfDoors = FETCH_CONFIG2(getNumber,"CfgVehicles",(typeOf _house),"numberOfDoors");
    for "_i" from 1 to _numOfDoors do {
        _house setVariable [format ["bis_disabled_Door_%1",_i],1,true];
    };
};
