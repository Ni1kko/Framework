/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

params [
	["_mode","",[""]],
	["_type","",[""]],
	["_val",nil]
];

//--- Handle Bad input
if (isNil "_val") exitWith {""};
if !(_mode in ["DB","GAME"]) exitWith {_val};
if !(_type in ["ARRAY","STRING","BOOL","ENUM","A2NET","LICENSES","POSITION","TEXT"]) exitWith {_val};

//--- Mode... where are we parsing too?
switch (_mode) do {
	case "DB": 
	{
		//Type... what are we parsing?
		switch (_type) do {
			case "ARRAY": //Array => (MYSQL conversion)
			{     
				_val = toArray str _val;
				{
					if(_x isEqualTo 34)then{
						_val set [_forEachIndex,96]; // " => `		
					};
					if(_x isEqualTo 92)then{
						_val set [_forEachIndex,63]; // / => ?	
					};
				}forEach _val;
				_val = str(str(toString _val));
			};
			case "LICENSES":
			{   
				_val = ["DB","ARRAY", (_val apply{
					[_x#0,["DB","BOOL", _x#1] call MPServer_fnc_database_parse]
				})] call MPServer_fnc_database_parse;
			};
			case "STRING": //String => (MYSQL Real-Escape)
			{   
				_val = toArray _val;
				{
					switch true do {
						case (_x == 34): {_val set [_forEachIndex,96]};//replace
						case (_x in [39,47,92,58,124,59,44,123,125,45,34,60,62]): {_val deleteAt _forEachIndex};//delete
					};
				} forEach _val;
				_val = str toString _val; 
			};
			case "TEXT": //String => (MYSQL text safe)
			{
				_val = str(str(_val)); 
			};
			case "POSITION": //Position => (MYSQL Position safe)
			{
				_val = if (typeName _val isEqualTo "ARRAY") then {_val} else {[]};
				_val = if (count _val isEqualTo 3) then {_val} else {[0,0,0]};
				_val = toArray str _val;
        		_val = str(toString _val);
			};
			case "BOOL": //Bool => (MYSQL Tiny-int)
			{
				if (_val isEqualType 0) then {
					_val = 0;
				}else{
					_val = if (_val) then {1} else {0};
				};
			};
			case "ENUM": //Int => (MYSQL enum)
			{
				if !(typeName _val isEqualTo "STRING")then{
					_val = str _val;
				};
			};
			case "A2NET": //A2NET Money => (MYSQL int)
			{ 
				if(typeName _val isEqualTo "STRING")then{
					_val = parseNumber _val;
				};
				_val = _val call bis_fnc_numberDigits;
				private _a = "";
				{_a = _a + str _x;if (((_foreachindex - ((count _val - 1) % 3)) % 3) isEqualTo 0 && _foreachindex != (count _val - 1)) then {_a = _a + "";};} forEach _val;
				_val = _a;
			};
		};
	};
	case "GAME": 
	{
		//Type... what are we parsing?
		switch (_type) do {
			case "ARRAY": //MYSQL Real-Escape => (Array)
			{   
				_val = toArray _val;
				{
					if(_x isEqualTo 96)then{
						_val set [_forEachIndex,34]; // ` => "
					};
					if(_x isEqualTo 63)then{
						_val set [_forEachIndex,92]; // ? => /	
					};
				}forEach _val;

				_val = toString _val;

				while {typeName _val isEqualTo "STRING"} do {
					_val = call compile _val;	
				};
			};
			case "LICENSES":
			{   
				_val = (["GAME","ARRAY", _val] call MPServer_fnc_database_parse) apply{
					[_x#0,["GAME","BOOL", _X#1] call MPServer_fnc_database_parse]
				};
			};
			case "POSITION": //Position => (MYSQL Position safe)
			{
				while {typeName _val isEqualTo "STRING"} do {
					_val = call compile _val;	
				};
			};
			case "STRING": //MYSQL Real-Escape => (String)
			{  
				_val = toArray _val;
				{
					switch true do {
						case (_x == 96): {_val set [_forEachIndex,34]};//replace
						case (_x in [39,47,92,58,124,59,44,123,125,45,34,60,62]): {_val deleteAt _forEachIndex};//delete
					};
				} forEach _val;
				_val = toString _val;
			};
			case "BOOL": //MYSQL Tiny-int => (Bool)
			{ 
				if (!(_val isEqualType 0)) then {
					_val = false;
				}else{
					switch (_val) do {
						case 0: {_val = false};
						case 1: {_val = true};
					};
				};
			};
			case "ENUM": //MYSQL enum => (int)
			{
				if(typeName _val isEqualTo "STRING")then{
					_val = parseNumber _val;
				};
			};
			case "A2NET": //MYSQL int => (A2NET int)
			{
				if(typeName _val isEqualTo "STRING")then{
					_val = parseNumber _val;
				};
			};
		};
	};
};

_val