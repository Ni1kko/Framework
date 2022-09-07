/*
	## Nikko Renolds
	## https://github.com/Ni1kko/Framework
*/

disableSerialization;

private _display = createDialog ["life_spawn_selection",true];
private _listBox = _display displayCtrl 38510;
private _configSpawnPoints = [playerSide] call MPClient_fnc_spawnPointCfg;
life_spawn_point = _configSpawnPoints#0; //First option is set by default

_display displaySetEventHandler ["keyDown","_this call MPClient_fnc_displayHandler"];

{
    _listBox lnbAddRow[(_configSpawnPoints#_ForEachIndex)#1,(_configSpawnPoints#_ForEachIndex)#0,""];
    _listBox lnbSetPicture[[_ForEachIndex,0],(_configSpawnPoints#_ForEachIndex)#2];
    _listBox lnbSetData[[_ForEachIndex,0],(_configSpawnPoints#_ForEachIndex)#0];
} forEach _configSpawnPoints;

life_spawn_point param [
    ["_SpawnMarker",""],
    ["_SpawnName",""]
];

[_display displayCtrl 38502,1,0.1,getMarkerPos _SpawnMarker] call MPClient_fnc_setMapPosition;

ctrlSetText[38501,format ["%2: %1",_SpawnName,localize "STR_Spawn_CSP"]];

_display