/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

params [
	["_type","",[""]],
	["_position",[],[[]]],
	["_BEGuid","",[""]],
	["_tentID",call MPServer_fnc_util_randomString],
	["_vitems",[]]
];

private _tentIndex = -1;  
private _tent = createVehicle [_type, [1.6650946,1.6626484,5], [], 0, "CAN_COLLIDE"];
private _chair = createVehicle ["Land_CampingChair_V1_F", [3.2369072,2.8136106,5], [], 0, "CAN_COLLIDE"];
private _fire = createVehicle ["Land_FirePlace_F", [2.5509803,3.8476455,5], [], 0, "CAN_COLLIDE"];
private _light = createVehicle ["Land_Camping_Light_off_F", [0.98040187,3.285964,5], [], 0, "CAN_COLLIDE"];

_tent setDir 90;
_chair attachTo [_tent];
_fire attachTo [_tent];
_light attachTo [_tent];
_tent setDir (floor (random 360));		
_tent setPos (_position);
_tent setPosATL [(getPosATL _tent) select 0, (getPosATL _tent) select 1, 0];
_chair setDir (+63.3056);
_chair setPos (getPos _chair);
_chair setPosATL [(getPosATL _chair) select 0, (getPosATL _chair) select 1, 0];
_fire setPos (getPos _fire);
_fire setPosATL [(getPosATL _fire) select 0, (getPosATL _fire) select 1, 0];
_light setPos (getPos _light);
_light setPosATL [(getPosATL _light) select 0, (getPosATL _light) select 1, 0];

_tent allowDamage false;
_chair allowDamage false;
_fire allowDamage false;
_light allowDamage false;


if(!isNull _tent)then{
	_tentIndex = life_var_allTents pushBackUnique (netId _tent);
};

if(_tentIndex isNotEqualTo -1)then{
	_tent setVariable ["BEGuid",_BEGuid,true];
	_tent setVariable ["tentID",_tentID,true];
	_tent setVariable ["vitems",_vitems,true];

	diag_log format ["Spawned Campsite #%1 - OwnerGuid: %2",_tentIndex,_BEGuid];
};

_tent