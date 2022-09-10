/*

	Function: 	MPClient_fnc_destroyRscLayer
	Project: 	AsYetUntitled
	Author:     Tonic, Merrick, Nikko, Affect & IceEagle132
	Github:		https://github.com/Ni1kko/FrameworkV2
	
*/

private _resource = param [0,"",[""]];

(_resource call BIS_fnc_rscLayer) cutText ["","PLAIN"];