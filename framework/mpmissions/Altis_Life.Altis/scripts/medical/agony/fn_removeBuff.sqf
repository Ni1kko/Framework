/*

	Function: 	MPClient_fnc_removeBuff
	Project: 	AsYetUntitled
	Author:     Merrick, Nikko, Affect & IceEagle132
	
*/
private _type = param [0,"",[""]];
if (_type == "") exitWith {};

private _types = ["bleeding","painShock","critHit"];

private _fnc_removeBuff = {
	params ["_bufftype"];
	switch _bufftype do {
        case "bleeding" : {life_var_bleeding = false};
        case "painShock" : {life_var_painShock = false};
        case "critHit" : {life_var_critHit = false};
	};
};

if(_type in ["all","revived"])then{
	switch (_type) do 
    {
        case "all": 
        {
            {
                [_x] call _fnc_removeBuff;
            } foreach _types;
        };
        case "revived":
        {
            ["bleeding"] call _fnc_removeBuff;
            ["critHit"] call _fnc_removeBuff;
        };
    };
}else{
	[_x] call _fnc_removeBuff;
};



