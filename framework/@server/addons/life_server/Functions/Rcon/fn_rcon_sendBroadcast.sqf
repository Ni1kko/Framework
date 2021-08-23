/*
	## Nikko Renolds
	## https://github.com/Ni1kko/Framework
*/

//"some message" call life_fnc_rcon_sendBroadcast

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