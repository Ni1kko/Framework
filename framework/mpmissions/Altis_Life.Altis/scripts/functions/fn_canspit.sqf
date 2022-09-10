/*

	Function: 	MPClient_fnc_canspit
	Project: 	AsYetUntitled/Framework
	Author:     Nikko
	Github:		https://github.com/Ni1kko/FrameworkV2
	
*/

params [
	["_target",objNull,[objNull]],
	["_thisobj",objNull,[objNull]],
	["_originalTarget",objNull,[objNull]], 
	["_cursorTarget",objNull,[objNull]]
];

if(missionNamespace getVariable ["testparmas_runonce",true])then{
	testparmas_runonce = false;
	systemChat str _this;
	hint str _this;
	[(str _this)] call MPClient_fnc_log;
};

true