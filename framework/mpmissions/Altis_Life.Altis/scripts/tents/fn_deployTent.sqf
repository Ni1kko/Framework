/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

params [
	["_type",selectRandom ["Land_Campfire_F", "Campfire_burning_F","Land_TentA_F","Land_TentDome_F"]]
]; 

private _position = getPos player;
private _result = ["Are you sure you wish too deploy tent here?", "Deploy Tent", true, true] call BIS_fnc_guiMessage;

if (_result) then {
	//-- Remove tentkit from player vinventory
	["USE","tentKit",1] call MPClient_fnc_handleVitrualItem;
	//--
	[player,_type,_position] remoteExec ["MPServer_fnc_tents_buildRequest",2];
} else {
	systemChat "Tent depolyment aborted.";
};

true