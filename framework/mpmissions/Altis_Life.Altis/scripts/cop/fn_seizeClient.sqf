#include "..\..\clientDefines.hpp"
/*
    File: fn_seizeClient.sqf
    Author: Daniel "Skalicon" Larusso

    Description:
    Removes the players weapons client side
*/
private ["_exempt","_uniform","_vest","_headgear"];
_exempt = CFG_MASTER(getArray,"seize_exempt");
_headgear = CFG_MASTER(getArray,"seize_headgear");
_vest = CFG_MASTER(getArray,"seize_vest");
_uniform = CFG_MASTER(getArray,"seize_uniform");

{
    if (!(_x in _exempt)) then {
        player removeWeapon _x;
    };
} forEach weapons player;

{
    if (!(_x in _exempt)) then {
        player removeItemFromUniform _x;
    };
} forEach uniformItems player;

{
    if (!(_x in _exempt)) then {
        player removeItemFromVest _x;
    };
} forEach vestItems player;

{
    if (!(_x in _exempt)) then {
        player removeItemFromBackpack _x;
    };
} forEach backpackItems player;

{
    if (!(_x in _exempt)) then {
            player removeMagazine _x;
    };
} forEach magazines player;

if (uniform player in _uniform) then {removeUniform player;};
if (vest player in _vest) then {removeVest player;};
if (headgear player in _headgear) then {removeHeadgear player;};

[] call MPClient_fnc_updatePlayerData;
titleText[localize "STR_NOTF_SeizeIllegals","PLAIN"];
