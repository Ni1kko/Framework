#include "..\..\clientDefines.hpp"
/*
    File: fn_restrain.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Restrains the client.
*/

params [
    ["_cop", objNull, [objNull]],
    ["_isBountyHunter", false, [false]]
];

private _player = player;
private _vehicle = vehicle player;

if (isNull _cop) exitWith {};

//Monitor excessive restrainment
[] spawn {
    private "_time";
    for "_i" from 0 to 1 step 0 do {
        _time = time;
        waitUntil {(time - _time) > (5 * 60)};

        if (!(player getVariable ["restrained",false])) exitWith {};
        if (!([west,getPos player,30] call MPClient_fnc_nearUnits) && (player getVariable ["restrained",false]) && isNull objectParent player) exitWith {
            player setVariable ["restrained",false,true];
            player setVariable ["Escorting",false,true];
            player setVariable ["transporting",false,true];
            detach player;
            titleText[localize "STR_Cop_ExcessiveRestrain","PLAIN"];
        };
    };
};
 
if(side _cop == west || _isBountyHunter) then {
	titleText[format[localize "STR_Cop_Restrained",_cop getVariable["realname",name _cop]],"PLAIN"];
} else{
	titleText[format[localize "STR_Civ_Ziptied",_cop getVariable["realname",name _cop]],"PLAIN"];		
};

life_var_preventGetIn = true;
life_var_preventGetOut = false;

while {player getVariable  "restrained"} do {
    if (isNull objectParent player) then {
        player playMove "AmovPercMstpSnonWnonDnon_Ease";
    };

    _state = vehicle player;
    waitUntil {animationState player != "AmovPercMstpSnonWnonDnon_Ease" || !(player getVariable "restrained") || vehicle player != _state};

    if (!alive player) exitWith {
        player setVariable ["restrained",false,true];
        player setVariable ["Escorting",false,true];
        player setVariable ["transporting",false,true];
        detach _player;
    };

    if (!alive _cop) then {
        player setVariable ["Escorting",false,true];
        detach player;
    };

    if (!(isNull objectParent player) && life_var_preventGetIn) then {
        player action["eject",vehicle player];
    };

    if (!(isNull objectParent player) && !(vehicle player isEqualTo _vehicle)) then {
        _vehicle = vehicle player;
    };

    if (isNull objectParent player && life_var_preventGetOut) then {
        player moveInCargo _vehicle;
    };

    if (!(isNull objectParent player) && life_var_preventGetOut && (driver (vehicle player) isEqualTo player)) then {
        player action["eject",vehicle player];
        player moveInCargo _vehicle;
    };

    if (!(isNull objectParent player) && life_var_preventGetOut) then {
        _turrets = [[-1]] + allTurrets _vehicle;
        {
            if (_vehicle turretUnit [_x select 0] isEqualTo player) then {
                player action["eject",vehicle player];
                sleep 1;
                player moveInCargo _vehicle;
            };
        }forEach _turrets;
    };
};

//disableUserInput false;

if (alive player) then {
    player switchMove "AmovPercMstpSlowWrflDnon_SaluteIn";
    player setVariable ["Escorting",false,true];
    player setVariable ["transporting",false,true];
    detach player;
};
