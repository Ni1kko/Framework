/*
	## Nikko Renolds
	## https://github.com/Ni1kko/Framework
*/

params [
	["_type",selectRandom ["Land_Campfire_F", "Campfire_burning_F","Land_TentA_F","Land_TentDome_F"]]
]; 

private _position = getPos player;
private _result = ["Are you sure you wish too deploy tent here?", "Deploy Tent", true, true] call BIS_fnc_guiMessage;

if (_result) then {
	//-- Remove tentkit from player vinventory
	[false,"tentKit",1] call MPClient_fnc_handleInv;
	//--
	[player,_type,_position] remoteExec ["MPServer_fnc_tents_buildRequest",2];
} else {
	systemChat "Tent depolyment aborted.";
};

true