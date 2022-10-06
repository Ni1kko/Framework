#include "..\..\clientDefines.hpp"
/*
    File: fn_garageLBChange.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Can't be bothered to answer it.. Already deleted it by accident..
*/
disableSerialization;
private ["_control","_index","_className","_classNameLife","_dataArr","_vehicleColor","_vehicleInfo","_trunkSpace","_sellPrice","_retrievePrice","_sellMultiplier","_price","_storageFee","_purchasePrice"];
_control = _this select 0;
_index = _this select 1;

//Fetch some information.
_dataArr = CONTROL_DATAI(_control,_index);
_dataArr = call compile format ["%1",_dataArr];
_className = (_dataArr select 0);
_classNameLife = _className;

if (!isClass (missionConfigFile >> "cfgVehicleArsenal" >> _classNameLife)) then {
    _classNameLife = "Default"; //Use Default class if it doesn't exist
    [format ["%1: cfgVehicleArsenal class doesn't exist",_className],true,true] call MPClient_fnc_log;
};

_vehicleColor = ((M_CONFIG(getArray,"cfgVehicleArsenal",_classNameLife,"textures") select (_dataArr select 1)) select 0);
if (isNil "_vehicleColor") then {_vehicleColor = "Default";};

_vehicleInfo = [_className] call MPClient_fnc_fetchVehInfo;
_trunkSpace = [_className] call MPClient_fnc_vehicleWeightCfg;

_price = M_CONFIG(getNumber,"cfgVehicleArsenal",_classNameLife,"price");
_storageFee = CFG_MASTER(getNumber,"vehicle_storage_fee_multiplier");

switch (playerSide) do {
    case civilian: {
        _purchasePrice = _price * CFG_MASTER(getNumber,"vehicle_purchase_multiplier_CIVILIAN");
        _sellMultiplier = CFG_MASTER(getNumber,"vehicle_sell_multiplier_CIVILIAN");
    };
    case west: {
        _purchasePrice = _price * CFG_MASTER(getNumber,"vehicle_purchase_multiplier_COP");
        _sellMultiplier = CFG_MASTER(getNumber,"vehicle_sell_multiplier_COP");
    };
    case independent: {
        _purchasePrice = _price * CFG_MASTER(getNumber,"vehicle_purchase_multiplier_MEDIC");
        _sellMultiplier = CFG_MASTER(getNumber,"vehicle_sell_multiplier_MEDIC");
    };
    case east: {
        _purchasePrice = _price * CFG_MASTER(getNumber,"vehicle_purchase_multiplier_OPFOR");
        _sellMultiplier = CFG_MASTER(getNumber,"vehicle_sell_multiplier_OPFOR");
    };
};
_retrievePrice = _purchasePrice * _storageFee;
_sellPrice = _purchasePrice * _sellMultiplier;

if (!(_sellPrice isEqualType 0) || _sellPrice < 1) then {_sellPrice = 500;};
if (!(_retrievePrice isEqualType 0) || _retrievePrice < 1) then {_retrievePrice = 500;};

(CONTROL(2800,2803)) ctrlSetStructuredText parseText format [
    (localize "STR_Shop_Veh_UI_RetrievalP")+ " <t color='#8cff9b'>$%1</t><br/>
    " +(localize "STR_Shop_Veh_UI_SellP")+ " <t color='#8cff9b'>$%2</t><br/>
    " +(localize "STR_Shop_Veh_UI_Color")+ " %8<br/>
    " +(localize "STR_Shop_Veh_UI_MaxSpeed")+ " %3 km/h<br/>
    " +(localize "STR_Shop_Veh_UI_HPower")+ " %4<br/>
    " +(localize "STR_Shop_Veh_UI_PSeats")+ " %5<br/>
    " +(localize "STR_Shop_Veh_UI_Trunk")+ " %6<br/>
    " +(localize "STR_Shop_Veh_UI_Fuel")+ " %7
    ",
[_retrievePrice] call MPClient_fnc_numberText,
[_sellPrice] call MPClient_fnc_numberText,
(_vehicleInfo select 8),
(_vehicleInfo select 11),
(_vehicleInfo select 10),
if (_trunkSpace isEqualTo -1) then {"None"} else {_trunkSpace},
(_vehicleInfo select 12),
_vehicleColor
];

ctrlShow [2803,true];
ctrlShow [2830,true];
