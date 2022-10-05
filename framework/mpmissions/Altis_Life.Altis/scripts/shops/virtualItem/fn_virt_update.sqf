#include "..\..\..\script_macros.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
    ## fn_virt_update.sqf
*/

disableSerialization;

//Setup control vars.
private _item_list = CONTROL(2400,2401);
private _gear_list = CONTROL(2400,2402);

//Purge list
lbClear _item_list;
lbClear _gear_list;

if (!isClass(missionConfigFile >> "cfgVirtualShops" >> life_shop_type)) exitWith {closeDialog 0; hint localize "STR_NOTF_ConfigDoesNotExist";}; //Make sure the entry exists..
ctrlSetText[2403,localize (M_CONFIG(getText,"cfgVirtualShops",life_shop_type,"name"))];

for "_i" from 1 to 2 do {
    {
        private _displayName = M_CONFIG(getText,"cfgVirtualItems",_x,"displayName");
        private _buyprice = M_CONFIG(getNumber,"cfgVirtualItems",_x,"buyPrice");
        private _sellprice = M_CONFIG(getNumber,"cfgVirtualItems",_x,"sellPrice");
        private _quantity = -1;

        switch _i do {
            case 1:
            {   //--- SHOP GEAR
                _quantity = 99;//temp (0 = no stock)
                if (_buyprice isNotEqualTo -1) then {

                    private _itemName = format ["%1 - ($%2)",TEXT_LOCALIZE(_displayName),[_buyprice] call MPClient_fnc_numberText];
                       
                    if(_quantity < 1)then{
                        _itemName = format ["%1 - (OUT OF STOCK)",TEXT_LOCALIZE(_displayName)];
                        _buyprice = -1;
                    }else{
                        _itemName = format (if (_buyprice isEqualTo 0) then {
                            ["%1 - (FREE)",TEXT_LOCALIZE(_displayName)]
                        }else{
                            ["%1 - ($%2)",TEXT_LOCALIZE(_displayName),[_buyprice] call MPClient_fnc_numberText]
                        });
                    };

                    _item_list lbAdd _itemName;
                    _item_list lbSetData [(lbSize _item_list)-1,_x];
                    _item_list lbSetValue [(lbSize _item_list)-1,_buyprice];
                    _icon = M_CONFIG(getText,"cfgVirtualItems",_x,"icon");
                    if (_icon isNotEqualTo "") then {
                        _item_list lbSetPicture [(lbSize _item_list)-1,_icon];
                    };
                };
                
            };
            case 2: 
            {   //--- PLAYER GEAR
                _quantity = ITEM_VALUE(_x);
                if (_quantity > 0) then {
                    _gear_list lbAdd format (if(_sellprice isNotEqualTo -1)then{ 
                        ["%2 - (x%1)",_quantity,TEXT_LOCALIZE(_displayName)];
                    }else{
                        ["%2 - (x%1) [Non Sellable]",_quantity,TEXT_LOCALIZE(_displayName)]; 
                    });
                    _gear_list lbSetData [(lbSize _gear_list)-1,_x]; 
                    _icon = M_CONFIG(getText,"cfgVirtualItems",_x,"icon");
                    if (_icon isNotEqualTo "") then {
                        _gear_list lbSetPicture [(lbSize _gear_list)-1,_icon];
                    };
                };
            };
        };
    } forEach M_CONFIG(getArray,"cfgVirtualShops",life_shop_type,"items");
};