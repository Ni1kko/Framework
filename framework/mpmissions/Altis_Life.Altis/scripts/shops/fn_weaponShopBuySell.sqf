#include "..\..\script_macros.hpp"
/*
    File: fn_weaponShopBuySell.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Master handling of the weapon shop for buying / selling an item.
*/
disableSerialization;
private ["_price","_item","_itemInfo","_bad"];
if ((lbCurSel 38403) isEqualTo -1) exitWith {hint localize "STR_Shop_Weapon_NoSelect"};
_price = lbValue[38403,(lbCurSel 38403)]; if (isNil "_price") then {_price = 0;};
_item = lbData[38403,(lbCurSel 38403)];
_itemInfo = [_item] call MPClient_fnc_fetchCfgDetails;

_bad = "";

if ((_itemInfo select 6) != "CfgVehicles") then {
    if ((_itemInfo select 4) in [4096,131072]) then {
        if (!(player canAdd _item) && (uiNamespace getVariable ["Weapon_Shop_Filter",0]) != 1) exitWith {_bad = (localize "STR_NOTF_NoRoom")};
    };
};

if (_bad != "") exitWith {hint _bad};

if ((uiNamespace getVariable ["Weapon_Shop_Filter",0]) isEqualTo 1) then {
    ["ADD","CASH",_price] call MPClient_fnc_handleMoney;
    [_item,false] call MPClient_fnc_handleItem;
    hint parseText format [localize "STR_Shop_Weapon_Sold",_itemInfo select 1,[_price] call MPClient_fnc_numberText];
    [nil,(uiNamespace getVariable ["Weapon_Shop_Filter",0])] call MPClient_fnc_weaponShopFilter; //Update the menu.
} else {
    private _altisArray = ["Land_u_Barracks_V2_F","Land_i_Barracks_V2_F"];
    private _tanoaArray = ["Land_School_01_F","Land_Warehouse_03_F","Land_House_Small_02_F"];
    private _hideoutObjs = [[["Altis", _altisArray], ["Tanoa", _tanoaArray]]] call MPServer_fnc_terrainSort;
    private _hideout = (nearestObjects[getPosATL player,_hideoutObjs,25]) select 0;
    if (!isNil "_hideout" && {MONEY_GANG >= _price}) then {
        _action = [
            format [(localize "STR_Shop_Virt_Gang_FundsMSG")+ "<br/><br/>" +(localize "STR_Shop_Virt_Gang_Funds")+ " <t color='#8cff9b'>$%1</t><br/>" +(localize "STR_Shop_Virt_YourFunds")+ " <t color='#8cff9b'>$%2</t>",
                MONEY_GANG_FORMATTED,
                MONEY_CASH_FORMATTED
            ],
            localize "STR_Shop_Virt_YourorGang",
            localize "STR_Shop_Virt_UI_GangFunds",
            localize "STR_Shop_Virt_UI_YourCash"
        ] call BIS_fnc_guiMessage;
        if (_action) then {
            hint parseText format [localize "STR_Shop_Weapon_BoughtGang",_itemInfo select 1,[_price] call MPClient_fnc_numberText];
            ["SUB","GANG",_price] call MPClient_fnc_handleMoney;
            [_item,true] call MPClient_fnc_handleItem;

            if (count extdb_var_database_headless_clients > 0) then {
                [1,group player] remoteExecCall ["HC_fnc_updateGang",extdb_var_database_headless_client];
            } else {
                [1,group player] remoteExecCall ["MPServer_fnc_updateGang",RE_SERVER];
            };


        } else {
            if (_price > MONEY_CASH) exitWith {hint localize "STR_NOTF_NotEnoughMoney"};
            hint parseText format [localize "STR_Shop_Weapon_BoughtItem",_itemInfo select 1,[_price] call MPClient_fnc_numberText];
            ["SUB","CASH",_price] call MPClient_fnc_handleMoney;
            [_item,true] call MPClient_fnc_handleItem;
        };
    } else {
        if (_price > MONEY_CASH) exitWith {hint localize "STR_NOTF_NotEnoughMoney"};
        hint parseText format [localize "STR_Shop_Weapon_BoughtItem",_itemInfo select 1,[_price] call MPClient_fnc_numberText];
        ["SUB","CASH",_price] call MPClient_fnc_handleMoney;
        [_item,true] call MPClient_fnc_handleItem;
    };
};
[0] call MPClient_fnc_updatePartial;
[3] call MPClient_fnc_updatePartial;
