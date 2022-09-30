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

if !(createDialog "life_weapon_shop") exitWith {};
if (!isClass(missionConfigFile >> "WeaponShops" >> (_this select 3))) exitWith {}; //Bad config entry.

disableSerialization;

ctrlSetText[38401,_shopTitle];

private _filters = ((findDisplay 38400) displayCtrl 38402);
lbClear _filters;

ctrlShow [38406,true];
ctrlEnable [38406,false];
ctrlShow [38407,true];
ctrlEnable [38407,false];

_filters lbAdd localize "STR_Shop_Weapon_ShopInv";
_filters lbAdd localize "STR_Shop_Weapon_YourInv";

_filters lbSetCurSel 0;

MPClient_adminShop = false;

true