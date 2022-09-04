#include "..\..\script_macros.hpp"
/*
    File: fn_restrainAction.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Restrains the target.
*/
private ["_unit"];
_unit = cursorObject;
if (isNull _unit) exitWith {}; //Not valid
if (player distance _unit > 3) exitWith {};
if (_unit getVariable "restrained") exitWith {};
if (side _unit isEqualTo west) exitWith {};
if (player isEqualTo _unit) exitWith {};
if (!isPlayer _unit) exitWith {};
//

private _civilianArrest = (playerSide isEqualTo civilian AND not(license_civ_bounty));

if((playerSide == west OR license_civ_bounty) AND not(_civilianArrest)) then {
	//-- Cuffs sound
    [_unit,"cuffson",50,1] remoteExec ["life_fnc_say3D",0];
	//-- Broadcast
    [0,"STR_NOTF_Restrained",true,[_unit getVariable ["realname", name _unit], profileName]] remoteExecCall ["life_fnc_broadcast",west];
}else{
    //-- ZipTie sound
    [_unit,"zipTie",20,1] remoteExec ["life_fnc_say3D",0];
    //-- Broadcast
    [0,"STR_NOTF_Ziptied",true,[_unit getVariable ["realname", name _unit], profileName]] remoteExecCall ["life_fnc_broadcast",-2];
};

_unit setVariable ["playerSurrender",false,true];
_unit setVariable ["restrained",true,true];
_unit setVariable ["civrestrained",_civilianArrest,true]; 

[player,license_civ_bounty] remoteExec ["life_fnc_restrain",_unit];

true
