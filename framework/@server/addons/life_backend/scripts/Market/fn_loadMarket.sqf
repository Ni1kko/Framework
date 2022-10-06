#include "\life_backend\serverDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

if(!isNil "life_var_marketConfig")exitWith{false};
life_var_marketConfig = createHashMap;

["[Life Market] Loading..."] call MPServer_fnc_log;
 
//-- Get market values or create them
for "_currentIndex" from 0 to (count(missionConfigFile >> "cfgVirtualItems") - 1) do {
	[_currentIndex,true] call MPServer_fnc_getMarketDataValue;
	uiSleep 0.2;
};

//-- Update market prices
{  
	private _item = life_var_marketConfig getOrDefault [_x,createHashMap];
	private _buyPrice = _item getOrDefault ["buyPrice",getNumber(missionConfigFile >> "cfgVirtualItems" >> _x >> "buyPrice")];
	private _sellPrice = _item getOrDefault ["sellPrice",getNumber(missionConfigFile >> "cfgVirtualItems" >> _x >> "sellPrice")];
	private _illegal = _item getOrDefault ["illegal",getNumber(missionConfigFile >> "cfgVirtualItems" >> _x >> "illegal") isEqualTo 1];
	private _stock = _item getOrDefault ["stock",getNumber(missionConfigFile >> "cfgVirtualItems" >> _x >> "stock")];

	
	//TODO: SOME CALCULATIONS AND ALTER BUY & SELL PRICES 
	if(_x in ["goldbar"])then{
		_buyPrice = getNumber(missionConfigFile >> "cfgVirtualItems" >> _x >> "buyPrice");
		_sellPrice = getNumber(missionConfigFile >> "cfgVirtualItems" >> _x >> "sellPrice");
		_stock = -1;
		_needsUpdate = true;
	}else{

		if(_buyPrice isNotEqualTo -1)then{
			_buyPrice = ceil (_amount * (_x select 1));
			if(_buyPrice < 0) then {
				_buyPrice = -(_buyPrice);
			};
		};
	

		if(_stock isEqualTo 0)then{
			_sellPrice = _sellPrice * 1.2; 
		}else{
			_buyPrice = _buyPrice / call compile (format["1.%1",_stock]);
			_sellPrice = _sellPrice / call compile (format["1.%1",_stock]);
		};
	};
  
	[_x,createHashMapFromArray[
		["buyPrice",_buyPrice],
		["sellPrice",_sellPrice],
		["illegal",_illegal],
		["stock",_stock]
	]] call MPServer_fnc_setMarketDataValue;
	uiSleep 0.2;
 
}forEach life_var_marketConfig;
 
//-- Broadcast values
publicVariable "life_var_marketConfig";

["[Life Market] Loaded!"] call MPServer_fnc_log;

true