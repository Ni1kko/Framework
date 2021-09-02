/*
	## Nikko Renolds
	## https://github.com/Ni1kko/Framework
*/

private _newAction = _this;
private _previousAction = player getvariable ["AutoRunPreviousAction",""];

if !(_newAction isEqualTo _previousAction) then {
	player playActionNow _newAction;
	player playAction _newAction;
	player setVariable ["AutoRunPreviousAction", _newAction];
} else {
	player playAction _newAction;
	player playAction _newAction;
};