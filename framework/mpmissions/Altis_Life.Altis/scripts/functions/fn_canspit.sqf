/*

	Function: 	MPClient_fnc_canspit
	Project: 	AsYetUntitled/Framework
	Author:     Nikko
	Github:		https://github.com/AsYetUntitled/Framework
	
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
	diag_log  str _this;
};

true