#include "..\..\clientDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
	## fn_playerEvents.sqf

	## For more info see: https://community.bistudio.com/wiki/Arma_3:_Event_Handlers
*/

//-- Is developer mode enabled
#ifdef DEBUG
	//-- Is player a developer and event is not a animation event
	if((player call life_isDev) AND not(_thisEvent in ["AnimChanged","AnimDone","AnimStateChanged","GestureChanged","GestureDone"]))then{
		//-- Print event to chat
		systemChat format ["fn_playerEvents: (%2)[%1] -> %3",_thisEvent, _thisEventHandler, _this];
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
			//-- Triggered every time a new animation is started. This EH is only triggered for the 1st animation state in a sequence. 
			case "AnimChanged": 
			{
				params [
					["_player", objNull, [objNull]],
					["_animation ", "", [""]]
				];
				
			};
			//-- Triggered every time an animation is finished. Triggered for all animation states in a sequence. 
			case "AnimDone": 
			{
				params [
					["_player", objNull, [objNull]],
					["_animation ", "", [""]]
				];

			};
			//-- Triggered every time an animation state changes. Triggered for all animation states in a sequence. 
			case "AnimStateChanged": 
			{
				params [
					["_player", objNull, [objNull]],
					["_animation ", "", [""]]
				];

			};
			//-- Triggers when cargo container is accessed by player. This event handler is similar to InventoryOpened EH, but needs to be assigned to the container rather than the player and cannot be overridden. Note: will trigger only for the unit opening container. 
			case "ContainerOpened": 
			{
				params [
					["_container", objNull, [objNull]],
					["_player", objNull, [objNull]]
				];

			};
			//-- Triggers when player finished accessing cargo container. This event handler is similar to InventoryClosed EH, but needs to be assigned to the container rather than the player. Note: will trigger only for the unit opening container.
			case "ContainerClosed": 
			{
				params [
					["_container", objNull, [objNull]],
					["_player", objNull, [objNull]]
				];

			};
			//-- Triggered when the unit is damaged. In ArmA works with all vehicles not only men like in OFP. 
			case "Dammaged": 
			{
				params [
					["_player", objNull, [objNull]],
					["_selection", "", [""]],
					["_damage", 0, [0]],
					["_hitIndex", 0, [0]],
					["_hitPoint", "", [""]],
					["_shooter", objNull, [objNull]],
					["_projectile", objNull, [objNull]]
				];

			};
			//-- Triggered just before the assigned entity is deleted.
			case "Deleted": 
			{
				params [
					["_player", objNull, [objNull]]
				];

			};
			//-- Triggered when object collision (PhysX) starts.
			case "EpeContactStart": 
			{
				params [
					["_player", objNull, [objNull]],
					["_object", objNull, [objNull]],
					["_playerSelection", "", [""]],	// not in use at this moment, empty string is always returned
					["_objectSelection", "", [""]],	// not in use at this moment, empty string is always returned
					["_force", 0, [0]], 
					["_reactionForceVector", [], [[]]],
					["_pointOfImpact", [], [[]]]
				];

			};
			//-- Triggered when object collision (PhysX) is in progress.
			case "EpeContact": 
			{
				params [
					["_player", objNull, [objNull]],
					["_object", objNull, [objNull]],
					["_playerSelection", "", [""]],	// not in use at this moment, empty string is always returned
					["_objectSelection", "", [""]],	// not in use at this moment, empty string is always returned
					["_force", 0, [0]], 
					["_reactionForceVector", [], [[]]],
					["_pointOfImpact", [], [[]]]
				];

			};
			//-- Triggered when object collision (PhysX) ends. 
			case "EpeContactEnd": 
			{
				params [
					["_player", objNull, [objNull]],
					["_object", objNull, [objNull]],
					["_playerSelection", "", [""]],	// not in use at this moment, empty string is always returned
					["_objectSelection", "", [""]],	// not in use at this moment, empty string is always returned
					["_force", 0, [0]]
				];

			};
			//-- Triggered when a vehicle or unit is damaged by a nearby explosion. It can be assigned to a remote unit or vehicle but will only fire on the PC where EH is added and explosion is local, i.e. it really needs to be added on every PC and JIP and will fire only where the explosion is originated. 
			case "Explosion": 
			{
				params [
					["_vehicle", objNull, [objNull]],
					["_damage", 0, [0]],
					["_source", objNull, [objNull]]
				];

				_damage
			};
			//-- Triggered when the unit fires a weapon. This EH will not trigger if a unit fires out of a vehicle. For those cases an EH has to be attached to that particular vehicle. When "Manual Fire" is used, the gunner is objNull if gunner is not present or the gunner is not the one who fires. To check if "Manual Fire" is on, use isManualFire. The actual shot instigator could be retrieved with getShotParents command.
			case "Fired": 
			{
				params [
					["_player", objNull, [objNull]],
					["_weaponClass", "", [""]],
					["_muzzleClass", "", [""]],
					["_fireMode", "", [""]],
					["_ammoClass", "", [""]],
					["_magazineClass", "", [""]],
					["_projectile", objNull, [objNull]],
					["_gunner", objNull, [objNull]]
				];
				
				_this call MPClient_fnc_onFired
			};
			//-- Triggered when the unit fires a weapon. This EH must be attached to a soldier and unlike with "Fired" EH, it will fire regardless of whether the soldier is on foot or firing vehicle weapon. For remoteControled unit use "Fired" EH instead. 
			case "FiredMan": 
			{
				params [
					["_player", objNull, [objNull]],
					["_weaponClass", "", [""]],
					["_muzzleClass", "", [""]],
					["_fireMode", "", [""]],
					["_ammoClass", "", [""]],
					["_magazineClass", "", [""]],
					["_projectile", objNull, [objNull]],
					["_vehicle", objNull, [objNull]]
				];
			
			};
			//-- Triggered when a weapon is fired or thrown. somewhere near the unit or vehicle. It is also triggered if the unit itself is firing. (Exception(s): the Throw weapon wont broadcast the FiredNear event). When "Manual Fire" is used, the gunner is objNull if gunner is not present or the gunner is not the one who fires. To check if "Manual Fire" is on, use isManualFire. The actual shot instigator could be retrieved with getShotParents command.
			case "FiredNear":
			{
				params [
					["_player", objNull, [objNull]],
					["_suspect", objNull, [objNull]],
					["_distance", 0, [0]],
					["_weaponClass", "", [""]],
					["_muzzleClass", "", [""]],
					["_fireMode", "", [""]],
					["_ammoClass", "", [""]], 
					["_gunner", objNull, [objNull]]
				];

				[player, 30] call (missionNamespace getVariable ["life_fnc_enterCombat",{}]);

				nil
			};
			//-- Triggered every time a new gesture is played. 
			case "GestureChanged":
			{
				params [
					["_player", objNull, [objNull]],
					["_gesture", "", [""]]
				];
			
			};
			//-- Triggered every time a gesture is finished. 
			case "GestureDone":
			{
				params [
					["_player", objNull, [objNull]],
					["_gesture", "", [""]]
				];
			
			};
			//-- Triggers when the unit is damaged and fires for each damaged selection separately Note: Currently, in Arma 3 v1.70 it triggers for every selection of a vehicle, no matter if the section was damaged or not)
			case "HandleDamage": 
			{
				params [
					["_player", objNull, [objNull]],
					["_hitPart", "", [""]],
					["_damage", 0, [0]],
					["_source", objNull, [objNull]],
					["_projectileClass", "", [""]],
					["_hitIndex", 0, [0]],
					["_instigator", objNull, [objNull]],
					["_hitPoint", "", [""]]
				];

				//_damage
				_this call MPClient_fnc_handleDamage
			};
			//-- Triggered when unit starts to heal (player using heal action or AI heals after being ordered). Triggers only on PC where EH is added and unit is local. If code returns false, engine side healing follows. Return true if you handle healing in script, use AISFinishHeal to tell engine that script side healing is done. See also lifeState and setUnconscious commands.
			case "HandleHeal":
			{
				params [
					["_player", objNull, [objNull]],
					["_healer", objNull, [objNull]],
					["_hasMedicTrait", false, [false]]
				];

			};
			//-- Triggered when engine adds rating to overall rating of the unit, usually after a kill or a friendly kill. If EH code returns Number, this will override default engine behaviour and the resulting value added will be the one returned by EH code. 
			case "HandleRating": 
			{
				params [
					["_player", objNull, [objNull]],
					["_rating", 0, [0]]
				];

				//_rating
				0
			};
			//-- Triggered when engine adds score to overall score of the unit, usually after a kill. If the EH code returns Nothing or true, the default engine scoreboard update (score, vehicle kills, infantry kills, etc) is applied, if it returns false, the engine update is cancelled. To add or modify score, use addScore and addScoreSide commands. For remote units like players, the event does not persist after respawn, and must be re-added to the new unit. 
			case "HandleScore": 
			{
				params [
					["_player", objNull, [objNull]],
					["_object", objNull, [objNull]],
					["_score", 0, [0]]
				];

				_score
			};
			//-- Triggered when the unit is hit/damaged. Is not always triggered when unit is killed by a hit. Most of the time only the killed event handler is triggered when a unit dies from a hit. The hit EH will not necessarily fire if only minor damage occurred (e.g. firing a bullet at a tank), even though the damage increased. Does not fire when a unit is set to allowDamage false. 
			case "Hit": 
			{
				params [
					["_player", objNull, [objNull]],
					["_source", objNull, [objNull]],
					["_damage", 0, [0]],
					["_instigator", objNull, [objNull]]
				];
				
			};
			//-- Runs when the object it was added to gets injured/damaged. It returns the position and component that was hit on the object within a nested array, this is because the model may have more than one selection name for the hit component (i.e. a single piece of geometry can be simultaneously part of multiple, overlapping named selections). 
			case "HitPart": 
			{
				private _eventData = param [0, [], [[]]];

				_eventData params [
					["_player", objNull, [objNull]],
					["_shooter", objNull, [objNull]],
					["_projectile", objNull, [objNull]],
					["_position", [], [[]]],
					["_velocity", [], [[]]],
					["_selection", "", [""]],
					["_ammo", "", [""]],
					["_vector", [], [[]]],
					["_radius", 0, [0]],
					["_surfaceType", "", [""]],
					["_isDirect", false, [false]]
				];

			};
			//--Triggered when a unit fires a missile or rocket at the target. For projectiles fired by players this EH only triggers for guided missiles that have locked onto the target. 
			case "IncomingMissile": 
			{
				params [
					["_player", objNull, [objNull]],
					["_ammoClass", "", [""]],
					["_vehicle", objNull, [objNull]],
					["_instigator", objNull, [objNull]],
					["_missile", objNull, [objNull]]
				];
				
			};
			//-- Triggered when unit opens inventory. Said unit can be non-local when adding the EH, but must be local for the EH to trigger. End EH main scope with true to override the opening of the inventory in case you wish to handle it yourself: 
			case "InventoryOpened": 
			{
				params [
					["_player", objNull, [objNull]],
					["_container", objNull, [objNull]]
				];

				_this call MPClient_fnc_inventoryOpened
			};
			//-- Triggered when the unit closes inventory. Said unit can be non-local when adding the EH, but must be local for the EH to trigger. 
			case "InventoryClosed": 
			{
				params [
					["_player", objNull, [objNull]],
					["_container", objNull, [objNull]]
				];

				_this call MPClient_fnc_inventoryClosed
			};
			//-- Triggered when the unit is killed. Be careful when the killer has been a vehicle. For most cases the reference of the vehicle is the same as the effectiveCommander, but not always. 
			case "Killed": 
			{
				params [
					["_player", objNull, [objNull]],
					["_killer", objNull, [objNull]],
					["_instigator", objNull, [objNull]],
					["_useEffects", false, [false]]
				];

				_this call MPClient_fnc_onPlayerKilled
			};
			//-- Triggers when locality of object in MP is changed. The event handler only triggers on the computers that are directly involved in change of locality. So if EH is added to every computer on network, it will only trigger on 2 computers, on the computer that receives ownership of the object (new owner), in which case _this select 1 will be true, and on the computer from which ownership is transferred (old owner), in which case _this select 1 will be false. 
			case "Local": 
			{
				params [
					["_player", objNull, [objNull]],
					["_isLocal", false, [false]]
				];

			};
			//-- Triggers everytime a local unit changes optic mode. This could be either through the setOpticsMode command or by the player switching to the next optic mode using e.g NUM / or Ctrl + Right Mouse Button. 
			case "OpticsModeChanged": 
			{
				params [
					["_player", objNull, [objNull]],
					["_opticsClass", "", [""]],
					["_newMode", "", [""]],
					["_oldMode", "", [""]],
					["_isADS", false, [false]]
				];

			};
			//-- Triggers at the start of the camera transition from GUNNER to INTERNAL/EXTERNAL and vice-versa. So anytime the right mouse button is pressed and there is a GUNNER view available or are currently in it, this triggers. Works in vehicles and FFV as well. See also cameraView. 
			case "OpticsSwitch": 
			{
				params [
					["_player", objNull, [objNull]],
					["_isADS", false, [false]]
				];

			};
			//-- Triggers when a unit puts an item in a container. 
			case "Put": 
			{
				params [
					["_player", objNull, [objNull]],
					["_container", objNull, [objNull]],
					["_item", "", [""]]
				];

			};
			//-- Triggers when a weapon is reloaded with a new magazine. For more information see: https://community.bistudio.com/wiki/Arma_3:_Event_Handlers/Reloaded
			case "Reloaded": 
			{
				params [
					["_player", objNull, [objNull]],
					["_weaponClass", "", [""]],
					["_muzzleClass", "", [""]],
					["_newMagazineArray", [], [[]]],
					["_oldMagazineArray", [], [[]]]
				];

			};
			//-- Triggered when a unit respawns. 
			case "Respawn": 
			{
				params [
					["_player", objNull, [objNull]],
					["_corpse", objNull, [objNull]]
				];

			};
			//-- Triggered when unit changes seat within vehicle. EH returns both units switching seats. If switching seats with an empty seat, one of the returned units will be objNull. The new position can be obtained with assignedVehicleRole <unit>. This EH must be assigned to a unit and not a vehicle. This EH is persistent and will be transferred to the new unit after respawn, but only if it was assigned where unit was local. 
			case "SeatSwitchedMan": 
			{
				params [
					["_player", objNull, [objNull]],
					["_passenger", objNull, [objNull]],
					["_vehicle", objNull, [objNull]]
				];

			};
			//-- Triggered when player is making noises mainly when injured or fatigued
			case "SoundPlayed": 
			{
				params [
					["_player", objNull, [objNull]],
					["_soundID", -1, [0]]
				];

				private _soundType = switch _soundID do {
					case 1: {"Breath"};
					case 2: {"Breath Injured"};
					case 3: {"Breath Scuba"};
					case 4: {"Injured"};
					case 5: {"Pulsation"};
					case 6: {"Hit Scream"};
					case 7: {"Burning"};
					case 8: {"Drowning"};
					case 9: {"Drown"};
					case 10: {"Gasping"};
					case 11: {"Stabilizing"};
					case 12: {"Healing"};
					case 13: {"Healing With Medikit"};
					case 14: {"Recovered"};
					case 15: {"Breath Held"};
					default {"Unknown"};
				};

				switch _soundType do 
				{
					case "Breath": { };
					case "Breath Injured": { };
					case "Breath Scuba": { };
					case "Injured": { };
					case "Pulsation": { };
					case "Hit Scream": { };
					case "Burning": { };
					case "Drowning": { };
					case "Drown": { };
					case "Gasping": { };
					case "Stabilizing": { };
					case "Healing": { };
					case "Healing With Medikit": { };
					case "Recovered": { };
					case "Breath Held": { };
				};

			};
			//-- Triggers when a unit takes an item from a container. 
			case "Take": 
			{
				params [
					["_player", objNull, [objNull]],
					["_container", objNull, [objNull]],
					["_item", "", [""]]
				];

				_this call MPClient_fnc_onTakeItem
			};
			//-- Triggers when player's current task changes 
			case "TaskSetAsCurrent": 
			{
				params [
					["_player", objNull, [objNull]],
					["_task", tasknull, [tasknull]]
				];
			};
			//-- Triggers when the assigned vehicle/unit's vision mode has changed.
			case "VisionModeChanged": 
			{
				params [
					["_player", objNull, [objNull]],
					["_visionMode", 0, [0]],
					["_TIindex", 0, [0]],
					["_visionModePrev", 0, [0]],
					["_TIindexPrev", 0, [0]],
					["_vehicle", objNull, [objNull]],
					["_turret", [], [[]]]
				];

			};
			//-- Triggers when the deployed state of a weapon or bipod changes. Note: A weapon cannot be rested and deployed at the same time. 
			case "WeaponDeployed": 
			{
				params [
					["_player", objNull, [objNull]],
					["_isDeployed", false, [false]]
				];

			};
			//-- Triggers when weapon rested state changes (weapon near a surface that can provide weapon support). Note: A weapon cannot be rested and deployed at the same time. 
			case "WeaponRested": 
			{
				params [
					["_player", objNull, [objNull]],
					["_isRested", false, [false]]
				];

			};
			default 
			{
				[format["Warning player EVH (%1) undefined!",_thisEvent,_thisEventHandler]] call MPClient_fnc_log;
			};
		};
	};
	//-- Event already handled by another script
	default
	{
		[format["Warning multiple EVH (%1) added to player current index => %2, resetting (%1) events",_thisEvent,_thisEventHandler],true,true] call MPClient_fnc_log;
		player removeAllEventHandlers _thisEvent;
		_this call MPClient_fnc_playerEvents;
	};
};