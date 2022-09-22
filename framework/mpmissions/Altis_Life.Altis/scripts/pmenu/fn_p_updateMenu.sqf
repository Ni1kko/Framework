#include "..\..\script_macros.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

disableSerialization;

private _displayName = "RscDisplayInventory";
private _display = param [0, uiNamespace getVariable [_displayName, GETDisplay(_displayName)], [displayNull]];
private _side = [playerSide,true] call MPServer_fnc_util_getSideString;
private _nearByPlayers = (playableUnits apply {if (alive _x AND player distance _x < 10 AND _x isNotEqualTo player) then {_x}else{""}}) - [""];
private _ownedVirtualItemConfigNames = ([player,true,false,true] call MPClient_fnc_getGear)#1;
private _ownedLicenseDisplayNames = [player,true,true,false] call MPClient_fnc_getLicenses;

private _controlStructuredText_MoneyInfo = GETControl(_displayName, "moneyStatusInfo");
private _controlListbox_NearPlayers1 = GETControl(_displayName, "NearPlayersListbox1");
private _controlListbox_VirtualItems = GETControl(_displayName, "itemListBox");
private _controlListbox_NearPlayers2 = GETControl(_displayName, "NearPlayersListbox2");
private _controlStructuredText_Licenses = GETControlGroup(_displayName, "Licenses_Group" >> "NearPlayersListbox2");

//-- Clear list boxes
lbClear _controlListbox_VirtualItems;
lbClear _controlListbox_NearPlayers1;
lbClear _controlListbox_NearPlayers2;

//--- Money Info
if(not(isNil "life_var_cash") AND not(isNil "life_var_bank"))then{
    _controlStructuredText_MoneyInfo ctrlSetStructuredText parseText format ["<img size='1.3' image='textures\icons\ico_bank.paa'/> <t size='0.8px'>$%1</t><br/><img size='1.2' image='textures\icons\ico_money.paa'/> <t size='0.8'>$%2</t>",[life_var_bank] call MPClient_fnc_numberText,[life_var_cash] call MPClient_fnc_numberText];
};

//--- Near players
if(count _nearByPlayers > 0)then{
    {
        if !(isNull _x) then {
            // Near players 1
            _controlListbox_NearPlayers1 lbAdd format ["%1 - %2",_x getVariable ["realname",name _x], side _x];
            _controlListbox_NearPlayers1 lbSetData [(lbSize _controlListbox_NearPlayers1)-1,str(_x)];
            // Near players 2
            _controlListbox_NearPlayers2 lbAdd format ["%1 - %2",_x getVariable ["realname",name _x], side _x];
            _controlListbox_NearPlayers2 lbSetData [(lbSize _controlListbox_NearPlayers1)-1,str(_x)];
        };
    } forEach _nearByPlayers;
};

//--- Virtual items
if(count _ownedVirtualItemConfigNames)then{
    { 
        _controlListbox_VirtualItems lbAdd format ["%2 [x%1]",ITEM_VALUE(_x),localize (getText(_x >> "displayName"))];
        _controlListbox_VirtualItems lbSetData [(lbSize _controlListbox_VirtualItems)-1,_x];
        private _icon = M_CONFIG(getText,"VirtualItems",_x,"icon");
        if (count _icon > 0) then {
            _controlListbox_VirtualItems lbSetPicture [(lbSize _controlListbox_VirtualItems)-1,_icon];
        };
    } forEach _ownedVirtualItemConfigNames;
};

//-- Display licenses
if(count _ownedLicenseDisplayNames > 0)then{
    _controlStructuredText_Licenses ctrlSetStructuredText parseText format ["<t size='0.8px'>%1</t>",_ownedLicenseDisplayNames joinString "<br/>"]
}else{
    _controlStructuredText_Licenses ctrlSetStructuredText parseText "No Licenses";
};

//Carry weight 
ctrlSetText[121,format ["Weight: %1 / %2", life_var_carryWeight, life_maxWeight]];

true