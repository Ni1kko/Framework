/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

private["_input", "_output"];
_input = _this;
_output = [];
{
	_output pushBack (toLower _x);
} forEach _input;
_output