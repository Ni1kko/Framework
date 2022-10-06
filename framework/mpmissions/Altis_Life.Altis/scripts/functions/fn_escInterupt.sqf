#include "..\..\clientDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
    ## fn_escInterupt.sqf 

    ## The script executes in its own namespace. 
        In order to get/set external global variable you need to explicitly use mission namespace.
            (waitUntil is forced into its own namespace, even using `with missionNamespace do {};` still executes in its own namespace)
*/

disableSerialization;

params [
    ["_display", displayNull, [displayNull]]
];

private _buttonControlEvents = [
    "ButtonClick",
    "ButtonDblClick",
    "ButtonDown",
    "ButtonUp",
    "MouseButtonDown",
    "MouseButtonUp",
    "MouseButtonClick",
    "MouseButtonDblClick"
];
    
//--- Stop endmission cheat
_display displayAddEventHandler ["KeyDown", { 
    params ["_display","_key","_shift"];
    if (_key isEqualTo 74 && {_shift}) exitWith {
        disableUserInput true;
        [] spawn {
            uiSleep 0.5;
            disableUserInput false;
        };
        true
    };
}];

with missionNamespace do
{
    //Name
    (_display displayCtrl 523) ctrlSetText profileName;
    (_display displayCtrl 523) ctrlSetToolTip "Your Arma3 Profile Name";

    //SteamID (Short)
    (_display displayCtrl 109) ctrlSetText format["%1|%2",(profileNameSteam),([(getPlayerUID player), 12, 17] call BIS_fnc_trimString)];
    (_display displayCtrl 109) ctrlSetToolTip "SteamName & Last 5 Number Of Your SteamID";
    
    //Save Btn
    {(_display displayCtrl 104) ctrlRemoveAllEventHandlers _x}forEach _buttonControlEvents;
    (_display displayCtrl 103) ctrlSetEventHandler ["ButtonClick", "_this call life_var_syncScript; true"]; //Must return turn or default arma code is ran

    //Exit Btn
    {(_display displayCtrl 104) ctrlRemoveAllEventHandlers _x}forEach _buttonControlEvents;
    (_display displayCtrl 104) ctrlSetEventHandler ["ButtonClick", "_this call life_var_abortScript; true"];//Must return turn or default arma code is ran
    
    private _esacpeTimeDone = false;
    
    while {not(isNull _display)} do 
    { 
        //Continue Btn
        (_display displayCtrl 2) ctrlEnable true; //Continue
        (_display displayCtrl 2) ctrlSetText "Resume";//Continue
        (_display displayCtrl 2) ctrlSetTooltip format["Resume %1 Life", worldname];

        //Save Btn
        (_display displayCtrl 103) ctrlEnable false;
        (_display displayCtrl 103) ctrlSetText "Sync Data";
        (_display displayCtrl 103) ctrlSetToolTip "Sync Player Data To Hive";
        
        //Respawn Btn
        (_display displayCtrl 1010) ctrlEnable false;
        (_display displayCtrl 1010) ctrlSetText "Respawn";
        (_display displayCtrl 1010) ctrlSetToolTip "Kills You And Gives You A New Life & Choice Of Spawn Locations";

        //Configure Btn
        (_display displayCtrl 101) ctrlSetText "Game Options";
        (_display displayCtrl 101) ctrlEnable true;
        (_display displayCtrl 101) ctrlSetToolTip "Configure Arma Options";

        //Field manual Btn 
        (_display displayCtrl 122) ctrlEnable false;
        (_display displayCtrl 122) ctrlSetText "Disabled"; 
        (_display displayCtrl 122) ctrlSetToolTip "Anticheat Patch";
        
        //Exit Btn
        (_display displayCtrl 104) ctrlEnable false;
        (_display displayCtrl 104) ctrlSetText "Exit";
        (_display displayCtrl 104) ctrlSetToolTip format["Leave %1 Life", worldname];

        //Enable Contols  
        if (call (missionNamespace getVariable ["life_var_isDormant",{false}])) then
        {
            //Respawn Btn
            (_display displayCtrl 1010) ctrlEnable true;
            //Configure Btn
            (_display displayCtrl 101) ctrlEnable true;

            private _cfgTimers = missionConfigFile >> "cfgTimers";
            private _timeStampAbort = time + getNumber(_cfgTimers >> "abort");
            private _timeStampSync = getNumber(_cfgTimers >> "sync");
            private _fnc_secondsToString = missionNamespace getVariable ["BIS_fnc_secondsToString", compileScript ["A3\functions_f\Strings\fn_secondsToString.sqf"]];
    
            //-- Hang here whilst doing timer shit
            waitUntil {
                private _remainingAbortTime = (_timeStampAbort - time);
                private _remainingSyncTime = (((missionNamespace getVariable ["life_var_lastSynced",time]) + _timeStampSync) - time);
                
                //-- Sync Button
                if(_remainingSyncTime > 0)then{
                    private _timeRemainingString = switch (true) do {
                        case (_remainingSyncTime >= 3600): {[_remainingSyncTime,"HH:MM:SS"] call _fnc_secondsToString}; 
                        case (_remainingSyncTime >= 60 AND _remainingSyncTime < 3600): {[_remainingSyncTime,"MM:SS"] call _fnc_secondsToString};
                        default {[_remainingSyncTime,"SS.MS"] call _fnc_secondsToString};
                    };

                    (_display displayCtrl 103) ctrlSetText format["Sync available in %1",_timeRemainingString];
                    (_display displayCtrl 103) ctrlEnable false;
                    (_display displayCtrl 103) ctrlCommit 0;
                };

                //-- Abort Button
                if(_remainingAbortTime > 0 AND not(_esacpeTimeDone))then{
                    private _timeRemainingString = switch (true) do {
                        case (_remainingAbortTime >= 3600): {[_remainingAbortTime,"HH:MM:SS"] call _fnc_secondsToString}; 
                        case (_remainingAbortTime >= 60 AND _remainingAbortTime < 3600): {[_remainingAbortTime,"MM:SS"] call _fnc_secondsToString};
                        default {[_remainingAbortTime,"SS.MS"] call _fnc_secondsToString};
                    };

                    (_display displayCtrl 104) ctrlSetText format[localize "STR_NOTF_AbortESC",_timeRemainingString];
                    (_display displayCtrl 104) ctrlEnable false;
                    (_display displayCtrl 104) ctrlCommit 0;
                };

                private _syncReady = round(_remainingSyncTime) <= 0;
                private _abortReady = _esacpeTimeDone OR round(_remainingAbortTime) <= 0;

                if(_syncReady AND not(ctrlEnabled(_display displayCtrl 103)))then{
                    (_display displayCtrl 103) ctrlEnable true;
                    (_display displayCtrl 103) ctrlSetText "Sync Data";
                    (_display displayCtrl 103) ctrlSetToolTip format["Leave %1 Life", worldname];
                };

                if(_abortReady AND not(ctrlEnabled(_display displayCtrl 104)))then{
                    (_display displayCtrl 104) ctrlEnable true;
                    (_display displayCtrl 104) ctrlSetText "Exit";
                    (_display displayCtrl 104) ctrlSetToolTip format["Leave %1 Life", worldname];
                    _esacpeTimeDone = true;
                };

                if(isNil "_display" OR {isNull _display})then{
                    _display = uiNamespace getVariable ["RscDisplayMPInterrupt",displayNull];
                };

                if(((_abortReady AND _syncReady) OR {isNull _display OR {not(call (missionNamespace getVariable ["life_var_isDormant",{false}]))}}))exitWith{
                    true
                };

                false
            };

            private _lastSyncTime = (missionNamespace getVariable ["life_var_lastSynced",time]);

            //-- Hang here whilst Dormant
            waitUntil {
                if((missionNamespace getVariable ["life_var_lastSynced",_lastSyncTime]) isNotEqualTo _lastSyncTime)exitWith{
                    true
                };

                if(not(call (missionNamespace getVariable ["life_var_isDormant",{false}])) OR {isNull (uiNamespace getVariable ["RscDisplayMPInterrupt",displayNull])})exitWith{
                    true
                };
                false
            };
        }else{
            //-- Hang here whilst not Dormant
            waitUntil {
                (_display displayCtrl 103) ctrlSetToolTip "DataSync Not Available";
                (_display displayCtrl 103) ctrlEnable false;
                (_display displayCtrl 1010) ctrlSetToolTip "Respawn Not Available";
                (_display displayCtrl 1010) ctrlEnable false;
                (_display displayCtrl 101) ctrlSetToolTip "Options Not Available";
                (_display displayCtrl 101) ctrlEnable false;
                if (missionNamespace getVariable ["life_var_sessionDone",false]) then {
                    (_display displayCtrl 104) ctrlSetToolTip "Abort Not Available";
                    (_display displayCtrl 104) ctrlEnable false;
                }else{
                    (_display displayCtrl 104) ctrlSetToolTip format["Leave %1 Life", worldname];
                    (_display displayCtrl 104) ctrlEnable true;
                };

                if((call (missionNamespace getVariable ["life_var_isDormant",{false}])) OR {isNull (uiNamespace getVariable ["RscDisplayMPInterrupt",displayNull])})exitWith{
                    true
                };

                false
            };
        };
    };
};

true