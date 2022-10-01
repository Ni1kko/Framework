#include "..\..\script_macros.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
    ## fn_openInventoryMenu.sqf
*/

disableSerialization;

private _displayName = "RscDisplayInventory";
private _display = uiNamespace getVariable [_displayName, displayNull];

//--- If the display is already open, close it (Allows user to toggle inventory)
if (!isNull _display) exitWith {
    _display closeDisplay 0;
    displayNull
};

//--- Double check no other menus are open and make sure player is alive
if (dialog OR not(life_var_alive)) exitWith {
    systemChat "You cannot open this menu while dead or in a dialog";
    displayNull
};

//--- Double check no menus are open and make sure player is alive
if (life_var_isBusy OR (player getVariable ["restrained",false])) exitWith {
    systemChat "You cannot open this menu while restrained or busy";
    displayNull
};

//-- Error loading display
if !(isClass (missionConfigFile >> _displayName)) exitWith {
    systemChat format["Error: Display %1 <NOT FOUND>",_displayName];
    displayNull
};

//--- Open the display
_display = createDialog [_displayName,true];

//-- Error loading display
if(isNull _display) exitWith {
    systemChat format["Error: Display is %1 <NULL>",_displayName];
    _display
};

private _controls = [
    "ButtonClose",
    "ButtonSettings",
    "ButtonMyGang",
    "ButtonWanted",
    "ButtonKeys",
    "ButtonCell",
    "ButtonBountyList",
    "ButtonAdminMenu"
] apply {GETControl(_displayName, _x)};

//-- Enable all controls
{
    _x ctrlEnable true;
    _x ctrlShow true;
}forEach _controls;

//-- Parse controls
_controls params [
    ["_controlBTN_Abort",       controlNull, [controlNull]],
    ["_controlBTN_Settings",    controlNull, [controlNull]],
    ["_controlBTN_Gang",        controlNull, [controlNull]],
    ["_controlBTN_Wanted",      controlNull, [controlNull]],
    ["_controlBTN_Keychain",    controlNull, [controlNull]],
    ["_controlBTN_Cellphone",   controlNull, [controlNull]],
    ["_controlBTN_Bounty",      controlNull, [controlNull]],
    ["_controlBTN_Admin",       controlNull, [controlNull]]
];
 
//--- Gang menu (civilians & rebels only)
_controlBTN_Gang ctrlShow (playerSide in [civilian,east]);
_controlBTN_Gang ctrlEnable (ctrlShown _controlBTN_Gang);

//--- Wanted menu (cops only)
_controlBTN_Wanted ctrlShow (playerSide isEqualTo west);
_controlBTN_Wanted ctrlEnable ((call life_coplevel) > 0);

//--- Bounty hunting menu (civs only)
_controlBTN_Bounty ctrlShow (playerSide isEqualTo civilian);
_controlBTN_Bounty ctrlEnable license_civ_bountyHunter;

//--- Admin menu (staff only)
_controlBTN_Admin ctrlShow not(isNil 'MPClient_fnc_admin_showmenu');
_controlBTN_Admin ctrlEnable ((call life_adminlevel) > 0);

//-- Update menu
[_display] call MPClient_fnc_updateInventoryMenu;

// Return display
_display