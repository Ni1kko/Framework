#include "\life_backend\script_macros.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

params [
	["_currentItem",-1,[-1,""]],
	["_forceDatabaseRead",false,[false]],
	["_forceBroadcast",false,[false]]
];

private _cfgItem = configNull;
private _cfgVirtualItems = missionConfigFile >> "cfgVirtualItems";
if (typeName _currentItem isEqualTo "STRING")then{
	if(_cfgItem isNotEqualTo "")then{
		_cfgItem = _cfgVirtualItems >> _currentItem;
	};
}else{
	if(_currentItem >= 0)then{
		_cfgItem = _cfgVirtualItems select _currentItem;
	};
};

if(isNull _cfgItem OR not(isClass _cfgItem))exitWith{createHashMap};

private _item = configName(_cfgItem);
private _buyPrice = getNumber(_cfgItem >> "buyPrice");
private _sellPrice = getNumber(_cfgItem >> "sellPrice");
private _illegal = getNumber(_cfgItem >> "illegal") isEqualTo 1;
private _data = life_var_marketConfig getOrDefault [_item,createHashMap];

if(_forceDatabaseRead OR not(_item in keys life_var_marketConfig))then
{
	private _queryMarket = ["READ", "market", 
		[
			["item", "buyPrice", "sellPrice", "illegal", "stock"],
			[
				["item",["DB","STRING", _item] call MPServer_fnc_database_parse]
			]
		],
		true
	] call MPServer_fnc_database_request;
	
	if(count _queryMarket isEqualTo 0)then{
		_data set ["buyPrice", 	["GAME","INT", _buyPrice] call MPServer_fnc_database_parse];
		_data set ["sellPrice",	["GAME","INT", _sellPrice] call MPServer_fnc_database_parse];
		_data set ["illegal", 	["GAME","BOOL", _illegal] call MPServer_fnc_database_parse];
		_data set ["stock",		["GAME","INT", round(random 999)] call MPServer_fnc_database_parse];	
		
		["CREATE", "market", 
			[//What
				["item", 			["DB","STRING", _item] call MPServer_fnc_database_parse],
				["buyPrice", 		["DB","INT", _data get "buyPrice"] call MPServer_fnc_database_parse],
				["sellPrice", 		["DB","INT", _data get "sellPrice"] call MPServer_fnc_database_parse],
				["stock", 			["DB","INT", _data get "stock"] call MPServer_fnc_database_parse],
				["illegal", 		["DB","BOOL", _data get "illegal"] call MPServer_fnc_database_parse]
			]
		] call MPServer_fnc_database_request;

		[format["[Life Market] Adding item(%1) to database",_item]] call MPServer_fnc_log;
	}else{
		_data set ["buyPrice", 	["GAME","INT", _queryMarket#1] call MPServer_fnc_database_parse];
		_data set ["sellPrice",	["GAME","INT", _queryMarket#2] call MPServer_fnc_database_parse];
		_data set ["illegal", 	["GAME","BOOL", _queryMarket#3] call MPServer_fnc_database_parse];
		_data set ["stock",		["GAME","INT", _queryMarket#4] call MPServer_fnc_database_parse];

		[format["[Life Market] Loaded item(%1) from database",_item]] call MPServer_fnc_log;
	};

	life_var_marketConfig set [_item, _data];

	if _forceBroadcast then {
		publicVariable "life_var_marketConfig";
	};
};

_data