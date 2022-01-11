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