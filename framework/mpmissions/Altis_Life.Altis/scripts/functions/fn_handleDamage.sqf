#include "..\..\clientDefines.hpp"
/*

    Function: 	MPClient_fnc_handleDamage
	Project: 	AsYetUntitled
	Author:     Tonic, Merrick, Nikko, Affect & IceEagle132
	Github:		https://github.com/Ni1kko/FrameworkV2
	
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

//-- block shit put them in comabt for 5 seconds
[_unit, 5] call life_fnc_enterCombat;

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
        [_unit,_source,_instigator,_damage,_projectile,_selection] spawn MPClient_fnc_KilledInAgony;
    }else{
        if (!isNull _source && {_source != _unit}) then 
        {
            if (side _source isEqualTo west) then {
                if (currentWeapon _source in ["hgun_P07_snds_F","arifle_SDAR_F"] && _projectile in ["B_9x21_Ball","B_556x45_dual"]) then {
                    if (alive _unit) then {
                        if (playerSide isEqualTo civilian && {!life_var_tazed}) then {
                            private _distance = 35;
                            if (_projectile isEqualTo "B_556x45_dual") then {_distance = 100};
                            if (_unit distance _source < _distance) then {
                                if !(isNull objectParent _unit) then {
                                    if (typeOf (vehicle _unit) isEqualTo "B_Quadbike_01_F") then {
                                        _unit action ["Eject",vehicle _unit];
                                        [_unit,_source] spawn MPClient_fnc_tazed;
                                    };
                                } else {
                                    [_unit,_source] spawn MPClient_fnc_tazed;
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


            if(_curWep isEqualTo "hgun_PDW2000_F") then { 
                if(vehicle _source == _source && isPlayer _source && player distance _source < 50 && vehicle player == player) then {
                    [_unit] remoteExec ["MPClient_fnc_bountyHunterTaze",owner _source];
                };
            };
        }else{
            if (_damage >= 0.89) then {
                [_unit,_source,_instigator,_projectile] call MPClient_fnc_Agony;
            } else { 
                if (_damage > 0) then {
                    switch (true) do {
                        case (_damage > 0.1 && _damage <= 0.3) : {
                            ["bleeding","debuff",300] spawn MPClient_fnc_addBuff;
                            [_unit, 20] call life_fnc_enterCombat;
                        };
                        case (_damage > 0.3 && _damage <= 0.45) : {
                            ["painShock","debuff"] spawn MPClient_fnc_addBuff;
                            [_unit, 30] call life_fnc_enterCombat;
                        };
                        case (_damage > 0.45 && _damage <= 0.9) : {
                           ["critHit","debuff"] spawn MPClient_fnc_addBuff;
                           [_unit, 45] call life_fnc_enterCombat;
                        };
                        default {
                            [_unit, 10] call life_fnc_enterCombat;
                        }; 
                    };
                };
            };
        };
    };
} else {
	_damage = _currentDmg;
};

_damage