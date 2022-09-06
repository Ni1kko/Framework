/*
	## Nikko Renolds
	## https://github.com/Ni1kko/Framework
*/

[
    getNumber(_lifeConfig >> "federalReserve_resetAfterRestart") isEqualTo 1,
    getNumber(_lifeConfig >> "federalReserve_startGold"),
    getNumber(_lifeConfig >> "federalReserve_MaxGold"),
    getNumber(_lifeConfig >> "federalReserve_AddMoreEvery"),
    getNumber(_lifeConfig >> "federalReserve_AddMin"),
    getNumber(_lifeConfig >> "federalReserve_AddMid"),
    getNumber(_lifeConfig >> "federalReserve_AddMax")
] params [
    ["_resetAfterRestart",false],
    ["_startGold",0],
    ["_maxGold",0],
    ["_addMoreEvery",0],
    ["_addMin",0],
    ["_addMid",0],
    ["_addMax",0]
];

private _masterGroup = missionNamespace getVariable ["master_group",objNull];
private _bankObject = missionNamespace getVariable ["bank_obj",objNull];
private _vaultObject = missionNamespace getVariable ["fed_bank",objNull];
private _vaultHouse = [[["Altis", "Land_Research_house_V1_F"], ["Tanoa", "Land_Medevac_house_V1_F"]]] call life_fnc_terrainSort;
private _pos = [[["Altis", [16019.5,16952.9,0]], ["Tanoa", [11074.2,11501.5,0.00137329]]]] call life_fnc_terrainSort;
private _dome = nearestObject [_pos,"Land_Dome_Big_F"];
private _rsb = nearestObject [_pos,_vaultHouse];
private _lifeConfig = missionConfigFile >> "Life_Settings";
private _allBanks = [
	["RBA International Reserve", [15288.7,17472.8,-0.224236], "Land_MilOffices_V1_F"],
	["AR Weapon Cache", [3268.73,12470.8,-0.043025], "Land_i_Barracks_V2_F"]
];
private _allATMs = [

];

//-- Setup banks
_masterGroup attachTo[_bankObject,[0,0,0]];
{
	private _name = _x select 0;
	private _pos = _x select 1;
	private _classname = _x select 2;

	private _target = nearestObjects[_pos, [_classname], 10];

	if(count _target > 0) then {
		private _bankBuilding = _target select 0;
		_bankBuilding setVariable["isBank", true, true];
		_bankBuilding setVariable["bankName", _name, true];
	
		life_var_banks pushBack [_name,_bankBuilding];

		private _doors = getNumber(configFile >> "CfgVehicles" >> (_classname) >> "NumberOfDoors");
		for "_i" from 1 to _doors do {
			_bankBuilding setVariable[format["bis_disabled_Door_%1",_i],1,true];
			_bankBuilding animate [format["door_%1_rot",_i],0];
		};

		private _bankMark = createMarker [format["Bank_%1_Marker", str _pos],_pos];
		_bankMark setMarkerType "c_unknown";
		_bankMark setMarkerPos _pos;
		_bankMark setMarkerSize [1,1];
		_bankMark setMarkerText _name;
		_bankMark setMarkerColor "ColorGreen";

		_bankBuilding setVariable["bankMarker", _bankMark, true];

		private _bankContainers = [];

		switch (typeOf _bankBuilding) do {
			case "Land_i_Barracks_V2_F":
			{
				_bankBuilding setVariable["bankBlocked",[3,4,5,6,7,8,9,12,13,14,15,16,21,22], true];

				private _allTables = [
					[[-6.29346,2.97852,-0.0245633],91.2279],
					[[-13.29346,2.97852,-0.0245633],91.2279],
					[[-13.29346,2.97852,3.3245633],91.2279],
					[[-6.29346,2.97852,3.3345633],91.2279],
					[[1.3,2.97852,3.3345633],91.2279],
					[[2.3,2.97852,3.3345633],91.2279],
					[[2.3,-2.9,3.3345633],91.2279]
				];

				{	
					private _v = "OfficeTable_01_new_F" createVehicle [0,0,0]; 
					_v enableSimulation false;
					_v allowDamage false; 
					_pos = _bankBuilding modelToWorld (_x select 0);
					_v setPos [_pos select 0, _pos select 1, (_pos select 2) + .45];
					_v setDir (direction _bankBuilding + (_x select 1));
					_bankContainers pushBack _v;
					private _piles = [];
					
					_m = "Land_WoodenBox_F" createVehicle [0,0,0];
					_m enableSimulation false;
					_m allowDamage false;
					_m setVariable["bankItem",true,true];
					_m attachTo[_v, [0,0,.35]];
					_piles pushBack [[0,0,.35], _m, "Land_WoodenBox_F"];
					
					_v setVariable["bankItemPiles", _piles];
				} forEach _allTables;
			};

			case "Land_MilOffices_V1_F":
			{
				private _allShelves = [
					[[16.8545,10.7559,-3.31048],88.7266],
					[[16.8545,7.7559,-3.31048],88.7266],
					[[10.8545,4.6,-3.31048],-1.04743]
				];

				{	
					private _v = "Land_Metal_wooden_rack_F" createVehicle [0,0,0]; 
					_v enableSimulation false;
					_v allowDamage false; 
					_pos = _bankBuilding modelToWorld (_x select 0);
					_v setPos [_pos select 0, _pos select 1, (_pos select 2) + .45];
					_v setDir (direction _bankBuilding + (_x select 1));
					_bankContainers pushBack _v;

					private _piles = [];
					
					{
						_m = "Land_Money_F" createVehicle [0,0,0];
						_m enableSimulation false;
						_m allowDamage false;
						_m setVariable["bankItem",true,true];
						_m attachTo[_v, _x];
						_piles pushBack [_x, _m, "Land_Money_F"];
					} forEach [
						[0.3,0,0.62],
						[-0.3,0,0.62],
						[0.3,0,0.1],
						[-0.3,0,0.1],
						[0.3,0,-0.38],
						[-0.3,0,-0.38],
						[0.3,0,-0.89],
						[-0.3,0,-0.89]
					];
					
					_v setVariable["bankItemPiles", _piles];
				} forEach _allShelves;

			};
		};

		_bankBuilding setVariable["bankContainers", _bankContainers];
	};

} forEach _allBanks;
publicVariable "life_var_banks";


//--- life_var_atms  
{
	
}forEach _allATMs;
publicVariable "life_var_atms";

//-- Setup federal reserve
for "_i" from 1 to 3 do {_dome setVariable [format ["bis_disabled_Door_%1",_i],1,true]; _dome animateSource [format ["Door_%1_source", _i], 0];};
_dome setVariable ["locked",true,true];
_rsb setVariable ["locked",true,true];
_rsb setVariable ["bis_disabled_Door_1",1,true];
_dome allowDamage false;
_rsb allowDamage false;

if _resetAfterRestart then{
    ["CALL", "resetFedVault"]call life_fnc_database_request;
}else{
    private _queryRes = ["READ", "servers",[["vault"],[["serverID",["DB","INT",call life_var_serverID] call life_fnc_database_parse]]],true] call life_fnc_database_request;

    private _vault = ["GAME","INT",_queryRes param [0, 0]] call life_fnc_database_parse;

    if(_vault > 0)then{
        _startGold = _vault;
    };
};

_vaultObject setVariable ["safe",_startGold,true];

//--- Make sure database is alive for accses to bank data
waitUntil {isFinal "extdb_var_database_key"};
life_var_banksReady = compileFinal str(true);
publicVariable "life_var_banksReady";

true