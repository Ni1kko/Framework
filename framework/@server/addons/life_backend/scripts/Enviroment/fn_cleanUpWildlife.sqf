#include "\life_backend\serverDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
	## fn_cleanUpWildlife.sqf
*/

private _wildlife = [false] call MPServer_fnc_getWildlife;
if(count _wildlife > 0)then{
	
	//-- Remove animals that over 350m away from a player only
	{
		private _pos = getPos _x;
		if(({(_x distance2D _pos) < 350} count playableUnits) > 0)then{
			_wildlife deleteAt _forEachIndex;
		}else{
			/*Disabled, Handled client side due to Transfer of AI structures is not supported
				
				private _agents = _x getVariable ["agents", []];
				if(count _agents > 0)	then{
					{
						_wildlife pushBackUnique _x;
					}forEach _agents;
				};
			*/
		}
	}forEach playableUnits;

	[_wildlife,true] call MPServer_fnc_deleteWildlife;
};

true