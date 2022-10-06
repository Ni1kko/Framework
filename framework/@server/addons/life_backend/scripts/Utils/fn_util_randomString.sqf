#include "\life_backend\serverDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

//call MPServer_fnc_util_randomString

private _createvar = compile '
	private _numbers = "0987654321";
	private _alphabet = "zyxwvutsrqponmlkjihgfedcba";
	private _out = toString[selectRandom(toArray _alphabet)];
	for "_i" from 0 to (random [7,9,13]) do {
		private _char = selectRandom [
			_alphabet select [floor (random 26), 1],
			_numbers  select [floor (random 10), 1]
		];
		_out = _out + selectRandom [
			_char,
			toUpper _char
		];
	};
	_out
';
private _savedvar = compile '
	(((uiNamespace getVariable ["randomVars",[]]) apply {toLower _x}) find toLower _this) isNotEqualTo -1
';
private _savevar = compile '
	private _randomVars = uiNamespace getVariable ["randomVars",[]];
	if((_randomVars pushBackUnique _this) isEqualTo -1)exitWith{false};
	uiNamespace setVariable ["randomVars",_randomVars];
	true
';

private _var = call _createvar;
private _generateNew = true;

if(_var call _savedvar)then{
	while {_generateNew} do {
		_var = call _createvar;
		if !(_var call _savedvar)then{
			if (_var call _savevar)exitWith{
				_generateNew = false;
			};
		};
	};
}else{
	_var call _savevar;
}; 

_var