#include "\life_backend\serverDefines.hpp"
/*
	## Ni1kko
	## https://github.com/Ni1kko/FrameworkV2

	## life_var_severScheduler pushBack [time, function, params, target, isSpawn]
*/

private _AHScheduleVar = param [0, ""];
private _ScheduleVar = "life_var_severScheduler";
private _runtime = 0;

while{true} do
{
	private _MasterSchedule = [];
	private _Schedule = missionNamespace getVariable [_ScheduleVar, []]; 
	private _AHSchedule = serverNamespace getVariable [_AHScheduleVar, []]; 

	if(isNil "_Schedule") then {_Schedule = []; missionNamespace setVariable [_AHScheduleVar, _Schedule]};
	if(typeName _Schedule isNotEqualTo "ARRAY") then {_Schedule = []; missionNamespace setVariable [_AHScheduleVar, _Schedule]};

	if(isNil "_AHSchedule") then {_AHSchedule = []; serverNamespace setVariable [_AHScheduleVar, _AHSchedule]};
	if(typeName _AHSchedule isNotEqualTo "ARRAY") then {_AHSchedule = []; serverNamespace setVariable [_AHScheduleVar, _AHSchedule]};
	 
	_MasterSchedule append _AHSchedule;
	_MasterSchedule append _Schedule;
 
	if(count _MasterSchedule > 0)then
	{
		{
			_x params [
				["_time", 0, [0]],
				["_function", "", ["",{}]],
				["_params", []],
				["_target", "SERVER", [""]],
				["_isSpawn",false, [false]]
			];
			
			if(_time < 3)then{_time = 3};
			
			if(_target in ["CLIENT","SERVER","GLOBAL"])then
			{
				if((_runtime mod _time) isEqualTo 0)then
				{ 
					switch _target do 
					{
						case "SERVER": 
						{ 
							private _code = compile ("['Error: Function [" + _function + "] not found'] call MPServer_fnc_log");
							
							if(typeName _function isEqualTo "CODE")then{
								_code = _function;
							}else{
								_code = missionNamespace getVariable [_function, _code];
							};

							if _isSpawn then {
								_params spawn _code;
							}else{
								_params call _code;
							};
						};
						case "CLIENT": 
						{ 
							if(typeName _function isEqualTo "CODE")then{ 
								if _isSpawn then {
									[_params,_function] remoteExec ["spawn", -2];
								}else{
									[_params,_function] remoteExec ["call", -2];
								};
							}else{
								if _isSpawn then {
									_params remoteExec [_function, -2];
								}else{
									_params remoteExecCall [_function, -2];
								}; 
							};
						};
						case "GLOBAL": 
						{ 
							if(typeName _function isEqualTo "CODE")then{ 
								if _isSpawn then {
									[_params,_function] remoteExec ["spawn", 0];
								}else{
									[_params,_function] remoteExec ["call", 0];
								};
							}else{
								if _isSpawn then {
									_params remoteExec [_function, 0];
								}else{
									_params remoteExecCall [_function, 0];
								};
							};
						};
					};	
				};
			};
		 
		}forEach (_MasterSchedule call BIS_fnc_arrayShuffle)
		
	};
	
	_runtime = _runtime + 1;
	sleep 1;
};

true