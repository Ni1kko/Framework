#include "..\..\clientDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
	## fn_updateControlPos.sqf
	
	[602, 77700, "xy", [0.609, 0.032]] call MPClient_fnc_updateControlPos;
*/

disableSerialization;

private _idd = param [0, -1, [0]];
private _idc = param [1, -1, [0]];
private _axis = param [2, "x", [""]];

private _control = ((findDisplay _idd) displayCtrl _idc);
private _originalPos = ctrlPosition _control;
private _updatedPos = _originalPos;

_originalPos params [
	["_originalPosX", 0, [0]],
	["_originalPosY", 0, [0]],
	["_originalPosW", 0, [0]],
	["_originalPosH", 0, [0]]
];

switch (_axis) do {
	case "x": {_control ctrlSetPositionX (param [3, _originalPosX, [0]])};
	case "y": {_control ctrlSetPositionY (param [3, _originalPosY, [0]])};
	case "w": {_control ctrlSetPositionW (param [3, _originalPosW, [0]])};
	case "h": {_control ctrlSetPositionH (param [3, _originalPosH, [0]])};
	case "xy": {
		private _pos = param [3, [], [[]]];
		_control ctrlSetPositionX (_pos param [0, _originalPosX, [0]]);
		_control ctrlSetPositionY (_pos param [1, _originalPosY, [0]]);
	};
	case "wh": {
		private _pos = param [3, [], [[]]];
		_control ctrlSetPositionW (_pos param [0, _originalPosW, [0]]);
		_control ctrlSetPositionH (_pos param [1, _originalPosH, [0]]);
	};
	case "xywh": {
		private _pos = param [3, [], [[]]];
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