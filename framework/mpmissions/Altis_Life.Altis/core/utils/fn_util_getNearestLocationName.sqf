/*
	## Nikko Renolds
	## https://github.com/Ni1kko/Framework
*/

private _locationName = "";
private _locations = nearestLocations [
	param[0,[]],
	param[2,[
		"NameCityCapital",	
		"NameCity",		
		"NameVillage",		
		"NameLocal",		
		"Hill",		
		"NameMarine"		
	]],
	param[1,500]
];

if (count _locations > 0) then {
	private _location = _locations#0;
	_locationName = if ((name _location) == "") then {text _location}else{name _location};
};

_locationName