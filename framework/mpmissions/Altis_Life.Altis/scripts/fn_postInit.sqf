#include "..\clientDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

RUN_CLIENT_ONLY;
FORCE_SUSPEND("MPClient_fnc_postInit");
AH_CHECK_FINAL("life_var_postInitTime");

waitUntil {isFinal "life_var_preInitTime"};

life_var_postInitTime = compileFinal str(diag_tickTime);
 
["Loading client postInit"] call MPClient_fnc_log;

//-- Radio channels patch
{
    _x params [
		["_channelID",-1,[0]], 
		["_noText","false",[""]], 
		["_noVoice","false",[""]]
	];

    _channelID enableChannel [
		not([false,true] select ((["false","true"] find toLower _noText) max 0)), 
		not([false,true] select ((["false","true"] find toLower _noVoice) max 0))
	];
} forEach getArray (missionConfigFile >> "disableChannels");

//--- Disable saving.
enableSaving [false, false];

//--- Disable some features of the ArmA engine.
enableRadio false; //--- Radio messages
enableSentences false; //--- Radio messages
enableEnvironment false; //--- Environment
disableRemoteSensors true; //--- Raycasting

//-- Texture patch
[] spawn MPClient_fnc_playerTextures;

//-- Wildlife patch to delete un-needed animals
[] spawn MPClient_fnc_deleteWildlife;

[format["Client preInit completed! Took %1 seconds",diag_tickTime - (call life_var_postInitTime)]] call MPClient_fnc_log;

true