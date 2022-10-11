#include "..\..\..\clientDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
    ## fn_clothingMenu.sqf
*/

disableSerialization;

private _shop = param [3, "",[""]];
private _cfgClothing = missionConfigFile >> "CfgClothing";

if (count _shop isEqualTo 0) exitWith {false};
if (not(call MPClient_fnc_isDormant)) exitWith {false}; 
if (not(isNull objectParent player)) exitWith {titleText[localize "STR_NOTF_ActionInVehicle","PLAIN"]; false};
if (not(isClass(_cfgClothing >> _shop))) exitWith {false}; //Bad config entry.

private _cfgClothingShop = _cfgClothing >> _shop;
private _shopTitle = getText(_cfgClothingShop >> "title");
private _shopSide = getText(_cfgClothingShop >> "side");
private _conditions = getText(_cfgClothingShop >> "conditions");
private _playerSide = [playerSide,true] call MPServer_fnc_util_getSideString;
private _hiddenObjects = [];
private _exit = not([_conditions] call MPClient_fnc_checkConditions);
 
if ((count _shopSide > 0 AND _playerSide isNotEqualTo _shopSide) OR _exit) exitWith {

    if _exit exitWith {
        hint localize "STR_Shop_Veh_NoLicense";
    };

    switch (toLower _shopSide) do {
        case "civ":
        {
            if(_shop in ["bruce","dive","reb","kart"])then{
                if((_shop in ["dive"]) AND {not(license_civ_dive)})then{
                    hint localize "STR_Shop_NotaDive";
                }else{ 
                    hint localize "STR_Shop_NotaCiv";
                };
            }else{ 
                hint localize "STR_Shop_NotaCiv";
            };
        };
        case "reb": 
        {
            if(_shop in ["reb"] && {not(license_civ_rebel)})then{
                hint localize "STR_Shop_NotaReb";
            };
        };
        case "cop": {
            if(_shop in ["cop"] && {(call life_coplevel) > 0})then{
                hint localize "STR_Shop_NotaCop";
            };
        };
        default 
        {
            hint "Your factcion are not allowed to use this shop.";
        };
    };
};
 
//Save old inventory
life_oldClothes = uniform player;
life_olduniformItems = uniformItems player;
life_oldBackpack = backpack player;
life_oldVest = vest player;
life_oldVestItems = vestItems player;
life_oldBackpackItems = backpackItems player;
life_oldGlasses = goggles player;
life_oldHat = headgear player;

/* Open up the menu */
private _displayName = "RscDisplayClothingShop";
private _display = createDialog [_displayName,true];

ctrlSetText [3103,localize _shopTitle];

_display displaySetEventHandler ["KeyDown","if ((_this select 1) isEqualTo 1) then {closeDialog 0;}"];

sliderSetRange [3107, 0, 360];

private ["_pos","_oldPos","_oldDir","_oldBev","_testLogic","_nearVeh","_light"];
private ["_ut1","_ut2","_ut3","_ut4","_ut5"];

if (CFG_MASTER(getNumber,"clothing_noTP") isEqualTo 1) then {
    _pos = getPosATL player;
} else {
    if (CFG_MASTER(getNumber,"clothing_box") isEqualTo 1) then {
        _pos = [1000,1000,10000];
    } else {
        _pos = switch _shop do {
            case "reb": {[13590,12214.6,0.00141621]};
            case "cop": {[12817.5,16722.9,0.00151062]};
            case "kart": {[14120.5,16440.3,0.00139236]};
            default {[17088.2,11313.6,0.00136757]};
        };
    };

    _oldDir = getDir player;
    _oldPos = visiblePositionASL player;
    _oldBev = behaviour player;

    _testLogic = "Logic" createVehicleLocal _pos;
    _testLogic setPosATL _pos;

    _nearVeh = _testLogic nearEntities ["AllVehicles", 20];

    if (CFG_MASTER(getNumber,"clothing_box") isEqualTo 1) then {
        _ut1 = "UserTexture10m_F" createVehicleLocal (_testLogic modelToWorld [0,5,10]);
        _ut1 attachTo [_testLogic,[0,5,5]];
        _ut1 setDir 0;
        _ut2 = "UserTexture10m_F" createVehicleLocal (_testLogic modelToWorld [5,0,10]);
        _ut2 attachTo [_testLogic,[5,0,5]];
        _ut2 setDir (getDir _testLogic) + 90;
        _ut3 = "UserTexture10m_F" createVehicleLocal (_testLogic modelToWorld [-5,0,10]);
        _ut3 attachTo [_testLogic,[-5,0,5]];
        _ut3 setDir (getDir _testLogic) - 90;
        _ut4 = "UserTexture10m_F" createVehicleLocal (_testLogic modelToWorld [0,-5,10]);
        _ut4 attachTo [_testLogic,[0,-5,5]];
        _ut4 setDir 180;
        _ut5 = "UserTexture10m_F" createVehicleLocal (_testLogic modelToWorld [0,0,10]);
        _ut5 attachTo [_testLogic,[0,0,0]];
        _ut5 setObjectTexture [0,"a3\map_data\gdt_concrete_co.paa"];
        detach _ut5;
        _ut5 setVectorDirAndUp [[0,0,-.33],[0,.33,0]];
    };

    _light = "#lightpoint" createVehicleLocal _pos;
    _light setLightBrightness 0.5;
    _light setLightColor [1,1,1];
    _light setLightAmbient [1,1,1];
    _light lightAttachObject [_testLogic, [0,0,0]];

    {
        if (_x != player) then {
            _x setVariable ["life_var_hidden",true,true];
            _x hideObject true;
            _hiddenObjects pushBack _x;
        };
        true
    } count playableUnits;
    
    if (CFG_MASTER(getNumber,"clothing_box") isEqualTo 0) then {
        {
            if (_x != player && _x != _light) then {
                _x setVariable ["life_var_hidden",true,true];
                _x hideObject true;
                _hiddenObjects pushBack _x;
            };
            true
        } count _nearVeh;
    };

    if (CFG_MASTER(getNumber,"clothing_box") isEqualTo 1) then {
        {
            _x setObjectTexture [0,"#(argb,8,8,3)color(0,0,0,1)"];
            true
        } count [_ut1,_ut2,_ut3,_ut4];
    };
    player setBehaviour "SAFE";
    if (_shop == "dive") then {
        player setVariable ["teleported",true,true];
        player setPosATL [-1000, -1000, 10];
        sleep 0.0005;
        player setVariable ["teleported",false,true];
    };
    player attachTo [_testLogic,[0,0,0]];
    player switchMove "";
    player setDir 360;
};

life_clothing_store = _shop;

/* Store license check */
if (isClass(missionConfigFile >> "cfgLicenses" >> life_clothing_store)) then {
    _flag = M_CONFIG(getText,"cfgLicenses",life_clothing_store,"side");
    _displayName = M_CONFIG(getText,"cfgLicenses",life_clothing_store,"displayName");
    if !(LICENSE_VALUE(life_clothing_store,_flag)) exitWith {
        hint format [localize "STR_Shop_YouNeed",localize _displayName];
        closeDialog 0;
    };
};

//initialize camera view
life_shop_cam = "CAMERA" camCreate getPos player;
showCinemaBorder false;
life_shop_cam cameraEffect ["Internal", "Back"];
life_shop_cam camSetTarget (player modelToWorld [0,0,1]);
life_shop_cam camSetPos (player modelToWorld [1,4,2]);
life_shop_cam camSetFOV .33;
life_shop_cam camSetFocus [50, 0];
life_shop_cam camCommit 0;
life_cMenu_lock = false;

if (isNull _display) exitWith {
    {
        _x hideObject false;
        _x setVariable ["life_var_hidden",false,true];
        true
    } count _hiddenObjects;
    false
};

private _list = _display displayCtrl 3101;
private _filter = _display displayCtrl 3105;
lbClear _filter;
lbClear _list;

_filter lbAdd localize "STR_Shop_UI_Clothing";
_filter lbAdd localize "STR_Shop_UI_Hats";
_filter lbAdd localize "STR_Shop_UI_Glasses";
_filter lbAdd localize "STR_Shop_UI_Vests";
_filter lbAdd localize "STR_Shop_UI_Backpack";

_filter lbSetCurSel 0;

waitUntil {isNull _display};

{
    _x hideObject false;
    _x setVariable ["life_var_hidden",false,true];
    true
} count _hiddenObjects;

if (CFG_MASTER(getNumber,"clothing_noTP") isEqualTo 0) then 
{
    detach player;
    player setBehaviour _oldBev;
    player setVariable ["teleported",true,true];
    player setPosASL _oldPos;
    player setDir _oldDir;
    player setVariable ["teleported",false,true];
    if (CFG_MASTER(getNumber,"clothing_box") isEqualTo 1) then {
        {
            deleteVehicle _x;
        } count [_testLogic,_ut1,_ut2,_ut3,_ut4,_ut5,_light];
    } else {
        {
            deleteVehicle _x;
            true
        } count [_testLogic,_light];
    };
};
life_shop_cam cameraEffect ["TERMINATE","BACK"];
camDestroy life_shop_cam;
life_var_clothingTraderFilter = 0;
if (isNil "life_clothesPurchased") exitWith {
    life_var_clothingTraderData = [-1,-1,-1,-1,-1];
    if !(life_oldClothes isEqualTo "") then {player addUniform life_oldClothes;} else {removeUniform player};
    if !(life_oldHat isEqualTo "") then {player addHeadgear life_oldHat} else {removeHeadgear player;};
    if !(life_oldGlasses isEqualTo "") then {player addGoggles life_oldGlasses;} else {removeGoggles player};
    if !(backpack player isEqualTo "") then {
        if (life_oldBackpack isEqualTo "") then {
            removeBackpack player;
        } else {
            removeBackpack player;
            player addBackpack life_oldBackpack;
            clearAllItemsFromBackpack player;
            if (count life_oldBackpackItems > 0) then {
                {
                    [_x,true,true] call MPClient_fnc_handleItem;
                    true
                } count life_oldBackpackItems;
            };
        };
    };

    if (count life_oldUniformItems > 0) then {
        {
            [_x,true,false,false,true] call MPClient_fnc_handleItem;
            true
        } count life_oldUniformItems;
    };

    if (vest player != "") then {
        if (life_oldVest isEqualTo "") then {
            removeVest player;
        } else {
            player addVest life_oldVest;
            if (count life_oldVestItems > 0) then {
                {
                    [_x,true,false,false,true] call MPClient_fnc_handleItem;
                    true
                } count life_oldVestItems;
            };
        };
    };
};
life_clothesPurchased = nil;

//Check uniform purchase.
if ((life_var_clothingTraderData select 0) isEqualTo -1) then {
    if (life_oldClothes != uniform player) then {player addUniform life_oldClothes;};
};
//Check hat
if ((life_var_clothingTraderData select 1) isEqualTo -1) then {
    if (life_oldHat != headgear player) then {
        if (life_oldHat isEqualTo "") then {
            removeHeadGear player;
        } else {
            player addHeadGear life_oldHat;
        };
    };
};
//Check glasses
if ((life_var_clothingTraderData select 2) isEqualTo -1) then {
    if (life_oldGlasses != goggles player) then {
        if (life_oldGlasses isEqualTo "") then  {
            removeGoggles player;
        } else {
            player addGoggles life_oldGlasses;
        };
    };
};
//Check Vest
if ((life_var_clothingTraderData select 3) isEqualTo -1) then {
    if (life_oldVest != vest player) then {
        if (life_oldVest isEqualTo "") then {removeVest player;} else {
            player addVest life_oldVest;
            {
                [_x,true,false,false,true] call MPClient_fnc_handleItem;
                true
            } count life_oldVestItems;
        };
    };
};

//Check Backpack
if ((life_var_clothingTraderData select 4) isEqualTo -1) then {
    if (life_oldBackpack != backpack player) then {
        if (life_oldBackpack isEqualTo "") then {removeBackpack player;} else {
            removeBackpack player;
            player addBackpack life_oldBackpack;
            {
                [_x,true,true] call MPClient_fnc_handleItem;
                true
            } count life_oldBackpackItems;
        };
    };
};

life_var_clothingTraderData = [-1,-1,-1,-1,-1];
