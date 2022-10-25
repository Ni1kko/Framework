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

//-- Wildlife client patch
[]spawn {
    scriptName 'MPClient_fnc_wildlifePatch';
    waitUntil {not(isNil "life_var_animalTypesRestricted")}; 
    while {not(isNull(uiNamespace getVariable ["RscDisplayMission",findDisplay 46]))} do
    {
        waitUntil {count agents > 0}; 
        waitUntil {
            //player setVariable ["agents", agents, true]; // Transfer of AI structures is not supported.. FIND A NEW WAY
            {
                private _agent = agent _x;
                private _agentType = toLower(typeOf _agent);
                //-- Right this mofo is fucking spawned client side and is not synced to the server.
                if(local _agent)then{
                    //-- Not Restricted fuck it delete it CBA anymore
                    if not(_agentType in life_var_animalTypesRestricted)then{
                        deleteVehicle _agent;
                    };
                };
            }forEach agents;
            sleep 3;
            count agents == 0
        };
    };
};

//--
"ColorCorrections" ppEffectEnable true;  
"ColorCorrections" ppEffectAdjust [0.88, 0.88, 0, [0.2, 0.29, 0.4, -0.22], [1, 1, 1, 1.3], [0.15, 0.09, 0.09, 0.0]]; 
"ColorCorrections" ppEffectCommit 0;

[format["Client postInit completed! Took %1 seconds",diag_tickTime - (call life_var_postInitTime)]] call MPClient_fnc_log;

true