/*
	## Nikko Renolds
	## https://github.com/Ni1kko/Framework
*/

params [
	["_command","",[""]]
];


private _return = false;
private _password = getText(configFile >> "CfgRCON" >> "serverPassword");
private _init = ("#init/" in _command);
private _conlog = ("#debug " in _command);

if(!isServer)exitwith{_password=nil;_return};
if(isRemoteExecuted)exitwith{_password=nil;_return};
if(!life_var_rcon_passwordOK AND !_init)exitwith{_password=nil;_return};
if(_password isEqualTo "")then{_password = "empty";};

if (_init)then{
	_command = "#lock";
}else{
	if (!_conlog)then{format["Sending Command: %1",_command] call life_fnc_rcon_systemlog;};
};

_return = _password serverCommand _command;

_return