#include "..\..\script_macros.hpp"
/*

	Function: 	life_fnc_handleDamage
	Project: 	Misty Peaks RPG
	Author:     Tonic, Merrick, Nikko, Affect & IceEagle132
	Github:		https://github.com/AsYetUntitled/Framework
	
*/
params [
    ["_unit",objNull,[objNull]],
    ["_selection","",[""]],
    ["_damage",0,[0]],
    ["_source",objNull,[objNull]],
    ["_projectile","",["",objNull]],
    ["_hitPointIndex",0,[0]],
    ["_instigator",objNull,[objNull]]
];

//get current damage data
private _currentDmg = [_unit getHitIndex _hitPointIndex, damage _unit] select (_hitPointIndex < 0);

// damage not important to us
if (_selection == "hands") exitWith {_unit getHit "hands"};
if (_selection == "legs") exitWith {_unit getHit "legs"};
if (_selection == "arms") exitWith {_unit getHit "arms"};

life_fnc_removeBuff = {
    private _type = param [0,"",[""]];
    if (_type == "") exitWith {};

    switch (_type) do {
        case "debuffs": {
            life_var_bleeding = false;
            life_var_pain_shock = false;
            life_var_critHit = false;
        }; 
        case "buffs": {};
        case "all": {
            life_var_bleeding = false;
            life_var_pain_shock = false;
            life_var_critHit = false;
        };
        default {
           missionNamespace setVariable [_type,false];
        };
    };
};

life_fnc_effects_critHit = {
    private["_sound","_critColorEffect"];
    while {life_var_critHit} do {
        uiSleep (15*60);
        if (life_var_critHit && alive(player) && player == vehicle player) then {
            _critColorEffect = ppEffectCreate ["colorCorrections", 2008];
            _critColorEffect ppEffectEnable true;
            _critColorEffect ppEffectAdjust [1, 1.1, -0.05, [0.4, 0.2, 0.3, -0.1], [0.3, 0.05, 0, 0], [0.5,0.5,0.5,0], [0,0,0,0,0,0,4]];
            _critColorEffect ppEffectCommit 18;
            [player,"ActsPknlMstpSnonWnonDnon_TreatingInjured_NikitinDead",true,true] remoteExecCall ["life_fnc_animSync",-2];
            _sound = ["action_cry_0", "action_cry_1"] call BIS_fnc_selectRandom;
            player say3D _sound;
            for "_i" from 1 to 20 do {
                titleText[format["You have a traumatic shock caused by a serious injury! You will wake up in %1 sec.", (21 - _i)],"PLAIN"];
                uiSleep 1;
                if (!alive(player) OR !life_var_critHit) exitWith {};
            };
            switch (true) do {
                case (!alive(player)) : {};
                case (player getVariable ["restrained",false]) : {player playMove "AmovPercMstpSnonWnonDnon_Ease"};
                default {[player,"amovpercmstpsnonwnondnon",true,true] remoteExecCall ["life_fnc_animSync",-2];};
            };
            ppEffectDestroy [_critColorEffect];
            player setFatigue 1;
            titleText["","PLAIN"];
        };
    };
};

life_fnc_effects_bleeding = {
    while {life_var_bleeding && alive(player)} do {
        if (damage player < 0.89) then {
            player setDamage (damage player + 0.05);
        } else {
            // send to agony
            [player,player] call life_fnc_Agony;
        };
        player setBleedingRemaining 10;
        addcamShake[1, 2, 10];
        titleText["Your bleeding ...","PLAIN"];
        [5000] call BIS_fnc_bloodEffect;				
        uiSleep 60;
    };
};

life_fnc_effects_painShock = {
    while {life_var_pain_shock && alive(player)} do {
        uiSleep 60;
        if (life_var_pain_shock && alive(player)) then {
            player setFatigue (getFatigue player + 0.1);
            addcamShake[3, 2, 10];
            systemChat "You have a pain shock ...";
        };
    };
};

life_fnc_addBuff = {
    params [
        ["_type","",[""]],	
        ["_section","",[""]],
        ["_time",0,[0]]
    ];
    switch (true) do {
	    case (life_var_bleeding) : {[] spawn life_fnc_effects_bleeding};
        case (life_var_pain_shock) : {[] spawn life_fnc_effects_painShock};
        case (life_var_critHit) : {[] spawn life_fnc_effects_critHit};
        default {  /*...code...*/ }; 
    };
};

life_fnc_KilledInAgony = {
    params [
        ["_unit",objNull,[objNull]],
        ["_source",objNull,[objNull]],
        ["_instigator",objNull,[objNull]],
        ["_damage",0,[0]],
        ["_projectile","",[""]],
        ["_selection","",[""]]
    ];

    ["all"] call life_fnc_removeBuff;
    _unit setDamage 1;
};

life_fnc_Agony = {
    params [
        ["_unit",objNull,[objNull]],
        ["_source",objNull,[objNull]],
        ["_instigator",objNull,[objNull]],
        ["_projectile","",[""]]
    ];
    _unit setVariable ["medicStatus",-1,true];
    _unit setVariable ["lifeState","INCAPACITATED",true];
    [_unit] spawn life_fnc_deathScreen;
};

// bug with cartridge definition
if (_projectile isEqualType objNull) then {
	_projectile = typeOf _projectile;
	_this set [4, _projectile];
};

if (alive _unit && _damage > 0) then {
    if((_unit getVariable ["lifeState",""]) isEqualTo "INCAPACITATED")then{
        [_unit,_shooter,_instigator,_damage,_projectile,_selection] spawn life_fnc_KilledInAgony;
    }else{
        if (!isNull _source && {_source != _unit}) then {
            if (side _source isEqualTo west) then {
                if (currentWeapon _source in ["hgun_P07_snds_F","arifle_SDAR_F"] && _projectile in ["B_9x21_Ball","B_556x45_dual"]) then {
                    if (alive _unit) then {
                        if (playerSide isEqualTo civilian && {!life_istazed}) then {
                            private _distance = 35;
                            if (_projectile isEqualTo "B_556x45_dual") then {_distance = 100};
                            if (_unit distance _source < _distance) then {
                                if !(isNull objectParent _unit) then {
                                    if (typeOf (vehicle _unit) isEqualTo "B_Quadbike_01_F") then {
                                        _unit action ["Eject",vehicle _unit];
                                        [_unit,_source] spawn life_fnc_tazed;
                                    };
                                } else {
                                    [_unit,_source] spawn life_fnc_tazed;
                                };
                            };
                        };
                        _damage = if (_selection isEqualTo "") then {
                            damage _unit;
                        } else { 
                            _unit getHit _selection;
                        };
                    };
                };
            };
        }else{
            if (_damage >= 0.89) then {
                [_unit,_source,_instigator,_projectile] call life_fnc_Agony;
            } else { 
                if (_dmg > 0) then {
                    switch (true) do {
                        case (_dmg > 0.1 && _dmg <= 0.3) : {
                            ["life_var_bleeding","debuff",300] spawn life_fnc_addBuff;
                        };
                        case (_dmg > 0.3 && _dmg <= 0.45) : {
                            ["life_var_pain_shock","debuff"] spawn life_fnc_addBuff;
                        };
                        case (_dmg > 0.45 && _dmg <= 0.9) : {
                           ["life_var_critHit","debuff"] spawn life_fnc_addBuff;
                        };
                        default {}; 
                    };
                };
            };
        };
    };
} else {
	_damage = _currentDmg;
};

_damage