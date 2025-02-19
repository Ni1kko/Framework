#include "..\..\clientDefines.hpp"
/*
    File: fn_repairTruck.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Main functionality for toolkits, to be revised in later version.
*/
private ["_veh","_upp","_ui","_progress","_pgText","_cP","_displayName","_test","_sideRepairArray"];
_veh = cursorObject;
life_var_interrupted = false;
if (isNull _veh) exitWith {};
if ((_veh isKindOf "Car") || (_veh isKindOf "Ship") || (_veh isKindOf "Air")) then {
    if (life_inv_toolkit > 0) then {
        life_var_isBusy = true;
        _displayName = FETCH_CONFIG2(getText,"CfgVehicles",(typeOf _veh),"displayName");
        _upp = format [localize "STR_NOTF_Repairing",_displayName];

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

            sleep 0.27;
            _cP = _cP + 0.01;
            _progress progressSetPosition _cP;
            _pgText ctrlSetText format ["%3 (%1%2)...",round(_cP * 100),"%",_upp];
            if (_cP >= 1) exitWith {};
            if (!alive player) exitWith {};
            if !(isNull objectParent player) exitWith {};
            if (life_var_interrupted) exitWith {};
        };

        life_var_isBusy = false;
        "progressBar" cutText ["","PLAIN"];
        player playActionNow "stop";
        if (life_var_interrupted) exitWith {life_var_interrupted = false; titleText[localize "STR_NOTF_ActionCancel","PLAIN"]; life_var_isBusy = false;};
        if !(isNull objectParent player) exitWith {titleText[localize "STR_NOTF_ActionInVehicle","PLAIN"];};

        _sideRepairArray = CFG_MASTER(getArray,"vehicle_infiniteRepair");

        //Check if playerSide has infinite repair enabled
        if (playerSide isEqualTo civilian && (_sideRepairArray select 0) isEqualTo 0) then {
            ["USE","toolkit",1] call MPClient_fnc_handleVitrualItem;
        };
        if (playerSide isEqualTo west && (_sideRepairArray select 1) isEqualTo 0) then {
            ["USE","toolkit",1] call MPClient_fnc_handleVitrualItem;
        };
        if (playerSide isEqualTo independent && (_sideRepairArray select 2) isEqualTo 0) then {
            ["USE","toolkit",1] call MPClient_fnc_handleVitrualItem;
        };
        if (playerSide isEqualTo east && (_sideRepairArray select 3) isEqualTo 0) then {
            ["USE","toolkit",1] call MPClient_fnc_handleVitrualItem;
        };

        _veh setDamage 0;
        titleText[localize "STR_NOTF_RepairedVehicle","PLAIN"];
    };
};
