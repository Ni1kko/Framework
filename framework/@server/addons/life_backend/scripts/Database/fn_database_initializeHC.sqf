#include "\life_backend\script_macros.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

if(!isServer)exitwith{false};

private _headlessclients = getArray(configFile >> "CfgExtDB" >> "headlessclients");

if(count _headlessclients >= 1)exitWith
{
	//--- Setup HC Connection Eventhandler
	extdb_var_database_headless_clientconnected = addMissionEventHandler [
		'PlayerConnected',
		{
			params [
				["_directPlayID",-100,[0]],		    // Number - is the unique DirectPlay ID. Quite useless as the number is too big for in-built string representation and gets rounded. It is also the same id used for user placed markers.
				["_steamID","",[""]],				// String - is getPlayerUID of the joining player. In Arma 3 it is also the same as Steam ID.
				["_name","",[""]],		   			// String - is profileName of the joining player.
				["_didJIP",false,[false]], 			// Boolean - is a flag that indicates whether or not the player joined after the mission has started (Joined In Progress). true when the player is JIP, otherwise false. (since Arma 3 v1.49)
				["_ownerID",-100,[0]],	   			// Number - is owner id of the joining player. Can be used for kick or ban purposes or just for publicVariableClient. (since Arma 3 v1.49) 
				["_directPlayIDStr","",[""]],		// String - same as _id but in string format, so could be exactly compared to user marker ids. (since Arma 3 v1.95) 
				["_headlessClients",[]] 		    // User-Defined - custom passed args (since Arma 3 v2.03) 
			];

			private _isHeadless = _steamID in _headlessClients;

			if !(_isHeadless)exitWith{true};

			//add hc to server array
			format["Headless client [%1] avaliable", _steamID] call MPServer_fnc_database_systemlog;
			extdb_var_database_headless_clients pushBackUnique [_steamID,_ownerID];
			publicVariable "extdb_var_database_headless_clients";

			//have every client assigned a random HC from server array
			private _var = format ["extdb_var_headless_%1_JIP",_steamID]; 
			private _jip = ["",{
				waitUntil{!isNil "extdb_var_database_headless_clients"};
				extdb_var_database_headless_client = (selectRandom extdb_var_database_headless_clients)#1;
			}] remoteExec ["spawn",0,true];
			missionNamespace setVariable [_var,_jip,true];
		},
		_headlessclients
	];

	//--- Setup HC Disconnection Eventhandler
	extdb_var_database_headless_clientdisconnected = addMissionEventHandler [
		"PlayerDisconnected",
		{
			params [
				["_directPlayID",-100,[0]],		    // Number - is the unique DirectPlay ID. Quite useless as the number is too big for in-built string representation and gets rounded. It is also the same id used for user placed markers.
				["_steamID","",[""]],				// String - is getPlayerUID of the joining player. In Arma 3 it is also the same as Steam ID.
				["_name","",[""]],		   			// String - is profileName of the joining player.
				["_didJIP",false,[false]], 			// Boolean - is a flag that indicates whether or not the player joined after the mission has started (Joined In Progress). true when the player is JIP, otherwise false. (since Arma 3 v1.49)
				["_ownerID",-100,[0]],	   			// Number - is owner id of the joining player. Can be used for kick or ban purposes or just for publicVariableClient. (since Arma 3 v1.49) 
				["_directPlayIDStr","",[""]],		// String - same as _id but in string format, so could be exactly compared to user marker ids. (since Arma 3 v1.95) 
				["_headlessClients",[]] 		    // User-Defined - custom passed args (since Arma 3 v2.03) 
			];

			private _isHeadless = _steamID in _headlessClients;

			if !(_isHeadless)exitWith{true};
			format["Headless client [%1] left (OR) lost connection. HC is no longer avaliable", _steamID] call MPServer_fnc_database_systemlog;

			private _var = format ["extdb_var_headless_%1_JIP",_steamID]; 
			private _jip = missionNamespace getVariable [_var,-100];
			remoteExec ["",_jip];

			missionNamespace setVariable [_var,nil,true];

			private _index = extdb_var_database_headless_clients find [_steamID,_ownerID];
			if(_index isNotEqualTo -1)then{
				extdb_var_database_headless_clients deleteAt _index;
				publicVariable "extdb_var_database_headless_clients";
			};
		},
		_headlessclients
	];

	//--- Log
	{
		format["Waiting for headless client [%1] to connect", _x] call MPServer_fnc_database_systemlog;
	} forEach _headlessclients;

	true
};

"No headless clients defined" call MPServer_fnc_database_systemlog;

false