/*
    File: fn_progressBar.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Initializes the progress bar.
*/
disableSerialization;
private ["_ui","_progress"];
"progressBar" cutRsc ["RscDisplayProgressBar","PLAIN"];
_ui = uiNameSpace getVariable "RscDisplayProgressBar";
_progress = _ui displayCtrl 38201;

_progress progressSetPosition 0.5;
