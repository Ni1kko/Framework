/*
	## Nikko Renolds
	## https://github.com/Ni1kko/Framework
*/

private _admins = [];

if(!isServer)exitwith{_admins};

//--- Load admins from database
for "_i" from 1 to 99 do {
	_admins append (["READ", "players", [["adminlevel","pid","BEGuid"],[["adminlevel",_i]]],false]call life_fnc_database_request);
};

//--- load developers from description.ext (database level takes priorty)
{
	private _BEGuid = ('BEGuid' callExtension ("get:"+_x));
	if ((str _admins) find _BEGuid isEqualTo -1)then{
		_admins pushBackUnique [99,_BEGuid,_x]; 
	};
}forEach getArray(missionConfigFile >> "enableDebugConsole");

_admins