#include "..\..\script_macros.hpp"
/*
    File: fn_virt_buy.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Buy a virtual item from the store.
*/
private ["_type","_price","_amount","_diff","_name","_hideout"];
if ((lbCurSel 2401) isEqualTo -1) exitWith {hint localize "STR_Shop_Virt_Nothing"};
_type = lbData[2401,(lbCurSel 2401)];
_price = lbValue[2401,(lbCurSel 2401)];
_amount = ctrlText 2404;
if (!([_amount] call MPServer_fnc_isNumber)) exitWith {hint localize "STR_Shop_Virt_NoNum";};
_diff = [_type,parseNumber(_amount),life_var_carryWeight,life_maxWeight] call MPClient_fnc_calWeightDiff;
_amount = parseNumber(_amount);
if (_diff <= 0) exitWith {hint localize "STR_NOTF_NoSpace"};
_amount = _diff;
private _altisArray = ["Land_u_Barracks_V2_F","Land_i_Barracks_V2_F"];
private _tanoaArray = ["Land_School_01_F","Land_Warehouse_03_F","Land_House_Small_02_F"];
private _hideoutObjs = [[["Altis", _altisArray], ["Tanoa", _tanoaArray]]] call MPServer_fnc_terrainSort;
_hideout = (nearestObjects[getPosATL player,_hideoutObjs,25]) select 0;
if ((_price * _amount) > MONEY_CASH && {!isNil "_hideout" && {!isNil {group player getVariable "gang_bank"}} && {(group player getVariable "gang_bank") <= _price * _amount}}) exitWith {hint localize "STR_NOTF_NotEnoughMoney"};
if ((time - life_action_delay) < 0.2) exitWith {hint localize "STR_NOTF_ActionDelay";};
life_action_delay = time;

_name = M_CONFIG(getText,"VirtualItems",_type,"displayName");

if ([true,_type,_amount] call MPClient_fnc_handleInv) then {
    if (!isNil "_hideout" && {!isNil {group player getVariable "gang_bank"}} && {(group player getVariable "gang_bank") >= _price}) then {
        _action = [
            format [(localize "STR_Shop_Virt_Gang_FundsMSG")+ "<br/><br/>" +(localize "STR_Shop_Virt_Gang_Funds")+ " <t color='#8cff9b'>$%1</t><br/>" +(localize "STR_Shop_Virt_YourFunds")+ " <t color='#8cff9b'>$%2</t>",
                [(group player getVariable "gang_bank")] call MPClient_fnc_numberText,
                [MONEY_CASH] call MPClient_fnc_numberText
            ],
            localize "STR_Shop_Virt_YourorGang",
            localize "STR_Shop_Virt_UI_GangFunds",
            localize "STR_Shop_Virt_UI_YourCash"
        ] call BIS_fnc_guiMessage;
        if (_action) then {
            hint format [localize "STR_Shop_Virt_BoughtGang",_amount,TEXT_LOCALIZE(_name),[(_price * _amount)] call MPClient_fnc_numberText];
            _funds = group player getVariable "gang_bank";
            _funds = _funds - (_price * _amount);
            group player setVariable ["gang_bank",_funds,true];

            if (count extdb_var_database_headless_clients > 0) then {
                [1,group player] remoteExecCall ["HC_fnc_updateGang",extdb_var_database_headless_client];
            } else {
                [1,group player] remoteExecCall ["MPServer_fnc_updateGang",RE_SERVER];
            };

        } else {
            if ((_price * _amount) > MONEY_CASH) exitWith {[false,_type,_amount] call MPClient_fnc_handleInv; hint localize "STR_NOTF_NotEnoughMoney";};
            hint format [localize "STR_Shop_Virt_BoughtItem",_amount,TEXT_LOCALIZE(_name),[(_price * _amount)] call MPClient_fnc_numberText];
            ["SUB","CASH",_price * _amount] call MPClient_fnc_handleMoney;
        };
    } else {
        if ((_price * _amount) > MONEY_CASH) exitWith {hint localize "STR_NOTF_NotEnoughMoney"; [false,_type,_amount] call MPClient_fnc_handleInv;};
        hint format [localize "STR_Shop_Virt_BoughtItem",_amount,TEXT_LOCALIZE(_name),[(_price * _amount)] call MPClient_fnc_numberText];
        ["SUB","CASH",_price * _amount] call MPClient_fnc_handleMoney;
    };
    [] call MPClient_fnc_virt_update;
};

[0] call MPClient_fnc_updatePartial;
[3] call MPClient_fnc_updatePartial;
