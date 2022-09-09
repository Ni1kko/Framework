/*
	## EXTREMO Survival
	## Nikko Renolds
*/

private["_currentMagazineClassName", "_currentAmmoCount", "_magazineCapacity", "_factor"];
_currentMagazineClassName = _this select 0;
_currentAmmoCount = _this select 1;
_magazineCapacity = getNumber (configFile >> "CfgMagazines" >> _currentMagazineClassName >> "count");
_factor = 0;
if (_magazineCapacity > 0) then 
{
	_factor = 1 - _currentAmmoCount / _magazineCapacity;
};
_factor