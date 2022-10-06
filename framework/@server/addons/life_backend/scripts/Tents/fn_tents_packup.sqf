#include "\life_backend\serverDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

params [
	["_tent",objNull,[objNull]]
];

if(isNull _tent)exitWith {false};

//-- delete attachedObjects
{
	{deleteVehicle _x} forEach (attachedObjects _x);
	deleteVehicle _x;
} forEach (attachedObjects _tent);

//-- delete from world
deleteVehicle _tent;

true