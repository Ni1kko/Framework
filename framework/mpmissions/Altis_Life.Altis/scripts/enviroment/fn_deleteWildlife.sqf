#include "..\clientDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
	## fn_deleteWildlife.sqf
*/

if(count(localNamespace getVariable ["MPClient_var_animalTypes",[]]) isEqualTo 0) exitWith {
	["`fn_deleteWildlife.sqf` script disabled, no type(s) defined"] call MPClient_fnc_log;
	false
};

while {not(isNull(uiNamespace getVariable ["RscDisplayMission",findDisplay 46]))} do
{ 
	private _wildlife = [] call MPClient_fnc_getWildlife;
	if(count _wildlife > 0)then
	{
		while {({not(isNull _x)} count _wildlife) > 0} do 
		{
			{
				private _animal = _x;
				if(not(isHidden _animal)) then {_animal hideObjectGlobal true};
				if(alive _animal) then {_animal setDamage 1};
				if(not(isNull _animal)) then {deleteVehicle _animal};
				if(isNull _animal) then {_wildlife deleteAt _forEachIndex};
			}forEach _wildlife;
		};

		private _lastPos = getPos player;
		private _lastCheck = diag_tickTime;

		waitUntil {
			uiSleep 1;
			_lastCheck + 2 <= diag_tickTime OR _lastPos distance2D (getPos player) > 15
		};
	}else{
		waitUntil {
			uiSleep 2.5;
			count ([] call MPClient_fnc_getWildlife) > 0
		};
	};
};

true