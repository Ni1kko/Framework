/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

private _victim = [_this,0,ObjNull,[ObjNull]] call BIS_fnc_param;

//-- Check if the victim is a alive
if(isNull _victim || !alive _victim) exitWith {false};

//-- Check if player is a bounty hunter
if(!license_civ_bountyHunter || playerSide isNotEqualTo civilian) exitWith {false};

//--- Check distance
if(_victim distance player > 50) exitWith {false};

//--- Taze the player
[_victim,player] remoteExec ["MPClient_fnc_bountyHunterTaze",owner _victim];

//--- 
true