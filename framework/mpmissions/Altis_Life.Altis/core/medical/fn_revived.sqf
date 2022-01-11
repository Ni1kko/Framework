#include "..\..\script_macros.hpp"
/*

	Function: 	life_fnc_revived
	Project: 	Misty Peaks RPG
	Author:     Tonic, Merrick, Nikko, Affect & IceEagle132
	Github:		https://github.com/AsYetUntitled/Framework
	
*/

private ["_medic","_dir","_reviveCost"];
_medic = param [0,"Unknown Medic",[""]];
_reviveCost = LIFE_SETTINGS(getNumber,"revive_fee");

[life_save_gear] spawn life_fnc_loadDeadGear;

hint format [localize "STR_Medic_RevivePay",_medic,[_reviveCost] call life_fnc_numberText];

closeDialog 0;
life_deathCamera cameraEffect ["TERMINATE","BACK"];
camDestroy life_deathCamera;

//Take fee for services.
if (life_var_bank > _reviveCost) then {
    life_var_bank = life_var_bank - _reviveCost;
} else {
    life_var_bank = 0;
};

//Bring me back to life.
player setDir (getDir life_corpse);
player setPosASL (visiblePositionASL life_corpse);
life_corpse setVariable ["realname",nil,true]; //Should correct the double name sinking into the ground.
life_corpse setVariable ["Revive",nil,true];
life_corpse setVariable ["name",nil,true];
[life_corpse] remoteExecCall ["life_fnc_corpse",RANY];
deleteVehicle life_corpse;

life_action_inUse = false;
life_is_alive = true;

player setUnconscious false;
player playMoveNow "amovpercmstpsnonwnondnon";

["RscDisplayDeathScreen"] call UnionClient_system_gui_DestroyRscLayer;

player setDamage 0;

player setVariable ["medicStatus",nil,true];
player setVariable ["Revive",nil,true];
player setVariable ["name",nil,true];
player setVariable ["Reviving",nil,true];
player setVariable ["BEGuid",life_corpse getVariable "BEGuid",true];
player setVariable ["lifeState","HEALTHY",true];

[] call life_fnc_playerSkins;
[] call SOCK_fnc_updateRequest;

2 fadeSound 1;
cutText ["You come to your senses ...", "BLACK IN", 5];
uiSleep 4;