#include "..\..\..\clientDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
    ## fn_buyClothes.sqf
*/

if ((lbCurSel 3101) isEqualTo -1) exitWith {titleText[localize "STR_Shop_NoClothes","PLAIN"];};

private _price = 0;
{
    if (!(_x isEqualTo -1)) then {
        _price = _price + _x;
    };
} forEach life_var_clothingTraderData;

if (_price > MONEY_CASH) exitWith {titleText[localize "STR_Shop_NotEnoughClothes","PLAIN"];};
["SUB","CASH",_price] call MPClient_fnc_handleMoney;

life_clothesPurchased = true;
closeDialog 0;

true