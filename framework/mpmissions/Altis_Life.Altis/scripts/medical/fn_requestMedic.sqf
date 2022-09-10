/*

	Function: 	MPClient_fnc_requestMedic
	Project: 	AsYetUntitled
	Author:     Tonic, Merrick, Nikko, Affect & IceEagle132
	Github:		https://github.com/Ni1kko/FrameworkV2
	
*/


if (life_var_medicstatus >= 0) exitWith {titleText["You have already sent a request","PLAIN"]};

[player,player getVariable ["realname",""]] remoteExecCall ["MPClient_fnc_medicRequest",if (playersNumber east > 0) then {east} else {west}];

life_var_medicstatus = 0;
player setVariable ["medicStatus",life_var_medicstatus,true];
player setVariable ["Revive",false,true];