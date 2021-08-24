/*
    File: fn_entityRespawned.sqf
    Author: DomT602
    Description:
    Called when a player respawns (A3 respawn)
*/

params [
    ["_entity",objNull,[objNull]],
    ["_corpse",objNull,[objNull]]
];

private _uid = getPlayerUID _entity;
private _index = life_var_corpses findIf {(_x select 0) isEqualTo _uid};

if (_index isEqualTo -1) then {
    life_var_corpses pushBack [_uid,_corpse];
} else {
    life_var_corpses set [_index,[_uid,_corpse]];
};
