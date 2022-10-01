/*
    File: fn_pullOutVeh.sqf
    Author: Bryan "Tonic" Boardwine

    Description:

*/
if (playerSide isEqualTo west || (isNull objectParent player)) exitWith {};
if (player getVariable "restrained") then {
    detach player;
    player setVariable ["Escorting",false,true];
    player setVariable ["transporting",false,true];
    life_var_preventGetOut = false;
    player action ["Eject", vehicle player];
    titleText[localize "STR_NOTF_PulledOut","PLAIN"];
    titleFadeOut 4;
    life_var_preventGetIn = true;
} else {
    player action ["Eject", vehicle player];
    titleText[localize "STR_NOTF_PulledOut","PLAIN"];
    titleFadeOut 4;
};
