/*
	## Nikko Renolds
	## https://github.com/Ni1kko/Framework
*/

if(!isServer)exitwith{false}; 
if(!isNil "life_var_rcon_serverLocked")exitwith{false};
 
life_var_rcon_RestartTimes = getArray (configFile >> "CfgRCON" >> "restartTimes");
life_var_rcon_KickTime = getNumber (configFile >> "CfgRCON" >> "kickTime");
life_var_rcon_LockTime = getNumber (configFile >> "CfgRCON" >> "restartAutoLock");
life_var_rcon_UseAutokick = getNumber (configFile >> "CfgRCON" >> "useAutoKick");
life_var_rcon_FriendlyMessages = getArray(configFile >> "CfgRCON" >> "friendlyMessages");
life_var_rcon_RestartMessages = false;
life_var_rcon_passwordOK = false;
life_var_rcon_serverLocked = false;
life_var_rcon_RestartTime = 0;
life_var_rcon_RestartMode = 0;
life_var_rcon_upTime = 0;
life_var_rcon_RealTime = "12:00";
life_var_rcon_messagequeue = [];
life_var_rcon_setupEvents_thread = scriptNull;
life_var_rcon_nextRestart = "12:00";
life_var_rcon_inittime = compile str diag_tickTime;

"Starting RCON" call life_fnc_rcon_systemlog;

life_fnc_rcon_getRealTime = compileFinal "(systemTimeUTC select [3,if(param[0,false])then{3}else{2}]) apply {if(_x < 10)then{'0' + str _x}else{_x}} joinString ':'";
life_fnc_rcon_getUpTime = compileFinal "round((diag_tickTime - (call life_var_rcon_inittime) / 60))";

life_fnc_rcon_sortTimeByEarlist = compileFinal "
	if !(params[['_evar','',['']],['_lvar','',['']]])exitWith {};
	
	call compile format [""
		private _a = %1;
		private _b = %2;
		
		private _aSplit = _a splitString ':';
		private _bSplit = _b splitString ':';
	
		if(parseNumber(_aSplit#0) == parseNumber(_bSplit#0))then{
			if(parseNumber(_aSplit#1) > parseNumber(_bSplit#1))exitWith{
				%2 = _a;
				%1 = _b;
			};
		}else{ 
			if(parseNumber(_aSplit#0) > parseNumber(_bSplit#0))exitWith{ 
				%2 = _a;
				%1 = _b;
			};
		};
	"",_evar,_lvar];
";

life_fnc_rcon_subtractTime = compileFinal "
	private _early = param[0,'12:00'];
	private _late = param[1,'12:00'];
	['_early','_late'] call life_fnc_rcon_sortTimeByEarlist;
	parseNumber('Time' callExtension format['subtract-%1,%2',_early,_late])
";

private _time = call getRealTime;
{
	if(([_x, _time] call life_fnc_rcon_subtractTime) > 0)exitWith{
		life_var_rcon_nextRestart = _x;
	};
} forEach life_var_rcon_RestartTimes;

{publicVariable _x} forEach [
	"life_var_rcon_passwordOK",
	"life_var_rcon_RestartTime",
	"life_var_rcon_upTime",
	"life_var_rcon_RealTime",
	"life_var_rcon_RestartMode"
];

if ("#init/" call life_fnc_rcon_sendCommand) then
{
	"Lock Event: server locked for init" call life_fnc_rcon_systemlog;
	[] call life_fnc_rcon_kickAll;
	life_var_rcon_inittime = compileFinal str diag_tickTime;
	life_var_rcon_setupEvents_thread = [] spawn life_fnc_rcon_setupEvents;
};

true