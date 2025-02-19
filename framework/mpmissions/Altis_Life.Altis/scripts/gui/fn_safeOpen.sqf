#include "..\..\clientDefines.hpp"
/*
    File: fn_safeOpen.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Opens the safe inventory menu.
*/
if (dialog) exitWith {}; //A dialog is already open.
life_safeObj = param [0,objNull,[objNull]];
if (isNull life_safeObj) exitWith {};
if !(playerSide isEqualTo civilian) exitWith {};
if ((life_safeObj getVariable ["safe",-1]) < 1) exitWith {hint localize "STR_Civ_VaultEmpty";};
if (life_safeObj getVariable ["inUse",false]) exitWith {hint localize "STR_Civ_VaultInUse"};
if (!createDialog "RscDisplayFederalBank") exitWith {localize "STR_MISC_DialogError"};

disableSerialization;
ctrlSetText[3501,(localize "STR_Civ_SafeInv")];
[life_safeObj] call MPClient_fnc_safeInventory;
life_safeObj setVariable ["inUse",true,true];

[life_safeObj] spawn {
    scriptName 'MPClient_fnc_viewSafeContents';
    waitUntil {isNull (findDisplay 3500)};
    (_this select 0) setVariable ["inUse",false,true];
};
