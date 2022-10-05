/*

	Function: 	MPClient_fnc_spit
	Project: 	AsYetUntitled/Framework
	Author:     Nikko
	Github:		https://github.com/Ni1kko/FrameworkV2
	
*/

//get target
private _target = cursorObject;
if(isNull _target)exitWith {hint 'you need to look at player to spit on them'};

//check target is vaild player
private _targetSteamID = getPlayerUID _target;
if(_targetSteamID == "")exitWith {hint 'cant spit here'};

//check targetID is vaild slot (4 & above is players)
private _targetID = owner _target;
if(_targetID < 4)exitWith {hint 'cant spit on this sorry no way'};

//get  config
private _spitConfig = missionConfigFile >> "cfgMaster" >> "spitting";  
private _spitDistance = [_spitConfig, "distance", 10]call BIS_fnc_returnConfigEntry;

//check target distance
private _targetDistance = _target distance2D player;
if(_targetDistance > _spitDistance)exitWith {hint 'you cant spit that far get closer'};

//Do spit action-effect on target
[player, _targetDistance] remoteExec ["MPClient_fnc_spat",_targetID];