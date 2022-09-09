/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

params [
	["_input",-1,["",0]]
];

private _mode = switch (true) do {
	case (typeName _input isEqualTo "SCALAR"): {"ownerID"};
	case (count _input isEqualTo 17): {"steamID"};
	default {"BEGUID"};
};

private _player = objNull;

{
	private _find = switch (_mode) do {
		case "steamID": {getPlayerUID _x};
		case "ownerID": {owner _x};
		case "BEGUID": {call (_x getVariable ["BEGUID",{""}])};
	};
	if(_find isEqualTo _input)exitWith{
		_player = _x;
	};
} forEach allPlayers;

_player