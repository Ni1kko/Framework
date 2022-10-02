#include "\life_backend\script_macros.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

params ["_player","_type","_position"];
 
private _BEGuid = GET_BEGUID(_player);
private _ownerID = owner _player;

//--- Build tent
private _tent = [_type,_position,_BEGuid] call MPServer_fnc_tents_build;
private _tentID = _tent getVariable ["tentID",call MPServer_fnc_util_randomString];

//--- Add to Database and finish up
if(!isNull _tent)then{  
	["CREATE", "tents", 
		[//What 
			["BEGuid", 			["DB","STRING", _BEGuid] call MPServer_fnc_database_parse],
			["tentID", 			["DB","STRING", _tentID] call MPServer_fnc_database_parse],
			["type", 			["DB","STRING", _type] call MPServer_fnc_database_parse],
			["position", 		["DB","ARRAY", _position] call MPServer_fnc_database_parse],
			["vitems", 			["DB","ARRAY", []] call MPServer_fnc_database_parse]
		]
	] call MPServer_fnc_database_request;
	 
	publicVariable "life_var_allTents";

	[_tent,
	{
		private _pos = getPos _this;
		private _type = typeOf _this;
		
		_this addAction ["Packup Campsite",{[param [0,objNull]] spawn MPClient_fnc_packupTent;},nil,1.5,true,true,"","true",7,false];

		//-- Add map marker
		private _marker = createMarkerLocal[format["tent_%1",getPlayerUID player],_pos];
		_marker setMarkerShapeLocal "ICON";
		_marker setMarkerTypeLocal "hd_destroy";
		_marker setMarkerColorLocal "ColorBlack";
		_marker setMarkerTextLocal "Tent";

		life_var_tents pushBackUnique [netID _this, _type, _pos, _marker];
	}] remoteExec ["spawn",_ownerID];
};