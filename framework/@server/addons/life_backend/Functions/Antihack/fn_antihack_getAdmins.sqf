/*
	## Nikko Renolds
	## https://github.com/Ni1kko/Framework
*/

private _admins = [];

if(!isServer)exitwith{_admins};

private _config = (configFile >> "CfgAntiHack");

if(isClass _config)then{
	private _use_debugconadmins = getNumber(_config >> "use_debugconadmins") isEqualTo 1;
	private _use_databaseadmins = getNumber(_config >> "use_databaseadmins") isEqualTo 1;

	//--- Load admins from database
	if(_use_databaseadmins)then{
		for "_i" from 1 to 99 do {
			_admins append (["READ", "players", [["adminlevel","pid","BEGuid"],[["adminlevel",_i+1]]],false]call life_fnc_database_request);
		};
	};

	//--- load developers from description.ext (database level takes priorty)
	if(_use_debugconadmins)then{
		{
			private _BEGuid = ('BEGuid' callExtension ("get:"+_x));
			if ((str _admins) find _BEGuid isEqualTo -1)then{
				_admins pushBackUnique [99,_BEGuid,_x]; 
			};
		}forEach getArray(missionConfigFile >> "enableDebugConsole");
	};
};

_admins