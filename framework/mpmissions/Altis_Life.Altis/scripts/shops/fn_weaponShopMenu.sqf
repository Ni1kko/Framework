#include "..\..\script_macros.hpp"
/*
    File: fn_weaponShopMenu.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Something
*/

private _shopTitle = M_CONFIG(getText,"WeaponShops",(_this select 3),"name");
private _shopSide = M_CONFIG(getText,"WeaponShops",(_this select 3),"side");
private _conditions = M_CONFIG(getText,"WeaponShops",(_this select 3),"conditions");
private _playerSide = [playerSide,true] call MPServer_fnc_util_getSideString;
 
if (not(MPClient_adminShop) AND count _shopSide > 0 AND  {_playerSide isNotEqualTo _shopSide}) exitWith {false};
if (not(MPClient_adminShop) AND count _conditions > 0 AND {not([_conditions] call MPClient_fnc_levelCheck)}) exitWith {hint localize "STR_Shop_Veh_NotAllowed";false};

uiNamespace setVariable ["Weapon_Shop",(_this select 3)];
uiNamespace setVariable ["Weapon_Magazine",0];
uiNamespace setVariable ["Weapon_Accessories",0];
uiNamespace setVariable ["Magazine_Array",[]];
uiNamespace setVariable ["Accessories_Array",[]];

if (!isClass(missionConfigFile >> "WeaponShops" >> (_this select 3))) exitWith {false}; //Bad config entry.

private _display = createDialog ["life_weapon_shop",true];
disableSerialization;

[
    (_display displayCtrl 38401),
    (_display displayCtrl 38402)
]params [
    "_control_title",
    "_control_filters"
];

//--- Set Title
_control_title ctrlSetText _shopTitle;
 
//--- Clear listbox
lbClear _control_filters;

//--- Disable buttons
{
    private _control = (_display displayCtrl _x);
    _control ctrlShow true;
    _control ctrlEnable false;
}forEach [
    38406,
    38407
];

//--- Add filters 
{
    private _name = (if(isLocalized _x)then{localize _x}else{_x});
    _control_filters lbAdd _name;
    if(_forEachIndex == 0)then{
        _control_filters lbSetCurSel 0;
    };
}forEach [
    "STR_Shop_Weapon_ShopInv",
    "STR_Shop_Weapon_YourInv"
];

MPClient_adminShop = false;

true