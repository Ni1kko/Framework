#include "..\..\clientDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
    ## fn_startLoadout.sqf
*/

//-- Removing every default items before adding the custom ones
[player,false] call MPClient_fnc_stripDownPlayer;

private _uniforms = M_CONFIG(getArray,"cfgDefaultLoadouts",str(playerSide),"uniform"); 

//-- Pick random uniform
if (count _uniforms > 0) then {
    if (playerSide in [civilian,east]) then {
        _uniforms = [selectRandom _uniforms];
    };
};

//-- Item Array (item, condition)
{
    private _array = _x;
    if (count _array > 0) then {
        {
            _x params [
                ["_item","",[""]],
                ["_condition","",[""]]
            ];
            
            if(count _condition isEqualTo 0)then{_condition = "true"};
            if (count _item > 0 AND {[_condition] call MPClient_fnc_checkConditions}) then {
                [_item,true] call MPClient_fnc_handleItem
            };
        } forEach _array;
    };
} forEach [
    _uniforms,
    M_CONFIG(getArray,"cfgDefaultLoadouts",str(playerSide),"headgear"),
    M_CONFIG(getArray,"cfgDefaultLoadouts",str(playerSide),"vest"),
    M_CONFIG(getArray,"cfgDefaultLoadouts",str(playerSide),"backpack"),
    M_CONFIG(getArray,"cfgDefaultLoadouts",str(playerSide),"weapon"),
    M_CONFIG(getArray,"cfgDefaultLoadouts",str(playerSide),"linkedItems")
];

//-- Item Array (item, amount condition)
{
    private _array = _x;
    if (count _array > 0) then {
        {
            _x params [
                ["_item","",[""]],
                ["_amount",0,[0]],
                ["_condition","",[""]]
            ];
            if(count _item > 0)then{
                if(_amount isEqualTo 0)then{_amount = 1};
                if(count _condition isEqualTo 0)then{_condition = "true"};
                if([_condition] call MPClient_fnc_checkConditions)then{
                    for "_i" from 1 to _amount step 1 do {[_item,true] call MPClient_fnc_handleItem};
                };
            };
        }forEach _array;
    };
} forEach [
    M_CONFIG(getArray,"cfgDefaultLoadouts",str(playerSide),"mags"),
    M_CONFIG(getArray,"cfgDefaultLoadouts",str(playerSide),"items")
];

//-- Vitem Array (item, amount condition)
{
    private _array = _x;
    if (count _array > 0) then {
        {
            _x params [
                ["_item","",[""]],
                ["_amount",0,[0]],
                ["_condition","",[""]]
            ];
            if(count _item > 0)then{
                if(_amount isEqualTo 0)then{_amount = 1};
                if(count _condition isEqualTo 0)then{_condition = "true"};
                if([_condition] call MPClient_fnc_checkConditions)then{
                    [true,_item,_amount] call MPClient_fnc_handleInv;
                };
            };
        }forEach _array;
    };
} forEach [
    M_CONFIG(getArray,"cfgDefaultLoadouts",str(playerSide),"vitems"),
    M_CONFIG(getArray,"cfgDefaultLoadouts",str(playerSide),"vitemFoods"),
    M_CONFIG(getArray,"cfgDefaultLoadouts",str(playerSide),"vitemsDrinks")
];

true
