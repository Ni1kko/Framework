#include "..\..\..\clientDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
    ## fn_vehicleShopBuy.sqf
*/

params [
    ["_purchased",true,[true]]
];

if (life_var_serverRequest) exitWith {hint "Please wait\nLast request still in progress!";closeDialog 0;};
if ((lbCurSel 2302) isEqualTo -1) exitWith {hint localize "STR_Shop_Veh_DidntPick";closeDialog 0;};
if ((time - life_var_actionDelay) < 0.2) exitWith {hint localize "STR_NOTF_ActionDelay";};
life_var_actionDelay = time;

private _className = lbData[2302,(lbCurSel 2302)];
private _textureIndex = lbValue[2304,(lbCurSel 2304)];
private _purchasePrice = M_CONFIG(getNumber,"cfgVehicleArsenal",_className,"price");
private _conditions = M_CONFIG(getText,"cfgVehicleArsenal",_className,"conditions");
private _playerSideFlag = [playerSide,true] call MPServer_fnc_util_getSideString;
private _buyMultiplier = 0;
private _rentMultiplier = 0;
private _pos = [];
private _useATL = true;
private _spawnAvaliable = false;
private _texturesArray = M_CONFIG(getArray,"cfgVehicleArsenal",_className,"textures");
private _textures = (if (count _texturesArray <= _textureIndex) then {[]}else{(_texturesArray#_textureIndex) param [2,[]]});
private _materials = [];//support for custom materials
private _numberPlate = "";//support for custom plates
private _lockcode = "";//support for custom lockcodes

//-- Check if the player has meets the conditions
if !([_conditions] call MPClient_fnc_checkConditions) exitWith {hint localize "STR_Shop_Veh_NoLicense";};
if (_purchasePrice < 0) exitWith {closeDialog 0;hint "Bad config: price error"};

//-- Get shop info
life_var_vehicleTraderData params [
    ["_shopConfigName","",[""]],
    ["_spawnMarkers",[],["",[]]],
    ["_shopFlag",""],
    ["_disableBuy",false]
];

//--- wrong faction
if (count _shopFlag > 0 AND {_playerSideFlag isNotEqualTo toLower _shopFlag}) exitWith {hint "Error: This vehicle belongs to another faction"; closeDialog 0;};

//--- Handle single spawn point
if(typeName _spawnMarkers isEqualTo "STRING") then {_spawnMarkers = [_spawnMarkers]};

//--- Purchase disabled for this vehicle switch to rental mode
if _disableBuy then {_purchased = false};

//--- Price Multiplier
if((_purchased AND _buyMultiplier > 0) OR (!_purchased AND _rentMultiplier > 0)) then 
{
    switch (playerSide) do 
    {
        case civilian: {
            _buyMultiplier = CFG_MASTER(getNumber,"vehicle_purchase_multiplier_CIVILIAN");
            _rentMultiplier = CFG_MASTER(getNumber,"vehicle_rental_multiplier_CIVILIAN");
        };
        case west: {
            _buyMultiplier = CFG_MASTER(getNumber,"vehicle_purchase_multiplier_COP");
            _rentMultiplier = CFG_MASTER(getNumber,"vehicle_rental_multiplier_COP");
        };
        case independent: {
            _buyMultiplier = CFG_MASTER(getNumber,"vehicle_purchase_multiplier_MEDIC");
            _rentMultiplier = CFG_MASTER(getNumber,"vehicle_rental_multiplier_MEDIC");
        };
        case east: {
            _buyMultiplier = CFG_MASTER(getNumber,"vehicle_purchase_multiplier_OPFOR");
            _rentMultiplier = CFG_MASTER(getNumber,"vehicle_rental_multiplier_OPFOR");
        };
    };   
    _purchasePrice = round(if(_purchased)then{_purchasePrice * _buyMultiplier}else{_purchasePrice * _rentMultiplier});
};

//--- Check if the player has enough money
if (MONEY_CASH < _purchasePrice) exitWith {
    hint format [localize "STR_Shop_Veh_NotEnough",[_purchasePrice - MONEY_CASH] call MPClient_fnc_numberText];
    closeDialog 0;
};

//--- Handle spawn markers
{
    private _types = ["Car","Ship","Air"];
    
    //--- Marker position
    _pos = getMarkerPos _x;

    //--- Handle altered position
    switch (true) do 
    {
        //--- Use ATL instead of ASL for land vehicles
        case (_className isKindOf "Car"): {_useATL = true};
        //--- Use ASL instead of ATL for water vehicles
        case (_className isKindOf "Ship"): {_useATL = false};
        //--- Helipad spawn
        case (_className isKindOf "Air"):
        {
            if (_shopConfigName == "med_air_hs") then { 
                private _hs = nearestObjects[_pos,["Land_Hospital_side2_F"],50] select 0;
                _pos = (_hs modelToWorld [-0.4,-4,12.65]);
                _types = ["Air"];
                _useATL = true;
            }; 
        };
    };

    //--- Find an available spawn point
    if (count(nearestObjects[_pos,_types,5]) isEqualTo 0) exitWith {
        _spawnAvaliable = true
    };
} forEach _spawnMarkers;

//--- no spawn point found or blocked
if !_spawnAvaliable exitWith {hint localize "STR_Shop_Veh_Block"; closeDialog 0;};

//--- block multiple request at one time
life_var_serverRequest = true;

//--- Send request to server
[player,_className,_pos,_useATL,_purchased,_purchasePrice,_textures,_materials,_numberPlate,_lockcode] remoteExec ["MPServer_fnc_vehicle_buyRequest",2];

//--- Reset shop var
life_var_vehicleTraderData = ["",[],"Undefined",true];

//--- Close dialog
closeDialog 0;

true;
