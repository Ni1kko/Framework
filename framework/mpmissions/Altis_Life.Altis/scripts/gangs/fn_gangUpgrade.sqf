#include "..\..\script_macros.hpp"
/*
    File: fn_gangUpgrade.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Determinds the upgrade price and blah
*/
private ["_maxMembers","_slotUpgrade","_upgradePrice"];
_maxMembers = group player getVariable ["gang_maxMembers",8];
_slotUpgrade = _maxMembers + 4;
_upgradePrice = round(_slotUpgrade * ((LIFE_SETTINGS(getNumber,"gang_upgradeBase"))) / ((LIFE_SETTINGS(getNumber,"gang_upgradeMultiplier"))));

_action = [
    format [(localize "STR_GNOTF_MaxMemberMSG")+ "<br/><br/>" +(localize "STR_GNOTF_CurrentMax")+ "<br/>" +(localize "STR_GNOTF_UpgradeMax")+ "<br/>" +(localize "STR_GNOTF_Price")+ " <t color='#8cff9b'>$%3</t>",_maxMembers,_slotUpgrade,[_upgradePrice] call MPClient_fnc_numberText],
    localize "STR_Gang_UpgradeMax",
    localize "STR_Global_Buy",
    localize "STR_Global_Cancel"
] call BIS_fnc_guiMessage;

if (_action) then {
    if (life_var_bank < _upgradePrice) exitWith {
        hint parseText format [
            (localize "STR_GNOTF_NotEoughMoney_2")+ "<br/><br/>" +(localize "STR_GNOTF_Current")+ " <t color='#8cff9b'>$%1</t><br/>" +(localize "STR_GNOTF_Lacking")+ " <t color='#FF0000'>$%2</t>",
            [life_var_bank] call MPClient_fnc_numberText,
            [_upgradePrice - life_var_bank] call MPClient_fnc_numberText
        ];
    };
    ["SUB","BANK",_upgradePrice] call MPClient_fnc_handleMoney;
    group player setVariable ["gang_maxMembers",_slotUpgrade,true];
    hint parseText format [localize "STR_GNOTF_UpgradeSuccess",_maxMembers,_slotUpgrade,[_upgradePrice] call MPClient_fnc_numberText];

    if (count extdb_var_database_headless_clients > 0) then {
        [2,group player] remoteExec ["HC_fnc_updateGang",extdb_var_database_headless_client];
    } else {
        [2,group player] remoteExec ["MPServer_fnc_updateGang",RE_SERVER];
    };

} else {
    hint localize "STR_GNOTF_UpgradeCancel";
};
