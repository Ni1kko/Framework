#include "..\script_macros.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/Framework
*/

params [
    ["_alive", false, [false]],
    ["_position", [], [[]]]
];

private _openSpawnMenu = false;
private _spawnAtPosition = false;

if(playerSide in [civilian,east]) then 
{
	switch (true) do 
	{
		//-- Put them back in jail as they logged off in jail.
		case (life_is_arrested): 
		{
            life_is_arrested = false;
            [player,true] spawn MPClient_fnc_jail;
        };
		//-- Reset loadout logged off during combat (combat logged).
		case (life_firstSpawn AND not(life_is_alive) AND not(life_is_arrested)): 
		{
            //-- Comabt logged
			if (LIFE_SETTINGS(getNumber,"save_civilian_positionStrict") isEqualTo 1) then {
				[] call MPClient_fnc_startLoadout;
				life_var_cash = 0;
				[0] call MPClient_fnc_updatePartial;
			};

			_openSpawnMenu = true; 
        };
		//-- Spawn them where they logged off.
		default
		{ 
			if _alive then {
				_spawnAtPosition = true;
			} else {
				_openSpawnMenu = true;
			}; 
		};
	};
}else{
    if _alive then { 
		_spawnAtPosition = true;
    } else {
        _openSpawnMenu = true;
    }; 
};

//-- Open spawn menu
if _openSpawnMenu then
{ 
	[] call MPClient_fnc_spawnMenu;
	waitUntil{!isNull (findDisplay 38500)}; //Wait for the spawn selection to be open.
	waitUntil{isNull (findDisplay 38500)}; //Wait for the spawn selection to be done.	
}else{
	if _spawnAtPosition then {
        player setVariable ["life_var_teleported",true,true];
        player setVehiclePosition [_position, [], 0, "CAN_COLLIDE"];
        5 spawn{uiSleep _this; player setVariable ["life_var_teleported",false,true]};
	};
};

life_is_alive = true;

true