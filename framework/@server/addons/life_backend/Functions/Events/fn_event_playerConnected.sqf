/*
	## Nikko Renolds
	## https://github.com/Ni1kko/Framework
*/

if(!canSuspend)exitWith{_this spawn life_fnc_event_playerConnected};

params [
    ["_directPlayID",-100,[0]],		    // Number - is the unique DirectPlay ID. Quite useless as the number is too big for in-built string representation and gets rounded. It is also the same id used for user placed markers.
    ["_steamID","",[""]],				// String - is getPlayerUID of the joining player. In Arma 3 it is also the same as Steam ID.
    ["_name","",[""]],		   			// String - is profileName of the joining player.
    ["_didJIP",false,[false]], 			// Boolean - is a flag that indicates whether or not the player joined after the mission has started (Joined In Progress). true when the player is JIP, otherwise false. (since Arma 3 v1.49)
    ["_ownerID",-100,[0]],	   			// Number - is owner id of the joining player. Can be used for kick or ban purposes or just for publicVariableClient. (since Arma 3 v1.49) 
    ["_directPlayIDStr","",[""]],		// String - same as _id but in string format, so could be exactly compared to user marker ids. (since Arma 3 v1.95) 
    ["_customArgs",[]] 		            // User-Defined - custom passed args (since Arma 3 v2.03) 
];

waitUntil {!isNil "life_var_serverLoaded" AND !isNil "life_var_rcon_serverLocked"};

private _totalPlayerCount = count allPlayers;

//--- Rcon boot
if(life_var_rcon_serverLocked)exitWith{ 
	[_ownerID,"Joined before server unlocked"] call life_fnc_rcon_kick;
};

//--- Update max players
if(_totalPlayerCount > life_var_serverMaxPlayers)then{
	life_var_serverMaxPlayers = _totalPlayerCount;
	["UPDATE", "servers", [
		[//What
			["maxplayercount", ["DB","INT", life_var_serverMaxPlayers] call life_fnc_database_parse]
		],
		[//Where
			["serverID", ["DB","INT", (call life_var_serverID)] call life_fnc_database_parse]
		]
	]]call life_fnc_database_request;
};