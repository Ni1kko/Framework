#include "..\..\..\script_macros.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
    ## fn_vehicleShopMenu.sqf
*/

(_this select 3) params [
    ["_shop","",[""]],
    ["_sideCheck",sideUnknown,[civilian]],
    ["_spawnPoints","",["",[]]],
    ["_shopFlag","",[""]],
    ["_shopTitle","",[""]],
    ["_disableBuy",false,[true]]
];

disableSerialization;

//Long boring series of checks
if (dialog) exitWith {};
if (count _shop isEqualTo 0) exitWith {false};
if (not(life_var_adminShop) AND _sideCheck isNotEqualTo sideUnknown AND {playerSide isNotEqualTo _sideCheck}) exitWith {hint localize "STR_Shop_Veh_NotAllowed"};

private _conditions = M_CONFIG(getText,"cfgVehicleTraders",_shop,"conditions");
if (not(life_var_adminShop) AND !([_conditions] call MPClient_fnc_checkConditions)) exitWith {hint localize "STR_Shop_Veh_NotAllowed"};

if (LIFE_SETTINGS(getNumber,"vehicleShop_3D") isEqualTo 1) then {
  createDialog "RscDisplayVehicleShop3D";
} else {
  createDialog "RscDisplayVehicleShop";
};

if(life_var_adminShop) then {
    _shopTitle = format["Admin %1 Shop",_shop];
    _shopFlag = M_CONFIG(getText,"WeaponShops",_shop,"side");
    
    if(count (missionNamespace getVariable ["life_var_adminShopSpawnMarker",""]) > 0) then {
       deleteMarkerLocal life_var_adminShopSpawnMarker;
    };

    life_var_adminShopSpawnMarker = createMarkerLocal ["adminVehShopSpawnMarker", position player];

    _spawnpoints = [life_var_adminShopSpawnMarker];
};

life_var_vehicleTraderData = [_shop,_spawnpoints,_shopFlag,_disableBuy]; //Store it so so other parts of the system can access it.

ctrlSetText [2301,_shopTitle];

if (_disableBuy) then {
    //Disable the buy button.
    ctrlEnable [2309,false];
};

//Fetch the shop config.
_vehicleList = M_CONFIG(getArray,"cfgVehicleTraders",_shop,"vehicles");

private _control = CONTROL(2300,2302);
lbClear _control; //Flush the list.
ctrlShow [2330,false];
ctrlShow [2304,false];

//Loop through
{
    _x params["_className"];

    private _toShow = [_x] call MPClient_fnc_checkConditions;

    if (_toShow) then {
        _vehicleInfo = [_className] call MPClient_fnc_fetchVehInfo;
        _control lbAdd (_vehicleInfo select 3);
        _control lbSetPicture [(lbSize _control)-1,(_vehicleInfo select 2)];
        _control lbSetData [(lbSize _control)-1,_className];
        _control lbSetValue [(lbSize _control)-1,_forEachIndex];
    };
} forEach _vehicleList;

((findDisplay 2300) displayCtrl 2302) lbSetCurSel 0;
