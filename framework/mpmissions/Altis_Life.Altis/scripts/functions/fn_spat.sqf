/*

	Function: 	MPClient_fnc_spat
	Project: 	AsYetUntitled/Framework
	Author:     Nikko
	Github:		https://github.com/Ni1kko/FrameworkV2
	
*/

params [
	["_shooter", objNull, [objNull]],
	["_shooterDistance", -1, [0]]
];

//no dupilcates
if (!isNull (uiNamespace getVariable ["RscTitleSpitScreen", displayNull])) then {
	("RscTitleSpitScreen" call BIS_fnc_rscLayer) cutText ["","PLAIN"];
};

//new effect
hint format["Eww Gross\n%1 spat on you", name _shooter];
("RscTitleSpitScreen" call BIS_fnc_rscLayer) cutRsc [_resource,"PLAIN",0,false];

//remove effect
[7] spawn {
    scriptName 'MPClient_fnc_spitEffects';
	params [
		["_delay",0,[0]]
	];

	if(_delay < 2)then {
		_delay = 2;
	};
	
	private _timestamp = time + _delay;

	waitUntil{
		uiSleep 1;
		time > _timestamp
	};

	("RscTitleSpitScreen" call BIS_fnc_rscLayer) cutText ["","PLAIN"];
};