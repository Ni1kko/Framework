/*

	Function: 	life_fnc_createRscLayer
	Project: 	Misty Peaks RPG
	Author:     Tonic, Merrick, Nikko, Affect & IceEagle132
	Github:		https://github.com/AsYetUntitled/Framework
	
*/

params [
	["_resource","",[""]],
	["_type","PLAIN",[""]],
	["_speed",0,[0]],
	["_showOnMap",false,[false]]
];

if ([_resource] call life_fnc_hasDisplay) then {
	[_resource] call life_fnc_destroyRscLayer;
};

(_resource call BIS_fnc_rscLayer) cutRsc [_resource,_type,_speed,_showOnMap];