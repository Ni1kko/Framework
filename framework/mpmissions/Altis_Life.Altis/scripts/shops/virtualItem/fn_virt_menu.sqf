#include "..\..\..\script_macros.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
    ## fn_virt_menu.sqf
*/

private _shopNPC = param [0, objNull, [objNull]];
private _shopType = param [3, "", [""]];

if (isNull _shopNPC || {_shopType isEqualTo ""}) exitWith {
    displayNull
};

private _conditions = M_CONFIG(getText,"VirtualShops",_shopType,"conditions");
private _shopSide = M_CONFIG(getText,"VirtualShops",_shopType,"side"); 
private _playerSide = [playerSide,true] call MPServer_fnc_util_getSideString;
 
if (not(life_var_adminShop) AND count _shopSide > 0 AND count _playerSide > 0 AND {_playerSide isNotEqualTo _shopSide}) exitWith {
   displayNull
};

life_shop_type = _shopType;
life_shop_npc = _shopNPC;

if (not(life_var_adminShop) AND !([_conditions] call MPClient_fnc_checkConditions)) exitWith {hint localize "STR_Shop_Veh_NotAllowed";};

private _display = createDialog ["RscDisplayVirtualShop",true];

[] call MPClient_fnc_virt_update;

life_var_adminShop = false;

_display