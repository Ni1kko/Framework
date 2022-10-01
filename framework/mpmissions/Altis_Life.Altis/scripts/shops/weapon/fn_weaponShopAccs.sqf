#include "..\..\..\script_macros.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
    ## fn_weaponShopAccs.sqf
*/

disableSerialization;

if ((uiNamespace getVariable ["Weapon_Accessories", 0]) isEqualTo 0) then {
    private _weapon = lbData [38403, lbCurSel (38403)];
    private _compatibleItems = _weapon call BIS_fnc_compatibleItems; //Fetch all compatible Items for the weapons.
    uiNamespace setVariable ["Accessories_Array", _compatibleItems];
    uiNamespace setVariable ["Weapon_Accessories", 1];
} else {
    uiNamespace setVariable ["Weapon_Accessories", 0];
};
