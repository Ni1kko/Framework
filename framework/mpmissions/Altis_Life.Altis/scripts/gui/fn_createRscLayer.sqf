/*

	Function: 	MPClient_fnc_createRscLayer
	Project: 	AsYetUntitled
	Author:     Tonic, Merrick, Nikko, Affect & IceEagle132
	Github:		https://github.com/Ni1kko/FrameworkV2
	
*/

params [
	["_resource","",[""]],
	["_type","PLAIN",[""]],
	["_speed",0,[0]],
	["_showOnMap",false,[false]]
];

if ([_resource] call MPClient_fnc_hasDisplay) then {
	[_resource] call MPClient_fnc_destroyRscLayer;
};

(_resource call BIS_fnc_rscLayer) cutRsc [_resource,_type,_speed,_showOnMap];

true