#include "..\..\..\clientDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
    ## fn_chopShopMenu.sqf
*/

if (life_var_isBusy) exitWith {hint localize "STR_NOTF_ActionInProc"};
if !(playerSide isEqualTo civilian) exitWith {hint localize "STR_NOTF_notAllowed"};

disableSerialization;

private _chopable = CFG_MASTER(getArray,"chopShop_vehicles");
private _nearVehicles = nearestObjects [getMarkerPos (_this select 3),_chopable,25];
private _nearUnits = (nearestObjects[player,["CAManBase"],5]) arrayIntersect playableUnits;
if (count _nearUnits > 1) exitWith {hint localize "STR_NOTF_PlayerNear"};

life_chopShop = _this select 3;
//Error check
if (_nearVehicles isEqualTo []) exitWith {titleText[localize "STR_Shop_NoVehNear","PLAIN"];};
if (!(createDialog "RscDisplayChopShop")) exitWith {hint localize "STR_Shop_ChopShopError"};

private _control = CONTROL(39400,39402);
private "_className";
private "_displayName";
private "_picture";
private "_price";
private "_chopMultiplier";
{
    if (alive _x) then {
        _className = typeOf _x;
        _displayName = getText(configFile >> "CfgVehicles" >> _className >> "displayName");
        _picture = getText(configFile >> "CfgVehicles" >> _className >> "picture");

        if (!isClass (missionConfigFile >> "cfgVehicleArsenal" >> _className)) then {
            [format ["%1: cfgVehicleArsenal class doesn't exist",_className],true,true] call MPClient_fnc_log;
            _className = "Default"; //Use Default class if it doesn't exist
        };

        _price = M_CONFIG(getNumber,"cfgVehicleArsenal",_className,"price");
        _chopMultiplier = CFG_MASTER(getNumber,"vehicle_chopShop_multiplier");

        _price = _price * _chopMultiplier;
        if (!isNil "_price" && count crew _x isEqualTo 0) then {
            _control lbAdd _displayName;
            _control lbSetData [(lbSize _control)-1,(netId _x)];
            _control lbSetPicture [(lbSize _control)-1,_picture];
            _control lbSetValue [(lbSize _control)-1,_price];
        };
    };
} forEach _nearVehicles;
