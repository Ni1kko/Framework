/*
	## Nikko Renolds
	## https://github.com/Ni1kko/Framework
*/

life_var_tents = [];

MPClient_fnc_isTent = compileFinal '
	private _tent = param [0, objNull];
	if(isNil {_tent getVariable "tentID"}) exitWith {false};
	if(typeOf _tent in ["Land_Campfire_F", "Campfire_burning_F","Land_TentA_F","Land_TentDome_F"]) exitWith {true};
	false
';

waitUntil{!isNil "life_var_allTents"};

{
	private _tent = objectFromNetId _x;
	private _type = typeOf _tent;
	private _pos = getPos _tent;
	private _steamID = _tent getVariable ["ownerID",""];

	if(_steamID isEqualTo getPlayerUID player)then{
		private _marker = createMarkerLocal[format["tent_%1",getPlayerUID player],_pos];
		_marker setMarkerShapeLocal "ICON";
		_marker setMarkerTypeLocal "hd_destroy";
		_marker setMarkerColorLocal "ColorBlack";
		_marker setMarkerTextLocal "Tent";

		life_var_tents pushBackUnique [_x, _type, _pos, _marker];
 
		_tent addAction ["Packup Campsite",{[param [0,objNull]] spawn MPClient_fnc_packupTent;},nil,1.5,true,true,"","true",7,false];
	};
}forEach life_var_allTents;
	
if(count life_var_tents > 0)then{
	if(count life_var_tents > 3)then{
		private _tent = life_var_tents#0;
		[_tent,true] call MPClient_fnc_packupTent;
	};
	uiSleep 30;
	systemChat format ["%1 owned tents loaded",count life_var_tents];
};