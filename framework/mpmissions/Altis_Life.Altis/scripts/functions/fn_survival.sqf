#include "..\..\clientDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

private ["_foodTime","_waterTime","_bp","_walkDis","_lastPos","_curPos","_lastState"];
 
//Setup the time-based variables.
_foodTime = time;
_waterTime = time;
_walkDis = 0;
_bp = "";
_lastPos = visiblePosition player;
_lastPos = (_lastPos select 0) + (_lastPos select 1);
_lastState = vehicle player;

for "_i" from 0 to 1 step 0 do 
{
   //--- THIRST
    if ((time - _waterTime) > 900 && life_var_alive) then {
        if (life_var_thirst < 2) then {
            player setDamage 1; hint localize "STR_NOTF_DrinkMSG_Death";
        } else {
            life_var_thirst = life_var_thirst - 10;
            if (life_var_thirst < 2) then {player setDamage 1; hint localize "STR_NOTF_DrinkMSG_Death";};
            switch (life_var_thirst) do  {
                case 30: {hint localize "STR_NOTF_DrinkMSG_1";};
                case 20: {
                    hint localize "STR_NOTF_DrinkMSG_2";
                    if (CFG_MASTER(getNumber,"enable_fatigue") isEqualTo 1) then {player setFatigue 1;};
                };
                case 10: {
                    hint localize "STR_NOTF_DrinkMSG_3";
                    if (CFG_MASTER(getNumber,"enable_fatigue") isEqualTo 1) then {player setFatigue 1;};
                };
            };
        }; 
        
        _waterTime = time;
    };
    
    //--- HUNGER
    if ((time - _foodTime) > 1250 && life_var_alive) then {
        if (life_var_hunger < 2) then {
            player setDamage 1; hint localize "STR_NOTF_EatMSG_Death";
        } else {
            life_var_hunger = life_var_hunger - 10;
            if (life_var_hunger < 2) then {player setDamage 1; hint localize "STR_NOTF_EatMSG_Death";};
            switch (life_var_hunger) do {
                case 30: {hint localize "STR_NOTF_EatMSG_1";};
                case 20: {hint localize "STR_NOTF_EatMSG_2";};
                case 10: {
                    hint localize "STR_NOTF_EatMSG_3";
                    if (CFG_MASTER(getNumber,"enable_fatigue") isEqualTo 1) then {player setFatigue 1;};
                };
            };
        };
        _foodTime = time;
    };

    //--- BACKPACK
    if (backpack player isEqualTo "") then {
        life_maxWeight = CFG_MASTER(getNumber,"total_maxWeight");
        _bp = backpack player;
    } else {
        if (!(backpack player isEqualTo "") && {!(backpack player isEqualTo _bp)}) then {
            _bp = backpack player;
            life_maxWeight = CFG_MASTER(getNumber,"total_maxWeight") + round(FETCH_CONFIG2(getNumber,"CfgVehicles",_bp,"maximumload") / 4);
        };
    };

    //--- VIEW DISTANCE
    if (!(vehicle player isEqualTo _lastState) || {!life_var_alive}) then {
        [] call MPClient_fnc_updateViewDistance;
        _lastState = vehicle player;
    };

    //--- CARRY WEIGHT
    if (life_var_carryWeight > life_maxWeight && {!isForcedWalk player}) then {
        player forceWalk true;
        if (CFG_MASTER(getNumber,"enable_fatigue") isEqualTo 1) then {player setFatigue 1;};
        hint localize "STR_NOTF_MaxWeight";
    } else {
        if (isForcedWalk player) then {
            player forceWalk false;
        };
    };

    //--- WALKING 
    if (!life_var_alive) then {_walkDis = 0;} else {
        _curPos = visiblePosition player;
        _curPos = (_curPos select 0) + (_curPos select 1);
        if (!(_curPos isEqualTo _lastPos) && {(isNull objectParent player)}) then {
            _walkDis = _walkDis + 1;
            if (_walkDis isEqualTo 700) then {
                _walkDis = 0;
                life_var_thirst = life_var_thirst - random [0,2,7];
                life_var_hunger = life_var_hunger - random [0,2,7];
            };
        };
        _lastPos = visiblePosition player;
        _lastPos = (_lastPos select 0) + (_lastPos select 1);
    };

    uiSleep 1;
};
