#include "..\..\clientDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
	## fn_setupEventHandlers.sqf

	## For more info see: https://community.bistudio.com/wiki/Arma_3:_Event_Handlers
*/

switch (param [0,"player"]) do 
{
	//-- The player Event Handler is always executed on the computer where it was added. 
	case "player":
	{ 
		private _player = param [1,player];

		if not(isNull _player) then 
		{
			//-- Add new player event handlers
			{ 
				private _evhVar = format ["%1EVH", _x];
				private _evhID = _player getvariable [_evhVar, -1];

				//-- Is our EVH already registered?
				if(_evhID isNotEqualTo -1) then  { 
					_player removeEventHandler [_x,_evhID];
				};

				//-- Register it
				_evhID = _player addEventHandler [_x, MPClient_fnc_playerEvents];

				//-- To many event handlers registed, reset then re-register it
				if(_evhID > 0) then {
					_player removeAllEventHandlers _x;
					_evhID = _player addEventHandler [_x, MPClient_fnc_playerEvents];
				};

				//-- Save ref
				_player setvariable [_evhVar, _evhID, true];
			} forEach PLAYER_EVENT_TYPES;
		};
	};
	//-- Mission Event Handlers are specific EHs that are anchored to the running mission and automatically removed when mission is over. 
	case "mission": 
	{ 
		//-- Add mission event handlers is not already registered
		{
			private _evhVar = format ["life_var_%1EVH", _x];
			private _evhID = missionnamespace getvariable [_evhVar, -1];

			//-- Is our EVH already registered?
			if(_evhID isNotEqualTo -1) then {
				removeMissionEventHandler [_x,_evhID];
			};
			
			//-- Register it
			_evhID = addMissionEventHandler [_x, MPClient_fnc_missionEvents];
			
			//-- To many event handlers registed, reset then re-register it
			if(_evhID > 0) then {
				removeAllMissionEventHandlers _x;
				_evhID = addMissionEventHandler [_x, MPClient_fnc_missionEvents];
			};

			//-- Save ref
			missionnamespace setvariable [_evhVar, _evhID];
		}forEach MISSION_EVENT_TYPES;
	};
	//-- The group Event Handler is always executed on the computer where it was added. 
	case "group": 
	{ 
		//-- ToDo : https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#Group_Event_Handlers
	};
	//-- The vehicle Event Handler is always executed on the computer where it was added. 
	case "vehicle": 
	{ 
		//-- ToDo : https://community.bistudio.com/wiki/Arma_3:_Event_Handlers
	};
	//-- The projectile Event Handler is always executed on the computer where it was added. 
	case "projectile": 
	{ 
		//-- ToDo : https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#Projectile_Event_Handlers
	};
	//-- User Interface Event Handlers allow you to automatically monitor and then execute custom code upon particular UI events being triggered. 
	case "userInterface": 
	{
		//-- ToDo : https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#UI_Event_Handlers_.28Displays_and_Controls.29
	};
	//-- UserAction Event Handlers are events that trigger on user action. 
	case "userAction": 
	{ 
		//-- ToDo : https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#Player.27s_UI_Event_Handlers
	};
};

true