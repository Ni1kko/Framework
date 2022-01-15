/*
	life_fnc_loadscript

	Description:
	Loads a script.

	Parameter(s):
	_this select 0: Path to script to load (String)
	
	Returns:
	A pointer to use to invoke the loaded script (Number)
*/

params [
	['_filepath', '', ['']]
];

private _params = format['load%1%2%1', toString[10], _filepath];
private _result = "armaext" callExtension _params;

if (_result == 'ERROR') exitWith {
	diag_log '[life_fnc_loadscript] error - check console';
	false
};

private _pointer = parseNumber _result;

_pointer