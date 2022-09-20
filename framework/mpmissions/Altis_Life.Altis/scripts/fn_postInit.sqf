/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

if !(hasInterface)exitWith{false};
if !(canSuspend)exitWith{_this spawn MPClient_fnc_postInit; false};
if (isFinal "life_var_postInitTime")exitWith{
    ["Hack Detected", "`life_var_postInitTime` already final, Client looping or hacker detected", "Antihack"] call MPClient_fnc_endMission;
    false;
};

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

//-- Exploit patch
[] spawn {
    for "_i" from 0 to 1 step 0 do 
	{
        waitUntil {(!isNull (findDisplay 49)) && {(!isNull (findDisplay 602))}}; // Check if Inventory and ESC dialogs are open
        (findDisplay 49) closeDisplay 2; // Close ESC dialog
        (findDisplay 602) closeDisplay 2; // Close Inventory dialog
    };
};

//-- Texture patch
[] spawn MPClient_fnc_playerTextures;

[format["Client preInit completed! Took %1 seconds",diag_tickTime - (call life_var_postInitTime)]] call MPClient_fnc_log;

true