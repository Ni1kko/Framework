#include "\life_backend\serverDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

private _npcs = (allUnits apply {if(isPlayer _x)then{""}else{_x}}) - [""];

if(count _npcs > 0)then
{
    {
        [_x] params ["_npc"];
        if (not(_x getVariable ["Scripted",false])) then {
            {
                [_x] params ["_weaponName"];
                if (_weaponName isNotEqualTo "") then {
                    _npc removeWeapon _weaponName;
                };
            } forEach [
                primaryWeapon _npc,
                secondaryWeapon _npc,
                handgunWeapon _npc
            ];
        };
    } forEach _npcs;
};