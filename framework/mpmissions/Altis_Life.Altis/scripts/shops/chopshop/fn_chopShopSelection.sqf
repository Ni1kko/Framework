#include "..\..\..\clientDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
    ## fn_chopShopSelection.sqf
*/

params [
    ["_control",controlNull,[controlNull]],
    ["_selection",-1,[0]]
];

//Error checks
if (isNull _control || _selection isEqualTo -1) exitWith {};

private _price = _control lbValue _selection;

private _priceTag = ((findDisplay 39400) displayCtrl 39401);
_priceTag ctrlSetStructuredText parseText format ["<t size='0.8'>" +(localize "STR_GNOTF_Price")+ "<t color='#8cff9b'>$%1</t></t>",[(_price)] call MPClient_fnc_numberText];