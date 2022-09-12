/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

life_var_marketConfig = createHashMap;

private _virtualItems = []; 
private _cfgVirtualItems = missionConfigFile >> "VirtualItems";

//-- Get market values or create them
for "_currentItem" from 0 to (count _cfgVirtualItems - 1) do
{
	private _cfgItem = _cfgVirtualItems select _currentItem;
	private _item = configName(_cfgItem);
	private _buyPrice = getNumber(_cfgItem >> "buyPrice");
	private _sellPrice = getNumber(_cfgItem >> "sellPrice");
	private _illegal = getNumber(_cfgItem >> "illegal") isEqualTo 1;
	
	private _queryMarket = ["READ", "market", 
		[
			["item", "buyPrice", "sellPrice", "illegal", "stock"],
			[
				["item",["DB","STRING", _item] call MPServer_fnc_database_parse]
			]
		],
		true
	] call MPServer_fnc_database_request;

	private _data = createHashMapFromArray [
		["buyPrice",_buyPrice],
		["sellPrice",_sellPrice],
		["illegal",_illegal],
		["stock",round(random 999)]
	];

	if(count _queryMarket isEqualTo 0)then{
		["CREATE", "market", 
			[//What
				["item", 			["DB","STRING", _item] call MPServer_fnc_database_parse],
				["buyPrice", 		["DB","INT", _data get "buyPrice"] call MPServer_fnc_database_parse],
				["sellPrice", 		["DB","INT", _data get "sellPrice"] call MPServer_fnc_database_parse],
				["stock", 			["DB","INT", _data get "stock"] call MPServer_fnc_database_parse],
				["illegal", 		["DB","BOOL", _data get "illegal"] call MPServer_fnc_database_parse]
			]
		] call MPServer_fnc_database_request;
	}else{
		_data set ["buyPrice", 	["GAME","INT", _queryMarket#1] call MPServer_fnc_database_parse];
		_data set ["sellPrice",	["GAME","INT", _queryMarket#2] call MPServer_fnc_database_parse];
		_data set ["illegal", 	["GAME","BOOL", _queryMarket#3] call MPServer_fnc_database_parse];
		_data set ["stock",		["GAME","INT", _queryMarket#4] call MPServer_fnc_database_parse];
	};
	
	life_var_marketConfig set [_item, _data];

	uiSleep 0.2;
};

//-- Update market prices
{  
	private _item = life_var_marketConfig getOrDefault [_x,createHashMap];
	private _buyPrice = _item getOrDefault ["buyPrice",-1];
	private _sellPrice = _item getOrDefault ["sellPrice",-1];
	private _illegal = _item getOrDefault ["illegal",false];
	private _stock = _item getOrDefault ["stock",-1];

}forEach life_var_marketConfig;
 
//-- Broadcast values
publicVariable "life_var_marketConfig";

true