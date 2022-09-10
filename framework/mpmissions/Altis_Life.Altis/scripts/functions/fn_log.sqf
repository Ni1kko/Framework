/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

params [ 
	["_contents","",[""]], 
	["_client",true,[false]],
	["_server",false,[false]],
];

if(count _contents isEqualTo 0) exitWith {false};
if(not(_client) AND not(_server)) exitWith {false};

if _client then{
	diag_log format ["[MPClient] %1",_contents];
};

if (_server AND !isRemoteExecuted) then{
	[format ["(Client-%1-log): %2",getPlayerUid player,_contents]] remoteExecCall ["MPServer_fnc_log",2];
};

true