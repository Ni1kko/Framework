#include "\life_backend\serverDefines.hpp"
/*
    File: fix_headgear.sqf
    Author: pettka
    Modified by Tonic for Altis Life.

    Description:
    Randomizes a headgear form _headgear array and puts it to civilian's headgear slot upon startup of mission.
    _rnd1 is used to have some civilians without any headgear
    _rnd2 is used to determine particular headgear from array


    Parameter(s):
    None

    Returns:
    Nothing
*/

params ["_unit"];

private _headgear = [
    "H_Cap_tan","H_Cap_blk","H_Cap_blk_CMMG","H_Cap_brn_SPECOPS",  
    "H_Cap_tan_specops_US","H_Cap_khaki_specops_UK","H_Cap_red","H_Cap_grn",
    "H_Cap_blu","H_Cap_grn_BI","H_Cap_blk_Raven","H_Cap_blk_ION", "H_Bandanna_khk", 
    "H_Bandanna_sgg","H_Bandanna_cbr","H_Bandanna_gry","H_Bandanna_camo","H_Bandanna_mcamo",
    "H_Bandanna_surfer","H_Beret_blk","H_Beret_red","H_Beret_grn","H_TurbanO_blk","H_StrawHat",
    "H_StrawHat_dark","H_Hat_blue","H_Hat_brown","H_Hat_camo","H_Hat_grey","H_Hat_checker","H_Hat_tan"
];

BIS_randomSeed1 = [];
BIS_randomSeed2 = [];
_rnd1 = floor random 3;

//Hotfix patch, We don't want players getting a 'random' hat, just our NPC's
_unit setVariable ["BIS_randomSeed1",3,true];
_rnd2 = floor random (count _headgear);
_unit setVariable ["BIS_randomSeed2", _rnd2, true];

waitUntil {!(isNil {_unit getVariable "BIS_randomSeed1"})};
waitUntil {!(isNil {_unit getVariable "BIS_randomSeed2"})};

private _randomSeed1 = _unit getVariable "BIS_randomSeed1";
private _randomSeed2 = _unit getVariable "BIS_randomSeed2";

if (_randomSeed1 < 2) then {
    _unit addHeadgear (_headgear select _randomSeed2); //HEY BIS, THIS IS CARRYING A GLOBAL EFFECT, Y U DO THAT?
};

true