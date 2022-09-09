/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

//"some message" call MPServer_fnc_rcon_sendBroadcast
if(!isServer)exitwith{false};

params [
	["_message","",[""]]
];

if(count _message < 3)exitwith{false};

if(isNil "life_var_rcon_messagequeue")then{
	life_var_rcon_messagequeue = [];
};

reverse life_var_rcon_messagequeue;
life_var_rcon_messagequeue pushBackUnique _message;
reverse life_var_rcon_messagequeue;

private _queuePos = life_var_rcon_messagequeue find _message;

_queuePos