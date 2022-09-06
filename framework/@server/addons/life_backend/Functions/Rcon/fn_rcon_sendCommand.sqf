/*
	## Nikko Renolds
	## https://github.com/Ni1kko/Framework
*/

if(!isServer)exitwith{false};
if(isNil "life_var_rcon_passwordOK")exitwith{false};

params [
	["_command","",[""]]
];

private _return = false;
private _password = getText(configFile >> "CfgRCON" >> "serverPassword");
private _init = ("#init/" in _command);
private _conlog = ("#debug " in _command);

if(_password isEqualTo "")then{_password = "empty";};
if(!life_var_rcon_passwordOK AND !_init)exitwith{_password=nil;_return};
if (!life_var_rcon_passwordOK AND _init)then{
	_command = "#exec users";
	format["Sending Command: %1",_command] call MPServer_fnc_rcon_systemlog;
	if (_password serverCommand _command AND (serverCommandAvailable "#lock"))then{
		_command = "#lock";
		life_var_rcon_passwordOK = true;
		publicVariable "life_var_rcon_passwordOK";
	}else{
		"ServerPassword MISMATCH!!! RCON features DISABLED!" call MPServer_fnc_rcon_systemlog;
	};
};

if(_command in ["#lock","#unlock"])then{
	if("#lock" isEqualTo _command)then{
		life_var_rcon_serverLocked = true;
	}else{ 
		life_var_rcon_serverLocked = false;
	};
	publicVariable "life_var_rcon_serverLocked";
};

if(life_var_rcon_passwordOK AND _command isNotEqualTo "")then{
	if (!_conlog)then{format["Sending Command: %1",_command] call MPServer_fnc_rcon_systemlog;};
	_return = _password serverCommand _command;
};

_password=nil;

_return