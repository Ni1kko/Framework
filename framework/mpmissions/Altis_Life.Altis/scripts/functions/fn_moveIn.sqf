/*
    File: moveIn.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Set a variable on the player so that he can't get out of a vehicle
*/

life_var_preventGetIn = false;
player moveInCargo (_this select 0);
life_var_preventGetOut = true;
