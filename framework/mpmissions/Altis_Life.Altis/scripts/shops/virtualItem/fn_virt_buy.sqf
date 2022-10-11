#include "..\..\..\clientDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
    ## fn_virt_buy.sqf
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
if ((_price * _amount) > MONEY_CASH && {!isNil "_hideout" && {(MONEY_GANG) <= _price * _amount}}) exitWith {hint localize "STR_NOTF_NotEnoughMoney"};
if ((time - life_var_actionDelay) < 0.2) exitWith {hint localize "STR_NOTF_ActionDelay";};
life_var_actionDelay = time;

_name = M_CONFIG(getText,"cfgVirtualItems",_type,"displayName");

if (["ADD",_type,_amount] call MPClient_fnc_handleVitrualItem) then {
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
            hint format [localize "STR_Shop_Virt_BoughtGang",_amount,TEXT_LOCALIZE(_name),[(_price * _amount)] call MPClient_fnc_numberText];
            private _value = (_price * _amount); 

            [1,group player,false,_value,player,MONEY_CASH] remoteExecCall ["MPServer_fnc_updateGangDataRequestPartial",RE_SERVER];
            
        } else {
            if ((_price * _amount) > MONEY_CASH) exitWith {["TAKE",_type,_amount] call MPClient_fnc_handleVitrualItem; hint localize "STR_NOTF_NotEnoughMoney";};
            hint format [localize "STR_Shop_Virt_BoughtItem",_amount,TEXT_LOCALIZE(_name),[(_price * _amount)] call MPClient_fnc_numberText];
            ["SUB","CASH",_price * _amount] call MPClient_fnc_handleMoney;
        };
    } else {
        if ((_price * _amount) > MONEY_CASH) exitWith {hint localize "STR_NOTF_NotEnoughMoney"; ["TAKE",_type,_amount] call MPClient_fnc_handleVitrualItem;};
        hint format [localize "STR_Shop_Virt_BoughtItem",_amount,TEXT_LOCALIZE(_name),[(_price * _amount)] call MPClient_fnc_numberText];
        ["SUB","CASH",_price * _amount] call MPClient_fnc_handleMoney;
    };
    [] call MPClient_fnc_virt_update;
};

[0] call MPClient_fnc_updatePlayerDataPartial;
[3] call MPClient_fnc_updatePlayerDataPartial;
