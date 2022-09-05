#include "\life_backend\script_macros.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/Framework

	## Sole purpose of this system is to allow remote exec without being connected to the server.
	## Example you get a DM on forums and you want to send a message to the player, you can do that with this system.
*/

private _queryRemoteExec = ["READ", "remote_exec", 
	[
		["jobID", "expression", "targets"],
		[
			["completed", ["DB","BOOL", false] call life_fnc_database_parse],
			["serverID",["DB","INT",call life_var_serverID] call life_fnc_database_parse]
		]
	]
] call life_fnc_database_request;

if(count _queryRemoteExec > 0)then
{
	["CALL", "completeRemoteExecRequests"] call life_fnc_database_request;

	{
		_x params ["_jobID", "_expression", "_targets"];

		private _params = [];
		private _code = compile _expression;

		if(_targets isEqualTo SIDE_TARGET_SERVERS)then{
			_params spawn _code;
		}else{
			private _target = switch (_targets) do {
				case SIDE_TARGET_COP: {west};
				case SIDE_TARGET_REB: {east}; 
				case SIDE_TARGET_MED: {independent};
				case SIDE_TARGET_CIV: {civilian};
				default {_targets};
			};

			[_params,_code] remoteExec ["spawn",_target];
		};
	}forEach _queryRemoteExec;
};

true
