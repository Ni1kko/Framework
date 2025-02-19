#include "..\..\clientDefines.hpp"
/*
    File: fn_jerryRefuel.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Refuels the vehicle if the player has a fuel can.
*/
private ["_vehicle","_displayName","_upp","_ui","_progress","_pgText","_cP","_previousState"];
_vehicle = cursorObject;
life_var_interrupted = false;

if (isNull _vehicle) exitWith {hint localize "STR_ISTR_Jerry_NotLooking"};
if (!(_vehicle isKindOF "LandVehicle") && !(_vehicle isKindOf "Air") && !(_vehicle isKindOf "Ship")) exitWith {};
if (player distance _vehicle > 7.5) exitWith {hint localize "STR_ISTR_Jerry_NotNear"};

if not(["USE","fuelFull",1] call MPClient_fnc_handleVitrualItem) exitWith {};
life_var_isBusy = true;

_displayName = FETCH_CONFIG2(getText,"CfgVehicles",(typeOf _vehicle),"displayName");

_upp = format [localize "STR_ISTR_Jerry_Process",_displayName];

//Setup our progress bar.
disableSerialization;
"progressBar" cutRsc ["RscTitleProgressBar","PLAIN"];
_ui = uiNamespace getVariable "RscTitleProgressBar";
_progress = _ui displayCtrl 38201;
_pgText = _ui displayCtrl 38202;
_pgText ctrlSetText format ["%2 (1%1)...","%",_upp];
_progress progressSetPosition 0.01;
_cP = 0.01;

for "_i" from 0 to 1 step 0 do {
    if (animationState player != "AinvPknlMstpSnonWnonDnon_medic_1") then {
        [player,"AinvPknlMstpSnonWnonDnon_medic_1",true] remoteExecCall ["MPClient_fnc_animSync",RE_CLIENT];
        player switchMove "AinvPknlMstpSnonWnonDnon_medic_1";
        player playMoveNow "AinvPknlMstpSnonWnonDnon_medic_1";
    };
    sleep 0.2;
    if (isNull _ui) then {
        "progressBar" cutRsc ["RscTitleProgressBar","PLAIN"];
        _ui = uiNamespace getVariable "RscTitleProgressBar";
        _progressBar = _ui displayCtrl 38201;
        _titleText = _ui displayCtrl 38202;
    };
    _cP = _cP + 0.01;
    _progress progressSetPosition _cP;
    _pgText ctrlSetText format ["%3 (%1%2)...",round(_cP * 100),"%",_upp];
    if (_cP >= 1) exitWith {};
    if (!alive player) exitWith {};
    if (life_var_interrupted) exitWith {};
};
life_var_isBusy = false;
"progressBar" cutText ["","PLAIN"];
player playActionNow "stop";
if (!alive player) exitWith {};
if (life_var_interrupted) exitWith {life_var_interrupted = false; titleText[localize "STR_NOTF_ActionCancel","PLAIN"];};


switch (true) do {
    case (_vehicle isKindOF "LandVehicle"): {
        if (!local _vehicle) then {
            [_vehicle,(Fuel _vehicle) + 0.5] remoteExecCall ["MPClient_fnc_setFuel",_vehicle];
        } else {
            _vehicle setFuel ((Fuel _vehicle) + 0.5);
        };
    };

    case (_vehicle isKindOf "Air"): {
        if (!local _vehicle) then {
            [_vehicle,(Fuel _vehicle) + 0.2] remoteExecCall ["MPClient_fnc_setFuel",_vehicle];
        } else {
            _vehicle setFuel ((Fuel _vehicle) + 0.2);
        };
    };

    case (_vehicle isKindOf "Ship"): {
        if (!local _vehicle) then {
            [_vehicle,(Fuel _vehicle) + 0.35] remoteExecCall ["MPClient_fnc_setFuel",_vehicle];
        } else {
            _vehicle setFuel ((Fuel _vehicle) + 0.35);
        };
    };
};
titleText[format [localize "STR_ISTR_Jerry_Success",_displayName],"PLAIN"];
["ADD","fuelEmpty",1] call MPClient_fnc_handleVitrualItem;