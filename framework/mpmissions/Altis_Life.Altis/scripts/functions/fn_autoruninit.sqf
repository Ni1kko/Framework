/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/
while {true} do {
	waitUntil{life_var_autorun}; 
	life_var_autorun_thread = [] spawn {
		scriptName 'MPClient_fnc_autorunScript';
		while {life_var_autorun} do { 
			if (call MPClient_fnc_util_canautorun) then {
				private _gradient = player call MPClient_fnc_util_getTerrainGradient;
				
				//out of range
				if(_gradient < 0)exitWith{
					life_var_autorun = false;
				};

				//alter depending on how steep the angle is 
				private _mode = switch (true) do{ 
					case (_gradient < 18): {"FastF"};
					case (_gradient < 30): {"SlowF"};
					case (_gradient < 55): {"WalkF"};
					default {"Stop"};
				}; 

				//play
				_mode call MPClient_fnc_autorunswitch;

				//loop after 1
				uiSleep 1;
			} else {
				life_var_autorun = false;
			};
		};
	};
	waitUntil{!life_var_autorun}; 
	terminate life_var_autorun_thread;
	"Stop" call MPClient_fnc_autorunswitch;
};