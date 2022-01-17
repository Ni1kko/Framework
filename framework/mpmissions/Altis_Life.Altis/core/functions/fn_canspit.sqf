/*

	Function: 	life_fnc_canspit
	Project: 	AsYetUntitled/Framework
	Author:     Nikko
	Github:		https://github.com/AsYetUntitled/Framework
	
*/

if(missionNamespace getVariable ["testparmas_runonce",true])then{
	testparmas_runonce = false;
	systemChat str _this;
	hint str _this;
	diag_log  str _this;
};

true