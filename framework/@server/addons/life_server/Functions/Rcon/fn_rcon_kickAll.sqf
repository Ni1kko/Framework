/*
	## Nikko Renolds
	## https://github.com/Ni1kko/Framework
*/

private["_i"];

private _playableSlotsNumber = 0;

{
	_playableSlotsNumber = _playableSlotsNumber +  ((playableSlotsNumber _x) - 1);
}forEach[east,west,independent,civilian];

for "_i" from 0 to _playableSlotsNumber do {
	[_i] call life_fnc_rcon_kick;
};

true