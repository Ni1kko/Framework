/*

	Function: 	MPClient_fnc_addBuff
	Project: 	AsYetUntitled
	Author:     Merrick, Nikko, Affect & IceEagle132
	
*/
params [
	["_type","",[""]],	
	["_section","",[""]],
	["_time",0,[0]]
];

private _types = ["bleeding","painShock","critHit"];

private _fnc_addBuff = {
	params ["_bufftype"];
	switch _bufftype do {
		case "bleeding" : {[_section,_time] spawn MPClient_fnc_effects_bleeding};
		case "painShock" : {[_section,_time] spawn MPClient_fnc_effects_painShock};
		case "critHit" : {[_section,_time] spawn MPClient_fnc_effects_critHit};
	};
};

if(_type isEqualTo "all")then{
	{
		[_x] call _fnc_addBuff;
	} foreach _types;
}else{
	[_x] call _fnc_addBuff;
};

true