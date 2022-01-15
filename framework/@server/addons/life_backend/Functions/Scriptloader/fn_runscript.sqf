/*
	life_fnc_runscript

	Description:
	Runs a script.

	Parameter(s):
	_this select 0: Pointer to the script to run (Number)

	_this select 1: Arguments to send to the script (String)
	
	Returns:
	The results of the invoked script (String)
*/

params [
	['_name', '', ['']],
	['_args', '', ['']]
];

private _pointer = uiNamespace getVariable [format["%1_pointer",_name], {-1}];

if (!isFinal _pointer) exitWith {false};

private _pointerID = parseNumber _pointer;//parseNumber is safe to get result compile is not

if (_pointerID isEqualTo -1) exitWith {false};
private _result = "armaext" callExtension format['run%1%2%1%3%1', toString[10], _pointerID, _args];

if (_result == 'ERROR') exitWith {
	diag_log '[life_fnc_runscript] error - check console';
	false
};

_result