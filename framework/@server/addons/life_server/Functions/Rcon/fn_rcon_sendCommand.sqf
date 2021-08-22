/*
	## Nikko Renolds
	## https://github.com/Ni1kko/Framework
*/

private["_command", "_password", "_return"];
_command = _this;
_password = getText(configFile >> "CfgRCON" >> "serverPassword");
if(_password isEqualTo "")then{_password = "empty";};
if !("#debug " in _command)then{
	format["Sending Command: %1",_command] call life_fnc_rcon_systemlog;
};
_return = _password serverCommand _command;
_return