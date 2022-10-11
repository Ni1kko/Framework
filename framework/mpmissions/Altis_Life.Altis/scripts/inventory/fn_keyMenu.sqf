#include "..\..\clientDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
	## fn_keyMenu.sqf
*/
disableSerialization;

params [
    ["_display", displayNull, [displayNull]]
];

private _vehiclesListbox = _display displayCtrl 4;
lbClear _vehiclesListbox;

private _playerListbox = _display displayCtrl 5;
lbClear _playerListbox;

//-- Add houses\vehicles
if(count life_var_vehicles > 0)then{
    {
        private _color = ((M_CONFIG(getArray,"cfgVehicleArsenal",(typeOf _x),"textures") select (_x getVariable "Life_VEH_color")) select 0);
        private _name = getText(configFile >> "CfgVehicles" >> (typeOf _x) >> "displayName");
        private _pic = getText(configFile >> "CfgVehicles" >> (typeOf _x) >> "picture");
        private _text = format ["(%1)",[_color, ""] select (isNil "_color")];

        //-- Bad format, fix
        if (_text in ["()","(any)"]) then {_text = ""};
        
        _vehiclesListbox lbAdd format ["%1 %3 - [Distance: %2m]",_name,round(player distance _x),_text];

        if (_pic != "pictureStaticObject") then {
            _vehiclesListbox lbSetPicture [_forEachIndex,_pic];
        };

        _vehiclesListbox lbSetData [_forEachIndex, str(_x)];
        _vehiclesListbox lbSetValue [_forEachIndex, _forEachIndex];
    }forEach life_var_vehicles;     
}else{
    _vehiclesListbox lbAdd localize "STR_NOTF_noVehOwned";
    _vehiclesListbox lbSetData [(lbSize _vehiclesListbox)-1,""];
};

private _nearPlayers = ((playableUnits apply {if (player distance _x < 20) then {_x}else{""}}) - [""]);

//-- Add Players
if(count _nearPlayers > 0)then{
    { 
        _playerListbox lbAdd format ["%1 - %2",_x getVariable ["realname",name _x], side _x];
        _playerListbox lbSetData [_forEachIndex,str(_x)]; 
    } forEach _nearPlayers;
}else{
    _playerListbox lbAdd "No Players Nearby";
    _playerListbox lbSetData [(lbSize _playerListbox)-1,str(objNull)]; 
};

_display