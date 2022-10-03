#include "..\..\script_macros.hpp"
/*
    File: fn_lockpick.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Main functionality for lock-picking.
*/

disableSerialization;

private _curTarget = cursorObject;
private _chance = random(100);
private _cP = 0.01;

if (life_var_isBusy) exitWith {};
if (isNull _curTarget) exitWith {}; //Bad type

private _distance = ((boundingBox _curTarget select 1) select 0) + 2;
if (player distance _curTarget > _distance) exitWith {}; //Too far

private _isVehicle = if ((_curTarget isKindOf "LandVehicle") || (_curTarget isKindOf "Ship") || (_curTarget isKindOf "Air")) then {true} else {false};
if (_isVehicle && _curTarget in life_var_vehicles) exitWith {hint localize "STR_ISTR_Lock_AlreadyHave"};

//More error checks
if (!_isVehicle && !isPlayer _curTarget) exitWith {};
if (!_isVehicle && !(_curTarget getVariable ["restrained",false])) exitWith {};
if (_curTarget getVariable "NPC") exitWith {hint localize "STR_NPC_Protected"};

private _title = format [localize "STR_ISTR_Lock_Process",if (!_isVehicle) then {"Handcuffs"} else {getText(configFile >> "CfgVehicles" >> (typeOf _curTarget) >> "displayName")}];
life_var_isBusy = true; //Lock out other actions
life_var_interrupted = false;

//Setup the progress bar
"progressBar" cutRsc ["RscDisplayProgressBar","PLAIN"];
private _ui = uiNamespace getVariable "RscDisplayProgressBar";
private _progressBar = _ui displayCtrl 38201;
private _titleText = _ui displayCtrl 38202;
_titleText ctrlSetText format ["%2 (1%1)...","%",_title];
_progressBar progressSetPosition 0.01;

//-- Activate alarm hazard lights (can be disable with keys by locking or unlocking)
[_player, "alarm",_vehicle] remoteExec ["MPClient_fnc_enableIndicator",0];

for "_i" from 0 to 1 step 0 do 
{
    if (animationState player != "AinvPknlMstpSnonWnonDnon_medic_1") then {
        [player,"AinvPknlMstpSnonWnonDnon_medic_1",true] remoteExecCall ["MPClient_fnc_animSync",RE_CLIENT];
        player switchMove "AinvPknlMstpSnonWnonDnon_medic_1";
        player playMoveNow "AinvPknlMstpSnonWnonDnon_medic_1";
    };

    uiSleep 0.26;

    if (isNull _ui) then {
        "progressBar" cutRsc ["RscDisplayProgressBar","PLAIN"];
        _ui = uiNamespace getVariable "RscDisplayProgressBar";
        _progressBar = _ui displayCtrl 38201;
        _titleText = _ui displayCtrl 38202;
    };
    _cP = _cP + 0.01;
    _progressBar progressSetPosition _cP;
    _titleText ctrlSetText format ["%3 (%1%2)...",round(_cP * 100),"%",_title];

    if (_cP >= 1 || !alive player) exitWith {};
    if (life_var_tazed) exitWith {}; //Tazed
    if (life_var_unconscious) exitWith {}; //Knocked
    if (life_var_interrupted) exitWith {};
    if (player getVariable ["restrained",false]) exitWith {};
    if (player distance _curTarget > _distance) exitWith {_badDistance = true;};
};

//Kill the UI display and check for various states
"progressBar" cutText ["","PLAIN"];
player playActionNow "stop";

life_var_isBusy = false;

if (!alive player || life_var_tazed || life_var_unconscious) exitWith {};
if (player getVariable ["restrained",false]) exitWith {};
if (!isNil "_badDistance") exitWith {titleText[localize "STR_ISTR_Lock_TooFar","PLAIN"]};
if (life_var_interrupted) exitWith {titleText[localize "STR_NOTF_ActionCancel","PLAIN"]; life_var_interrupted = false;};
if (!([false,"lockpick",1] call MPClient_fnc_handleInv)) exitWith {};

private _nearByPlayers = [];

{
    if (isPlayer _x AND alive _x) then {
        _nearByPlayers pushBackUnique _x;
    };
}forEach (player nearEntities ["Man", 250]);

if (!_isVehicle) then {
    _curTarget setVariable ["restrained",false,true];
    _curTarget setVariable ["Escorting",false,true];
    _curTarget setVariable ["transporting",false,true];
} else {
    if (_chance < 45) then 
    {
        titleText[localize "STR_ISTR_Lock_Success","PLAIN"];
        life_var_vehicles pushBack _curTarget;

        //-- Spotted by nearby players
        if(count _nearByPlayers > 0) then {  
            systemChat format["%1 you have been spotted by nearby players, Police have been alerted!",["Shit", "****"] select isStreamFriendlyUIEnabled];
            [getPlayerUID player,profileName,"487"] remoteExecCall ["MPServer_fnc_wantedAdd",RE_SERVER];
        };
    } else {
        [getPlayerUID player,profileName,"215"] remoteExecCall ["MPServer_fnc_wantedAdd",RE_SERVER];
        [0,"STR_ISTR_Lock_FailedNOTF",true,[profileName]] remoteExecCall ["MPClient_fnc_broadcast",west];
        titleText[localize "STR_ISTR_Lock_Failed","PLAIN"];
    };
};

true