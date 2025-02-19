#include "..\..\clientDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
    ## fn_updateYMenu.sqf
*/

disableSerialization;

private _displayName = "RscDisplayPlayerInventory";

//-- Temp disable parts of old menu that are used in new menu
{
    _x ctrlShow false;
    _x ctrlEnable false;
}forEach [
    GETControlGroup(_displayName, "Licenses_Group", "Life_Licenses"),
    GETControl(_displayName, "licenseHeader"),
    GETControl(_displayName, "RemoveButton"),
    GETControl(_displayName, "UseButton"),
    GETControl(_displayName, "DropButton"),
    GETControl(_displayName, "itemEdit"),
    GETControl(_displayName, "itemHeader"),
    GETControl(_displayName, "moneyDrop"),
    GETControl(_displayName, "moneyEdit"),
    GETControl(_displayName, "moneySHeader"),
    GETControl(_displayName, "ButtonKeys"),
    GETControl(_displayName, "NearPlayersListbox1"),
    GETControl(_displayName, "NearPlayersListbox2"),
    GETControl(_displayName, "itemListBox"),
    GETControl(_displayName, "moneyStatusInfo"),
    GETControl(_displayName, "Weight")
];

GETControl(_displayName, "ButtonAdminMenu") ctrlEnable ((call life_adminLevel) > 0);

/*
private _display = param [0, uiNamespace getVariable [_displayName, GETDisplay(_displayName)], [displayNull]];
private _side = [playerSide,true] call MPServer_fnc_util_getSideString;
private _nearByPlayers = (playableUnits apply {if (alive _x AND player distance _x < 10 AND _x isNotEqualTo player) then {_x}else{""}}) - [""];
private _ownedVirtualItemConfigNames = ([player,true,false,true] call MPClient_fnc_getGear)#1;
private _ownedLicenseDisplayNames = ([player,true,true,false] call MPClient_fnc_getLicenses);

private _controlListbox_NearPlayers1 = GETControl(_displayName, "NearPlayersListbox1");
private _controlListbox_NearPlayers2 = GETControl(_displayName, "NearPlayersListbox2");
private _controlListbox_VirtualItems = GETControl(_displayName, "itemListBox");

//-- Clear list boxes
lbClear _controlListbox_VirtualItems;
lbClear _controlListbox_NearPlayers1;
lbClear _controlListbox_NearPlayers2;

//--- Money Info
GETControl(_displayName, "moneyStatusInfo") ctrlSetStructuredText parseText ([
    format ["<img size='1.3' image='textures\icons\ico_bank.paa'/> <t size='0.8'>$%1</t>",MONEY_BANK_FORMATTED],
    format ["<img size='1.2' image='textures\icons\ico_money.paa'/> <t size='0.8'>$%1</t>",MONEY_CASH_FORMATTED]
] joinString "<br/>");

//--- Near players
if(count _nearByPlayers > 0)then{
    {
        private _side = side _x;
        private _sideVar = [_side,true] call MPServer_fnc_util_getSideString;
        private _name = _x getVariable ["realname",name _x];
        private _label = format ["[%2] %1",_x getVariable ["realname",name _x], _sideVar];
        private _data = [_forEachIndex, str(_x)];
        
        {
            _x lbAdd _label;
            _x lbSetData _data;
        }forEach [
            _controlListbox_NearPlayers1,
            _controlListbox_NearPlayers2
        ];
    } forEach _nearByPlayers;
};

//--- Virtual items
if(count _ownedVirtualItemConfigNames > 0)then{
    { 
        _controlListbox_VirtualItems lbAdd format ["%1 [x%2]",ITEM_DISPLAYNAME(_x), ITEM_VALUE(_x)];
        _controlListbox_VirtualItems lbSetData [(lbSize _controlListbox_VirtualItems)-1,_x];
        private _icon = ITEM_ICON(_x);
        if (count _icon > 0) then {
            _controlListbox_VirtualItems lbSetPicture [(lbSize _controlListbox_VirtualItems)-1,_icon];
        };
    } forEach _ownedVirtualItemConfigNames;
};

//-- Display licenses
GETControlGroup(_displayName, "Licenses_Group", "Life_Licenses") ctrlSetStructuredText parseText (if(count _ownedLicenseDisplayNames > 0)then{format ["<t size='0.8px'>%1</t>",_ownedLicenseDisplayNames joinString "<br/>"]}else{"No Licenses"});


//Carry weight
GETControl(_displayName, "Weight") ctrlSetText format ["Weight: %1 / %2", life_var_carryWeight, life_var_maxCarryWeight];

*/

true