
private _scripts = [
    "dev.cs"
];
 
private _scriptsDir = format["%1\scripts",getText(configFile >> "CfgFunctions" >> "Life" >> "Scriptloader_Functions" >> "file")];

{ 
    private _path = format["%1\%2",_scriptsDir,_x];
    private _pointer = [_path] call life_fnc_loadscript;
    if (_pointer) then {
        private _name = (_x splitString ".")#0;
        uiNamespace setVariable [format["%1_pointer",_name], compileFinal str _pointer];
        diag_log format['[life_fnc_preInit] script #%1[%2] loaded! => %3', _pointer, _x, _path];
    };
}forEach _scripts;