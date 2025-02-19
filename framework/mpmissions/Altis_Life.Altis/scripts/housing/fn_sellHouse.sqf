#include "..\..\clientDefines.hpp"
/*
    File: fn_sellHouse.sqf
    Author: Bryan "Tonic" Boardwine
    Modified : NiiRoZz

    Description:
    Sells the house and delete all container near house.
*/
private ["_house","_uid","_action","_houseCfg"];

if (dialog) then {closeDialog 0};

_house = param [0,objNull,[objNull]];
_uid = getPlayerUID player;

if (isNull _house) exitWith {};
if (!(_house isKindOf "House_F")) exitWith {};
if (isNil {_house getVariable "house_owner"}) exitWith {hint localize "STR_House_noOwner";};
closeDialog 0;

_houseCfg = [(typeOf _house)] call MPClient_fnc_houseConfig;
if (count _houseCfg isEqualTo 0) exitWith {};

_action = [
    format [localize "STR_House_SellHouseMSG",
    (round((_houseCfg select 0)/2)) call MPClient_fnc_numberText,
    (_houseCfg select 1)],localize "STR_pInAct_SellHouse",localize "STR_Global_Sell",localize "STR_Global_Cancel"
] call BIS_fnc_guiMessage;

if (_action) then {
    _house setVariable ["house_sold",true,true];

    if (count extdb_var_database_headless_clients > 0) then {
        [_house] remoteExecCall ["HC_fnc_sellHouse",extdb_var_database_headless_client];
    } else {
        [_house] remoteExecCall ["MPServer_fnc_sellHouse",RE_SERVER];
    };

    _house setVariable ["locked",false,true];
    deleteMarkerLocal format ["house_%1",_house getVariable "uid"];
    _house setVariable ["uid",nil,true];

    ["ADD","BANK",round((_houseCfg select 0)/2)] call MPClient_fnc_handleMoney;

    _index = life_var_vehicles find _house;

    if (CFG_MASTER(getNumber,"player_advancedLog") isEqualTo 1) then {
        if (CFG_MASTER(getNumber,"battlEye_friendlyLogging") isEqualTo 1) then {
            advanced_log = format [localize "STR_DL_AL_soldHouse_BEF",(round((_houseCfg select 0)/2)),[MONEY_BANK] call MPClient_fnc_numberText];
        } else {
            advanced_log = format [localize "STR_DL_AL_soldHouse",profileName,(getPlayerUID player),(round((_houseCfg select 0)/2)),[MONEY_BANK] call MPClient_fnc_numberText];
            };
        publicVariableServer "advanced_log";
    };

    if !(_index isEqualTo -1) then {
        life_var_vehicles deleteAt _index;
    };

    _index = [str(getPosATL _house),life_houses] call MPServer_fnc_index;
    if !(_index isEqualTo -1) then {
        life_houses deleteAt _index;
    };
    _numOfDoors = FETCH_CONFIG2(getNumber,"CfgVehicles",(typeOf _house), "numberOfDoors");
    for "_i" from 1 to _numOfDoors do {
        _house setVariable [format ["bis_disabled_Door_%1",_i],0,true];
    };
    _containers = _house getVariable ["containers",[]];
    if (count _containers > 0) then {
        {
            _x setVariable ["virtualInventory",nil,true];

            if (count extdb_var_database_headless_clients > 0) then {
                [_x] remoteExecCall ["HC_fnc_sellHouseContainer",extdb_var_database_headless_client];
            } else {
                [_x] remoteExecCall ["MPServer_fnc_sellHouseContainer",RE_SERVER];
            };

        } forEach _containers;
    };
    _house setVariable ["containers",nil,true];
};
