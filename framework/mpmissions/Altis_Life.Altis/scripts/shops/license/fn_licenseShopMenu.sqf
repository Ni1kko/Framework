#include "..\..\..\script_macros.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
    ## fn_licenseShopMenu.sqf
*/

private _shopNPC = param[0, objNull, [objNull]];
private _shopClass = param[3, "", [""]];

if (count _shopClass > 0 AND !isClass(missionConfigFile >> "cfgLicenseShops" >> _shopClass)) exitWith {
	hint localize "STR_NOTF_ConfigDoesNotExist";
	false
};

private _shopSideVar = M_CONFIG(getText,"cfgLicenseShops",_shopClass,"side");
private _playerSideVar = [playerSide,true] call MPServer_fnc_util_getSideString;

if (count _shopClass > 0 AND {count _shopSideVar > 0 AND {_shopSideVar isNotEqualTo _playerSideVar}}) exitWith {
	hint "Error: Shop not available for your faction";
	false
};

private _displayName = "RscDisplayLicenseShop";
private _display = createDialog [_displayName,true];

uiNamespace setVariable ["RscDisplayLicenseShop_Classname", _shopClass];

[_display, _shopClass] call MPClient_fnc_licenseShopMenuUpdate;

true