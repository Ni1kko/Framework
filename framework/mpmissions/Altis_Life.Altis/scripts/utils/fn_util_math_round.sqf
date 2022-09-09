/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

private["_number", "_decimalPlaces"];
_number = _this select 0;
_decimalPlaces = _this select 1;
round (_number * (10 ^ _decimalPlaces)) / (10 ^ _decimalPlaces)