/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

if(hasInterface AND {('extDB3' callExtension '9:VERSION') isEqualTo ''}) exitWith {
	private _exitmsg = 'Error [MPServer_fnc_database_getUpTime] requires extDB3!';
	[_exitmsg] call MPServer_fnc_database_systemlog;
	-1
};

private _uptime = parseNumber('extDB3' callExtension '9:UPTIME:MINUTES');

if(param[0,true] AND _uptime > 0)then{
	private _hrs = floor((_uptime * 60 ) / 60 / 60);
	private _mins = (((_uptime * 60 ) / 60 / 60) - _hrs);
	if(_mins == 0)then{_mins = 0.0001;};
	_mins = round(_mins * 60);
	_uptime = [_hrs,_mins] joinString ':';
};

_uptime