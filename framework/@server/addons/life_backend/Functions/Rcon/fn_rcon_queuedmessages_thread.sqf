/*
	## Nikko Renolds
	## https://github.com/Ni1kko/Framework
*/

if(!isServer)exitwith{false};
if(isRemoteExecuted)exitwith{false};

while {true} do {
	if(count life_var_rcon_messagequeue > 0)then{
		//--- Send queued messages
		{
			//--- broadcast queued message
			format["#beserver Say -1 %1",_x] call MPServer_fnc_rcon_sendCommand;
			
			//--- remove from queue
			life_var_rcon_messagequeue deleteAt _forEachIndex;
		} forEach life_var_rcon_messagequeue;
	};
	uiSleep 5;
};