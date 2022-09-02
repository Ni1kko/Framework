/*
	## Nikko Renolds
	## https://github.com/Ni1kko/Framework
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