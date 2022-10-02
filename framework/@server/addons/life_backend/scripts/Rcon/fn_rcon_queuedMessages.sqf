#include "\life_backend\script_macros.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

if !(isFinal "life_var_rcon_inittime")exitwith{false}; 
if (count life_var_rcon_messagequeue > 0)exitwith{false}; 

//--- Send queued messages
{
	//--- broadcast queued message
	format["#beserver Say -1 %1",_x] call MPServer_fnc_rcon_sendCommand;
	
	//--- remove from queue
	life_var_rcon_messagequeue deleteAt _forEachIndex;
} forEach life_var_rcon_messagequeue;

true