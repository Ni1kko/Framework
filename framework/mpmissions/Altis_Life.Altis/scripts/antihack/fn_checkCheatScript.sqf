#include "..\..\script_macros.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
	## fn_checkCheatScript.sqf
*/

params [
    ["_cheat", "", [""]]
];

private _acceptedMessage = "";

switch (toUpper _cheat) do 
{
	case "FLUSH": 			{_acceptedMessage = "Memory flushed!"};
	case "ENDMISSION": 		{_acceptedMessage = "Mission Ending!"; [] spawn life_var_abortScript};
	case "SAVEGAME": 		{_acceptedMessage = "Saving Data!"; [] spawn life_var_syncScript};
	case "FREEZE": 			{_acceptedMessage = "Can't freeze but have a crash instead!"; ["onCheatFreeze"] spawn MPClient_fnc_clientCrash};
	case "FPS": 			{_acceptedMessage = "FPS limit changed!"};
	///////////////////////////////////////////////////////////////
	case "GETALLGEAR": 		{["Hack Detected", "Cheat Code Detected", "Antihack"] call MPClient_fnc_endMission;};
	///////////////////////////////////////////////////////////////
	case "CAMPAIGN"; 		//-- Disabled for MP (Use default code)
	case "MISSIONS";		//-- Disabled for MP (Use default code)
	case "TOPOGRAPHY";		//-- Disabled for MP (Use default code)
	case "EXPORTNOGRID";	//-- Disabled for MP (Use default code)
	///////////////////////////////////////////////////////////////
	default 				{[] spawn life_var_abortScript};
};

if(count _acceptedMessage > 0) exitWith {
	_acceptedMessage = (((["Cheat Accepted", _acceptedMessage]) - [""]) joinString ", ");
	systemChat _acceptedMessage;
	true
};

false