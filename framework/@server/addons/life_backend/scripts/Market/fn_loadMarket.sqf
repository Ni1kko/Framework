/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

if(!isNil "life_var_marketConfig")exitWith{false};
life_var_marketConfig = createHashMap;

["[Life Market] Loading..."] call MPServer_fnc_log;
 
//-- Get market values or create them
for "_currentIndex" from 0 to (count(missionConfigFile >> "VirtualItems") - 1) do {
	[_currentIndex,true] call MPServer_fnc_getMarketDataValue;
	uiSleep 0.2;
};

//-- Update market prices
{  
	private _item = life_var_marketConfig getOrDefault [_x,createHashMap];
	private _buyPrice = _item getOrDefault ["buyPrice",-1];
	private _sellPrice = _item getOrDefault ["sellPrice",-1];
	private _illegal = _item getOrDefault ["illegal",false];
	private _stock = _item getOrDefault ["stock",-1];
	private _needsUpdate = false;


	//TODO: SOME CALCULATIONS AND ALTER BUY & SELL PRICES
	
	
	if _needsUpdate then{ 
		[_item,createHashMapFromArray[
			["buyPrice",_buyPrice],
			["sellPrice",_sellPrice],
			["illegal",_illegal],
			["stock",_stock]
		]] call MPServer_fnc_setMarketDataValue;
		uiSleep 0.2;
	};
}forEach life_var_marketConfig;
 
//-- Broadcast values
publicVariable "life_var_marketConfig";

["[Life Market] Loaded!"] call MPServer_fnc_log;

true