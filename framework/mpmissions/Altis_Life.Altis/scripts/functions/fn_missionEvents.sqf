#include "..\..\clientDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
	## fn_missionEvents.sqf

	## For more info see: https://community.bistudio.com/wiki/Arma_3:_Mission_Event_Handlers
*/

//-- Is developer mode enabled
#ifdef DEBUG
	//-- Is player a developer
	if(player call life_isDev)then{
		//-- Print event to chat
		systemChat format ["fn_missionEvents: (%2)[%1] -> %3",_thisEvent, _thisEventHandler, _this];
	};
#endif

//-- Handle adding single events. this system will not stack out events. so if you have 2 events that are the same, it will only add 1. Note: system will remove all event handlers of given type before adding new one this can cause unwanted behavior by EVH outside this script, if you have issues cann your script from the event here.
switch _thisEventHandler do
{
	//-- Only register event if no events registered
	case 0:
	{
		switch _thisEvent do 
		{
			//-- Triggered when map is opened or closed either by user action or script command openMap. 
			case "Map":
			{
				params [
					["_mapIsOpened",false,[false]],
					["_mapIsForced",false,[false]]
				];
				
				_this call MPClient_fnc_checkMap
			};
			//-- Triggered when user clicks anywhere on the main map and executes assigned code. Stackable version of onMapSingleClick with some limitations: No arguments can be passed to the assigned code in comparison with the original EH Does not have engine default functionality override like the original EH
			case "MapSingleClick":
			{
				params [
					["_units",[],[[]]],
					["_pos",[],[[]]],
					["_alt",false,[false]],
					["_shift",false,[false]]
				];

			};
			default 
			{
				[format["Warning mission EVH (%1) undefined!",_thisEvent,_thisEventHandler]] call MPClient_fnc_log;
			};
		};
	};
	//-- Event already handled by another script
	default
	{
		[format["Warning multiple EVH (%1) added to mission current index => %2, resetting (%1) events",_thisEvent,_thisEventHandler],true,true] call MPClient_fnc_log;
		removeAllMissionEventHandlers _thisEvent;
		_this call MPClient_fnc_missionEvents;
	};
};