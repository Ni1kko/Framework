/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

params [
	["_type", "", [""]]
]; 

if(isRemoteExecuted)exitWith{false};

private _folderPath = format ["%1\crashFiles",getText(configFile >> "CfgFunctions" >> "Antihack" >> "file")];
private _errorFile = format ["%1\%2.sqf",_folderPath, switch (_type) do {
	case "ah": {"hacker"};
	default {"error"};
}];

_nul = [] spawn compile preprocessFileLineNumbers _errorFile;

true