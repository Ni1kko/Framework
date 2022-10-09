#include "..\..\clientDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
	## fn_updateControlPos.sqf

	private _control = ((findDisplay 602) displayCtrl 77700);
	
	[_control, "xy", [0, 0.22]] call MPClient_fnc_updateControlPos
*/

disableSerialization;

private _control = param [0, controlNull, [controlNull]];
private _axis = param [1, "x", [""]];
private _originalPos = ctrlPosition _control;
private _updatedPos = _originalPos;

_originalPos params [
	["_originalPosX", 0, [0]],
	["_originalPosY", 0, [0]],
	["_originalPosW", 0, [0]],
	["_originalPosH", 0, [0]]
];

switch (_axis) do {
	case "x": {_control ctrlSetPositionX (param [2, _originalPosX, [0]])};
	case "y": {_control ctrlSetPositionY (param [2, _originalPosY, [0]])};
	case "w": {_control ctrlSetPositionW (param [2, _originalPosW, [0]])};
	case "h": {_control ctrlSetPositionH (param [2, _originalPosH, [0]])};
	case "xy": {
		private _pos = param [2, [], [[]]];
		_control ctrlSetPositionX (_pos param [0, _originalPosX, [0]]);
		_control ctrlSetPositionY (_pos param [1, _originalPosY, [0]]);
	};
	case "wh": {
		private _pos = param [2, [], [[]]];
		_control ctrlSetPositionW (_pos param [0, _originalPosW, [0]]);
		_control ctrlSetPositionH (_pos param [1, _originalPosH, [0]]);
	};
	case "xywh": {
		private _pos = param [2, [], [[]]];
		_control ctrlSetPosition [
			_pos param [0, _originalPosX, [0]],
			_pos param [2, _originalPosY, [0]],
			_pos param [2, _originalPosW, [0]],
			_pos param [3, _originalPosH, [0]]
		];
	};
};

_control ctrlCommit 0;
_updatedPos = ctrlPosition _control;

//--Return (Mainly for debugging)
[
	["oldPos",_originalPos],
	["newPos",_updatedPos]
]