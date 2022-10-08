#include "..\..\clientDefines.hpp"
/*
    File: fn_settingsMenu
    Author: Bryan "Tonic" Boardwine

    Description:
    Setup the settings menu.
*/

private _display = createDialog ["RscDisplayPlayerInventorySettings",true];

disableSerialization;

ctrlSetText[2902, format ["%1", life_var_viewDistanceFoot]];
ctrlSetText[2912, format ["%1", life_var_viewDistanceCar]];
ctrlSetText[2922, format ["%1", life_var_viewDistanceAir]];

/* Set up the sliders */
{
    slidersetRange [(_x select 0),100,8000];
    CONTROL(2900,(_x select 0)) sliderSetSpeed [100,100,100];
    sliderSetPosition [(_x select 0),(_x select 1)];
} forEach [
    [2901,life_var_viewDistanceFoot],
    [2911,life_var_viewDistanceCar],
    [2921,life_var_viewDistanceAir]
];

if (isNil "life_var_enableRevealObjects") then {
    life_var_enableNewsBroadcast = profileNamespace setVariable ["life_enableNewsBroadcast",true];
    life_var_enableSidechannel = profileNamespace setVariable ["life_enableSidechannel",true];
    life_var_enablePlayerTags = profileNamespace setVariable ["life_var_enablePlayerTags",true];
    life_var_enableRevealObjects = profileNamespace setVariable ["life_var_enableRevealObjects",true];
};

CONTROL(2900,2971) cbSetChecked life_var_enableSidechannel;
CONTROL(2900,2973) cbSetChecked life_var_enableNewsBroadcast;
CONTROL(2900,2970) cbSetChecked life_var_enablePlayerTags;
CONTROL(2900,2972) cbSetChecked life_var_enableRevealObjects;
