#include "..\..\script_macros.hpp"
/*
    File: fn_onPlayerKilled.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    When the player dies collect various information about that player
    and pull up the death dialog / camera functionality.
*/
params [
    ["_unit",objNull,[objNull]],
    ["_killer",objNull,[objNull]]
];
disableSerialization;
diag_log format ["You got killed by %1(%2)",_killer getVariable["realname",""],getPlayerUID _killer];
if  !((vehicle _unit) isEqualTo _unit) then {
    UnAssignVehicle _unit;
    _unit action ["getOut", vehicle _unit];
    _unit setPosATL [(getPosATL _unit select 0) + 3, (getPosATL _unit select 1) + 1, 0];
};

//Set some vars
_unit setVariable ["Revive",true,true];
_unit setVariable ["name",profileName,true]; //Set my name so they can say my name.
_unit setVariable ["restrained",false,true];
_unit setVariable ["Escorting",false,true];
_unit setVariable ["transporting",false,true];
_unit setVariable ["playerSurrender",false,true];
_unit setVariable ["steam64id",(getPlayerUID player),true]; //Set the UID.

//close the esc dialog
if (dialog) then {
    closeDialog 0;
};

private _getWeaponName = {
	private _player = param[0,player];
	private _weapon = "";
	if(isPlayer _player) then {
		private _weaponInfo = [currentWeapon _player] call life_fnc_fetchCfgDetails;
		if(count _weaponInfo > 1) then {
			_weapon = _weaponInfo select 1;
		};
	};
	_weapon
};

private _getGroupName = {
	switch (side param[0,player]) do 
	{
		case west:{"Police"};
		case independent:{"Medic"};
		default
		{
			if(((group _killer) getVariable["gang_name",""]) == "") then {
				""
			} else {
				"" + ((group _killer) getVariable["gang_name",""])
			};
		};
	};
};
 
private _suicide = (_killer isEqualTo player);

private _groupName = [] call _getGroupName;
private _killerWeapon = "";
private _deathtype = 0;

if(!_suicide)then{
	if(!isNull _killer)then{
		_deathtype = 1;
		if((_killer isKindOf "landVehicle") || (_killer isKindOf "Ship") || (_killer isKindOf "Air")) then {
			_killerWeapon = format["%1 (Vehicle)", getText(configFile >> "CfgVehicles" >> typeOf (vehicle _killer) >> "displayName")];
		} else {
			_killerWeapon = [_killer] call _getWeaponName;
		};
	}else{
		_deathtype = 2;
	};
	_groupName = [_killer] call _getGroupName;
};

//Setup our camera view
life_deathCamera  = "CAMERA" camCreate (getPosATL _unit);
showCinemaBorder false;
life_deathCamera cameraEffect ["Internal","Back"];
createDialog "DeathScreen";
life_deathCamera camSetTarget _unit;
life_deathCamera camSetRelPos [0,22,22];
life_deathCamera camSetFOV .5;
life_deathCamera camSetFocus [50,0];
life_deathCamera camCommit 0;

//-- block escape as would close this display on escape key pressed
(findDisplay 7300) displaySetEventHandler ["KeyDown","if((_this select 1) == 1) then {true}"];

//-- get ui controls
_Killedby = ((findDisplay 7300) displayCtrl 7310);
_KilledWeapon = ((findDisplay 7300) displayCtrl 7311);
_KilledDistance = ((findDisplay 7300) displayCtrl 7312);

//-- toggle controls depending on death type
_KilledWeapon ctrlShow (_deathtype isNotEqualTo 2);
_KilledDistance ctrlShow (_deathtype isNotEqualTo 2);

//-- render the death reason
_Killedby ctrlSetText (switch _deathtype do {
    case 1: { format [
        [
            "Killed by: %1 (%2)", 
            "Killed by: %1"
        ] select (_groupName isEqualTo ""),
        _killer getVariable["realname",""],
        _groupName
    ]};
    case 2: { selectRandom [
        "You died because... Arma.",
        "You died because the universe hates him.",
        "You died a mysterious death.",
        "You died and nobody knows why.",
        "You died because that's why.",
        "You died because You was very unlucky.",
        "You died due to Arma bugs and is probably very salty right now.",
        "You died an awkward death.",
        "You died. Yes, You is dead. Like really dead-dead."
    ]};
    default {"Commited suicide"};
});
//-- render the name of that weapon that was used to kill the player
if(ctrlShown _KilledWeapon)then{
	_KilledWeapon ctrlSetText format ["Weapon: %1",_killerWeapon];
};

//-- render distance betwwen player and killer
if(ctrlShown _KilledDistance)then{
	_KilledDistance ctrlSetText format ["Distance: %1m",[floor( _killer distance _unit)] call life_fnc_numberText];
};



//Create a thread for something?
_unit spawn {
    private ["_maxTime","_RespawnBtn","_Timer"];
    disableSerialization;
    _RespawnBtn = ((findDisplay 7300) displayCtrl 7302);
    _Timer = ((findDisplay 7300) displayCtrl 7301);
    if (LIFE_SETTINGS(getNumber,"respawn_timer") < 5) then {
        _maxTime = time + 5;
    } else {
        _maxTime = time + LIFE_SETTINGS(getNumber,"respawn_timer");
    };
    _RespawnBtn ctrlEnable false;
    waitUntil {
        _Timer ctrlSetText format [localize "STR_Medic_Respawn",[(_maxTime - time),"MM:SS"] call BIS_fnc_secondsToString];
        round(_maxTime - time) <= 0 || isNull _this
    };
    _RespawnBtn ctrlEnable true;
    _Timer ctrlSetText localize "STR_Medic_Respawn_2";
};

_unit spawn {
    disableSerialization;
    private _requestBtn = ((findDisplay 7300) displayCtrl 7303);
    _requestBtn ctrlEnable false;
    private _requestTime = time + 5;
    waitUntil {round(_requestTime - time) <= 0 || isNull _this};
    _requestBtn ctrlEnable true;
};

[] spawn life_fnc_deathScreen;

//Create a thread to follow with some what precision view of the corpse.
[_unit] spawn {
    private ["_unit"];
    _unit = _this select 0;
    waitUntil {if (speed _unit isEqualTo 0) exitWith {true}; if(!isNil "life_deathCamera" AND  {!isNull life_deathCamera})then{life_deathCamera camSetTarget _unit; life_deathCamera camSetRelPos [0,3.5,4.5]; life_deathCamera camCommit 0;}; };
};

//Make the killer wanted
if (!isNull _killer && {!(_killer isEqualTo _unit)} && {!(side _killer isEqualTo west)} && {alive _killer}) then {
    if (vehicle _killer isKindOf "LandVehicle") then {
        if (count extdb_var_database_headless_clients > 0) then {
            [getPlayerUID _killer,_killer getVariable ["realname",name _killer],"187V"] remoteExecCall ["HC_fnc_wantedAdd",extdb_var_database_headless_client];
        } else {
            [getPlayerUID _killer,_killer getVariable ["realname",name _killer],"187V"] remoteExecCall ["life_fnc_wantedAdd",RSERV];
        };

        //Get rid of this if you don't want automatic vehicle license removal.
        if (!local _killer) then {
            [2] remoteExecCall ["life_fnc_removeLicenses",_killer];
        };
    } else {
        if (count extdb_var_database_headless_clients > 0) then {
            [getPlayerUID _killer,_killer getVariable ["realname",name _killer],"187"] remoteExecCall ["HC_fnc_wantedAdd",extdb_var_database_headless_client];
        } else {
            [getPlayerUID _killer,_killer getVariable ["realname",name _killer],"187"] remoteExecCall ["life_fnc_wantedAdd",RSERV];
        };

        if (!local _killer) then {
            [3] remoteExecCall ["life_fnc_removeLicenses",_killer];
        };
    };
};

life_save_gear = [player] call life_fnc_fetchDeadGear;

if (LIFE_SETTINGS(getNumber,"drop_weapons_onDeath") isEqualTo 0) then {
    _unit removeWeapon (primaryWeapon _unit);
    _unit removeWeapon (handgunWeapon _unit);
    _unit removeWeapon (secondaryWeapon _unit);
};

//Killed by cop stuff...
if (side _killer isEqualTo west && !(playerSide isEqualTo west)) then {
    life_copRecieve = _killer;
    //Did I rob the federal reserve?
    if (!life_use_atm && {life_var_cash > 0}) then {
        [format [localize "STR_Cop_RobberDead",[life_var_cash] call life_fnc_numberText]] remoteExecCall ["life_fnc_broadcast",RCLIENT];
        life_var_cash = 0;
    };
};

if (!isNull _killer && {!(_killer isEqualTo _unit)}) then {
    life_removeWanted = true;
};

[_unit] call life_fnc_dropItems;

life_action_inUse = false;
life_hunger = 100;
life_thirst = 100;
life_carryWeight = 0;
life_var_cash = 0;
life_is_alive = false;

[player,life_settings_enableSidechannel,playerSide] remoteExecCall ["TON_fnc_manageSC",RSERV];

[0] call SOCK_fnc_updatePartial;
[3] call SOCK_fnc_updatePartial;
if (playerSide isEqualTo civilian) then {
    [4] call SOCK_fnc_updatePartial;
};