/*
	## Nikko Renolds
	## https://github.com/Ni1kko/Framework
*/

params [
	["_tent",cursorObject,[objNull]],
	["_silent",false,[false]]
];

private _marker = "";
private _valid = false;
private _tooFar = _tent distance2D player > 7;

{
	if((_x#0) isEqualTo netID _tent)exitWith{
		_valid = true;
		_marker = _x param [3,""];
	};
}forEach life_var_tents;

if(!_valid || _tooFar)exitWith{ 
	if(_tent call life_fnc_isTent)then{
		if(_tooFar)then{
			systemChat "You are not close enough to the tent.";
		}else{
			systemChat "You are not the owner of this tent.";
		};
	}else{
		systemChat "Not a valid tent.";
	};
};

if(_silent)then{
	[player,_tent,_marker] remoteExec ["MPServer_fnc_tents_packupRequest",2];
}else{
	private _result = ["Are you sure you wish too packup tent?", "Packup Tent", true, true] call BIS_fnc_guiMessage;

	if (_result) then { 
		[player,_tent,_marker] remoteExec ["MPServer_fnc_tents_packupRequest",2];
	} else {
		systemChat "Tent packup aborted.";
	}; 
};

true
