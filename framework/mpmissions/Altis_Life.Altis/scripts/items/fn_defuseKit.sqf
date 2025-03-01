#include "..\..\clientDefines.hpp"
/*
    File: fn_defuseKit.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Defuses blasting charges for the cops?
*/
private ["_vault","_ui","_title","_progressBar","_cP","_titleText"];
_vault = param [0,objNull,[objNull]];

if (isNull _vault) exitWith {};
if (typeOf _vault != "Land_CargoBox_V1_F") exitWith {hint localize "STR_ISTR_defuseKit_NotNear"};
if (!(_vault getVariable ["chargeplaced",false])) exitWith {hint localize "STR_ISTR_Defuse_Nothing"};

life_var_isBusy = true;
//Setup the progress bar
disableSerialization;

_title = localize "STR_ISTR_Defuse_Process";
"progressBar" cutRsc ["RscTitleProgressBar","PLAIN"];
_ui = uiNamespace getVariable "RscTitleProgressBar";
_progressBar = _ui displayCtrl 38201;
_titleText = _ui displayCtrl 38202;
_titleText ctrlSetText format ["%2 (1%1)...","%",_title];
_progressBar progressSetPosition 0.01;
_cP = 0.01;

for "_i" from 0 to 1 step 0 do {
    if (animationState player != "AinvPknlMstpSnonWnonDnon_medic_1") then {
        [player,"AinvPknlMstpSnonWnonDnon_medic_1",true] remoteExecCall ["MPClient_fnc_animSync",RE_CLIENT];
        player switchMove "AinvPknlMstpSnonWnonDnon_medic_1";
        player playMoveNow "AinvPknlMstpSnonWnonDnon_medic_1";
    };
    sleep 0.26;
    if (isNull _ui) then {
        "progressBar" cutRsc ["RscTitleProgressBar","PLAIN"];
        _ui = uiNamespace getVariable "RscTitleProgressBar";
        _progressBar = _ui displayCtrl 38201;
        _titleText = _ui displayCtrl 38202;
    };
    _cP = _cP + .0035;
    _progressBar progressSetPosition _cP;
    _titleText ctrlSetText format ["%3 (%1%2)...",round(_cP * 100),"%",_title];
    if (_cP >= 1 || !alive player) exitWith {};
    if (life_var_interrupted) exitWith {};
};

//Kill the UI display and check for various states
"progressBar" cutText ["","PLAIN"];
player playActionNow "stop";
if (!alive player) exitWith {life_var_isBusy = false;};
if (life_var_interrupted) exitWith {life_var_interrupted = false; titleText[localize "STR_NOTF_ActionCancel","PLAIN"]; life_var_isBusy = false;};

life_var_isBusy = false;
_vault setVariable ["chargeplaced",false,true];
[0,localize "STR_ISTR_Defuse_Success"] remoteExecCall ["MPClient_fnc_broadcast",west];