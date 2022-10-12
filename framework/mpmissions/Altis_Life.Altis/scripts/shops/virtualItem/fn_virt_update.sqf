#include "..\..\..\clientDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
    ## fn_virt_update.sqf
*/

disableSerialization;

//-- Make sure the entry exists..
if not(isClass(missionConfigFile >> "cfgVirtualShops" >> life_shop_type)) exitWith {
    hint localize "STR_NOTF_ConfigDoesNotExist";
    closeDialog 0; 
    false
};

//-- Setup control vars.
private _item_list = CONTROL(2400,2401);
private _gear_list = CONTROL(2400,2402);
private _title = CONTROL(2400,2403);

//-- Purge lists
lbClear _item_list;
lbClear _gear_list;

//-- Setup shop title
_title ctrlSetText (localize (M_CONFIG(getText,"cfgVirtualShops",life_shop_type,"name")));

//-- 
for "_i" from 1 to 2 do {
    {
        private _marketData = life_var_marketConfig getOrDefault [_x,[]];
        private _displayName = ITEM_DISPLAYNAME(_x);
        private _buyprice = _marketData getOrDefault ["buyPrice",ITEM_SELLPRICE(_x)];
        private _sellprice = _marketData getOrDefault ["sellPrice",ITEM_BUYPRICE(_x)];
        private _illegal =_marketData getOrDefault ["illegal",ITEM_ILLEGAL(_x)];
        private _stock = _marketData getOrDefault ["stock",-1];
 
        switch _i do {
            case 1:
            {   //--- SHOP GEAR
                if (_stock > 0 AND _buyprice >= 0) then {

                    private _itemName = format (if (_buyprice isEqualTo 0) then {
                        ["%1 - (FREE)",_displayName]
                    }else{
                        ["%1 - ($%2)",_displayName,[_buyprice] call MPClient_fnc_numberText]
                    });

                    _item_list lbAdd _itemName;
                       
                    if(_stock < 1)then{
                        _item_list lbSetTextRight format["(OUT OF STOCK)",_stock];
                        _item_list lbSetColorRight [1,0,0,1];
                        _buyprice = -1;//STOP Puchasing item
                    }else{
                        _item_list lbSetTextRight format["(%1 IN STOCK)",_stock];
                        _item_list lbSetColorRight [0,1,0,1];
                    };

                    _item_list lbSetData [(lbSize _item_list)-1,_x];
                    _item_list lbSetValue [(lbSize _item_list)-1,_buyprice];
                    _icon = ITEM_ICON(_x);
                    if (_icon isNotEqualTo "") then {
                        _item_list lbSetPicture [(lbSize _item_list)-1,_icon];
                    };
                }; 
            };
            case 2: 
            {   //--- PLAYER GEAR
                _stock = ITEM_VALUE(_x);
                if (_stock > 0) then {
                    _gear_list lbAdd format ["%1",_displayName];

                    if(_sellprice isEqualTo -1)then{ 
                        _item_list lbSetTextRight format["[Non Sellable] - (%1 STOCK)",_stock];
                        _item_list lbSetColorRight [1,0,0,1];
                    }else{
                        _item_list lbSetTextRight format["(%1 STOCK)",_stock];
                        _item_list lbSetColorRight [0,1,0,1];
                    };

                    _gear_list lbSetData [(lbSize _gear_list)-1,_x]; 
                    _icon = ITEM_ICON(_x);
                    if (_icon isNotEqualTo "") then {
                        _gear_list lbSetPicture [(lbSize _gear_list)-1,_icon];
                    };
                };
            };
        };
    } forEach (keys life_var_marketConfig);
};

true