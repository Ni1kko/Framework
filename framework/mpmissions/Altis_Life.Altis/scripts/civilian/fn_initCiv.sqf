/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/
params [
	["_player",objNull,[objNull]],
	["_exitCode",{},[{}]]
];

private _altisArray = ["Land_i_Shop_01_V1_F","Land_i_Shop_01_V2_F","Land_i_Shop_01_V3_F","Land_i_Shop_02_V1_F","Land_i_Shop_02_V2_F","Land_i_Shop_02_V3_F"];
private _tanoaArray = ["Land_House_Small_01_F"];
private _spawnBuildings = [[["Altis", _altisArray], ["Tanoa", _tanoaArray]]] call MPServer_fnc_terrainSort;

for "_i" from 1 to 4 do {
    private _var = format ["civ_spawn_%1", _i];
    missionNamespace setVariable [_var,nearestObjects[getMarkerPos _var, _spawnBuildings,350]];
};

true