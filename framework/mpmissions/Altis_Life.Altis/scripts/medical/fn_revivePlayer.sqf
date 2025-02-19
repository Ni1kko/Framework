#include "..\..\clientDefines.hpp"
/*
    File: fn_revivePlayer.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Starts the revive process on the player.
*/
if !(params[["_target", objNull, [objNull]]]) exitWith {};

private _reviveCost = CFG_MASTER(getNumber, "revive_fee");
private _revivable = _target getVariable ["Revive", false];

if (_revivable) exitWith {};
if ((_target getVariable ["Reviving", objNull]) isEqualTo player) exitWith {hint localize "STR_Medic_AlreadyReviving";};
if (player distance _target > 5) exitWith {};

private _targetName = _target getVariable ["realname", name _target];
private _title = format [localize "STR_Medic_Progress", _targetName];
life_var_isBusy = true; //Lockout the controls.

_target setVariable ["Reviving", player, true];
disableSerialization;
"progressBar" cutRsc ["RscTitleProgressBar", "PLAIN"];
private _ui = uiNamespace getVariable ["RscTitleProgressBar", displayNull];
private _progressBar = _ui displayCtrl 38201;
private _titleText = _ui displayCtrl 38202;
_titleText ctrlSetText format ["%2 (1%1)...", "%", _title];
_progressBar progressSetPosition 0.01;
private _cP = 0.01;

private _badDistance = false;
for "_i" from 0 to 1 step 0 do {
    if !(animationState player isEqualTo "ainvpknlmstpsnonwnondnon_medic_1") then {
        [player, "AinvPknlMstpSnonWnonDnon_medic_1"] remoteExecCall ["MPClient_fnc_animSync", RE_CLIENT];
        player playMoveNow "AinvPknlMstpSnonWnonDnon_medic_1";
    };

    sleep .15;
    _cP = _cP + .01;
    _progressBar progressSetPosition _cP;
    _titleText ctrlSetText format ["%3 (%1%2)...", round(_cP * 100), "%", _title];
    if (_cP >= 1 || {!alive player}) exitWith {};
    if (life_var_tazed || {life_var_unconscious} || {life_var_interrupted}) exitWith {};
    if (player getVariable ["restrained", false]) exitWith {};
    if (player distance _target > 4) exitWith {_badDistance = true;};
    if (_target getVariable ["Revive", false]) exitWith {};
    if !(_target getVariable ["Reviving", objNull] isEqualTo player) exitWith {};
};

//Kill the UI display and check for various states
"progressBar" cutText ["", "PLAIN"];
player playActionNow "stop";

if !(_target getVariable ["Reviving", objNull] isEqualTo player) exitWith {hint localize "STR_Medic_AlreadyReviving"; life_var_isBusy = false;};
_target setVariable ["Reviving", nil, true];

if (!alive player || {life_var_tazed} || {life_var_unconscious}) exitWith {life_var_isBusy = false;};
if (_target getVariable ["Revive", false]) exitWith {hint localize "STR_Medic_RevivedRespawned"; life_var_isBusy = false;};
if (player getVariable ["restrained", false]) exitWith {life_var_isBusy = false;};
if (_badDistance) exitWith {titleText[localize "STR_Medic_TooFar","PLAIN"]; life_var_isBusy = false;};
if (life_var_interrupted) exitWith {life_var_interrupted = false; titleText[localize "STR_NOTF_ActionCancel", "PLAIN"]; life_var_isBusy = false;};

life_var_isBusy = false;
_target setVariable ["Revive", true, true];
[player, _target, _target getVariable ["arrested",false]] remoteExecCall ["MPClient_fnc_revived", _target];

if (playerSide isEqualTo independent) then {
    titleText[format [localize "STR_Medic_RevivePayReceive", _targetName,[_reviveCost] call MPClient_fnc_numberText], "PLAIN"];
    ["ADD","BANK",_reviveCost] call MPClient_fnc_handleMoney;
};

sleep .6;
player reveal _target;
