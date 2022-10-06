#include "..\..\..\clientDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
    ## fn_weaponShopMenu.sqf
*/

private _shop = param [3,""];
private _shopTitle = M_CONFIG(getText,"cfgWeaponShops",_shop,"name");
private _shopSide = M_CONFIG(getText,"cfgWeaponShops",_shop,"side");
private _conditions = M_CONFIG(getText,"cfgWeaponShops",_shop,"conditions");
private _playerSide = [playerSide,true] call MPServer_fnc_util_getSideString;
 
if (not(life_var_adminShop) AND count _shopSide > 0 AND  {_playerSide isNotEqualTo _shopSide}) exitWith {false};
if (not(life_var_adminShop) AND count _conditions > 0 AND {not([_conditions] call MPClient_fnc_checkConditions)}) exitWith {hint localize "STR_Shop_Veh_NotAllowed";false};

if (!isClass(missionConfigFile >> "cfgWeaponShops" >> _shop)) exitWith {false}; //Bad config entry.
if (!isClass(missionConfigFile >> "RscDisplayWeaponShop")) exitWith {false}; //Missing class `RscDisplayWeaponShop`

private _display = createDialog ["RscDisplayWeaponShop",true];
disableSerialization;

//--- 
{uiNamespace setVariable _x}forEach [
    ["Accessories_Array",[]],
    ["Magazine_Array",[]],
    ["Weapon_Accessories",0],
    ["Weapon_Magazine",0],
    ["Weapon_Shop",_shop]
];

//--- Get controls
[
    (_display displayCtrl 38401),
    (_display displayCtrl 38402),
    (_display displayCtrl 38405),
    (_display displayCtrl 38406),
    (_display displayCtrl 38407)
]params [
    "_control_title",
    "_control_filters",
    "_control_confirm",
    "_control_mags",
    "_control_accs"
];

//--- Set Title
_control_title ctrlSetText _shopTitle;
 
//--- Clear combo
lbClear _control_filters;

//--- Disable buttons
{
    _x ctrlShow true;
    _x ctrlEnable false;
}forEach [
    _control_mags,
    _control_accs
];

//--- Add combo filters 
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

life_var_adminShop = false;

true