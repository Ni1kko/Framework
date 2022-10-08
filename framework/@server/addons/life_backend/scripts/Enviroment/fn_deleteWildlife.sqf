#include "\life_backend\serverDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
	## fn_deleteWildlife.sqf
*/

params [
	["_wildlife", [], [objNull,[]]]
];

private _singleReturn = false;

if(typeName _animal isEqualTo "OBJECT")then{
	_singleReturn = true;
	_wildlife = [_wildlife];
};

if(count _wildlife > 0)then
{
	while {({not(isNull _x)} count _wildlife) > 0} do 
	{
		{
			private _animal = [_x] param [
				[0, teamMemberNull, [teamMemberNull, objNull]]
			];

			if(typeName _animal isNotEqualTo "OBJECT")then{_animal = agent _animal};
			if(not(isHidden _animal)) then {_animal hideObjectGlobal true};
			if(alive _animal) then {_animal setDamage 1};
			if(not(isNull _animal)) then {deleteVehicle _animal};
			if(isNull _animal) then {_wildlife deleteAt _forEachIndex};
		}forEach _wildlife;
	};
};

[_wildlife,[_wildlife] call BIS_fnc_arrayShift] select _singleReturn;