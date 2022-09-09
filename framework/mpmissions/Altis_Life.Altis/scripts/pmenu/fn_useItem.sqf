#include "..\..\script_macros.hpp"

/*
    File: fn_useItem.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Main function for item effects and functionality through the player menu.
*/

disableSerialization;

if ((lbCurSel 2005) isEqualTo -1) exitWith {
    hint localize "STR_ISTR_SelectItemFirst";
};

private _item = CONTROL_DATA(2005);
private _edible = M_CONFIG(getNumber, "VirtualItems", _item, "edible");
private _drinkable = M_CONFIG(getNumber, "VirtualItems", _item, "drinkable");

if (_edible > -1 || _drinkable > -1) exitWith {
    if ([false, _item, 1] call MPClient_fnc_handleInv) then {
        if (_edible > -1) then {
            private _sum = life_var_hunger + _edible;
            life_var_hunger = (_sum max 5) min 100; // never below 5 or above 100
        };

        if (_drinkable > -1) then {
            private _sum = life_var_thirst + _drinkable;

            life_var_thirst = (_sum max 5) min 100; // never below 5 or above 100

            if (LIFE_SETTINGS(getNumber, "enable_fatigue") isEqualTo 1) then {
                player setFatigue 0;
            };
            if (_item isEqualTo "redgull" && {LIFE_SETTINGS(getNumber, "enable_fatigue") isEqualTo 1}) then {
                [] spawn {
                    life_redgull_effect = time;
                    titleText [localize "STR_ISTR_RedGullEffect", "PLAIN"];
                    player enableFatigue false;
                    waitUntil {!alive player || ((time - life_redgull_effect) > (3 * 60))};
                    player enableFatigue true;
                };
            };
        };
    };

    [] call MPClient_fnc_p_updateMenu;
};

switch (_item) do {
    case "boltcutter": {
        [cursorObject] spawn MPClient_fnc_boltcutter;
        closeDialog 0;
    };

    case "blastingcharge": {
        player reveal fed_bank;
        (group player) reveal fed_bank;
        [cursorObject] spawn MPClient_fnc_blastingCharge;
        closeDialog 0;
    };

    case "defusekit": {
        [cursorObject] spawn MPClient_fnc_defuseKit;
        closeDialog 0;
    };

    case "storagesmall": {
        [false] call MPClient_fnc_storageBox;
    };

    case "storagebig": {
        [true] call MPClient_fnc_storageBox;
    };

    case "tentKit": {
        ["Land_TentDome_F"] spawn MPClient_fnc_deployTent;
    };

    case "spikeStrip": {
        if (!isNull life_spikestrip) exitWith {hint localize "STR_ISTR_SpikesDeployment"; closeDialog 0};
        if ([false, _item, 1] call MPClient_fnc_handleInv) then {
            [] spawn MPClient_fnc_spikeStrip;
            closeDialog 0;
        };
    };

    case "fuelFull": {
        if !(isNull objectParent player) exitWith {hint localize "STR_ISTR_RefuelInVehicle"};
        [] spawn MPClient_fnc_jerryRefuel;
        closeDialog 0;
    };

    case "fuelEmpty": {
        [] spawn MPClient_fnc_jerryCanRefuel;
        closeDialog 0;
    };

    case "lockpick": {
        [] spawn MPClient_fnc_lockpick;
        closeDialog 0;
    };

    default {
        hint localize "STR_ISTR_NotUsable";
    };
};

[] call MPClient_fnc_p_updateMenu;
