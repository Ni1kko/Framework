#include "..\..\..\script_macros.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
    ## fn_licenseShopMenuUpdate.sqf
*/

params [
	["_display", uiNamespace getVariable ["RscDisplayLicenseShop", displayNull], [displayNull]],
	["_shopClass", uiNamespace getVariable ["RscDisplayLicenseShop_Classname", ""], [""]]
];
  
private _shopLicenseList = _display displayCtrl 55126;
private _ownedLicenseStruct = _display displayCtrl 55131;
private _getAllLicenses = count _shopClass isEqualTo 0;

//Purge list
lbClear _shopLicenseList;

private _shopName = [M_CONFIG(getText,"cfgLicenseShops",_shopClass,"name"), "License Trader"] select _getAllLicenses;
private _shopLicenses = [M_CONFIG(getArray,"cfgLicenseShops",_shopClass,"items"), [objNull,false,false,true] call MPClient_fnc_getLicenses] select _getAllLicenses;
private _ownedLicenseDisplayNames = ([player,true,true,false] call MPClient_fnc_getLicenses);

//-- Set title
(_display displayCtrl 2403) ctrlSetText (_shopName call BIS_fnc_localize);

//-- Add licenses to list
{
	private _displayName = LICENSE_DISPLAYNAME(_x);
	private _price = LICENSE_PRICE(_x);
	private _side = LICENSE_SIDE(_x);
	private _icon = LICENSE_ICON(_x);

    if(not(LICENSE_VALUE(_x,_side))) then 
	{
		if (_price isNotEqualTo -1) then 
		{
			_shopLicenseList lbAdd format["%1  (£%2)",_displayName,[_price] call MPClient_fnc_numberText];
			_shopLicenseList lbSetData [(lbSize _shopLicenseList)-1,_x];
			_shopLicenseList lbSetValue [(lbSize _shopLicenseList)-1,_price];
			
			if (count _icon > 0) then {
				_shopLicenseList lbSetPicture [(lbSize _shopLicenseList)-1,_icon];
			};
		};
    };
} forEach _shopLicenses;

//-- Add licenses to struct
_ownedLicenseStruct ctrlSetStructuredText parseText (if(count _ownedLicenseDisplayNames > 0)then{format ["<t size='0.8px'>%1</t>",_ownedLicenseDisplayNames joinString "<br/>"]}else{"No Licenses"});

true