/*
    File:           fn_hudSetup.sqf
    Author:         Bryan "Tonic" Boardwine
    Edited on:      22.08.2021
    Edited by:      https://github.com/Ni1kko
    Description:    Keeps hud active and updated
*/
disableSerialization;

private _damage = damage player;
private _alive = life_is_alive;
private _thirst = life_thirst;
private _hunger = life_hunger;

while {true} do 
{
    //-- hide when admin menu is shown
    if(!isNull(findDisplay 1776) OR !isNull(findDisplay 49))then{
        //-- hide hud
        if (!isNull (uiNamespace getVariable ["playerHUD",displayNull])) then {
            ("life_var_hudlayer" call BIS_fnc_rscLayer) cutText ["","PLAIN"];
        };
        //-- Wait for changes
        waitUntil {
            !isNull (uiNamespace getVariable ["playerHUD",displayNull])
            OR
            (isNull(findDisplay 1776) AND isNull(findDisplay 49))
        };
    }else{
        //-- hud hidden bring it back
        if (isNull (uiNamespace getVariable ["playerHUD",displayNull])) then {
            ("life_var_hudlayer" call BIS_fnc_rscLayer) cutRsc ["playerHUD", "PLAIN", 2, false];
        };

        //-- Update hud
        ((uiNamespace getVariable ["playerHUD",displayNull]) displayCtrl 2200) progressSetPosition (_hunger / 100);
        ((uiNamespace getVariable ["playerHUD",displayNull]) displayCtrl 2201) progressSetPosition ([0,(1 - _damage)] select _alive);
        ((uiNamespace getVariable ["playerHUD",displayNull]) displayCtrl 2202) progressSetPosition (_thirst / 100);
        
        //-- Wait for changes
        waitUntil {
            isNull (uiNamespace getVariable ["playerHUD",displayNull])
            OR
            !isNull(findDisplay 1776)//overlays hud
            OR
            !isNull(findDisplay 49)//overlays hud
            OR
            _damage isNotEqualTo (damage player)
            OR
            _alive isNotEqualTo life_is_alive
            OR
            _thirst isNotEqualTo life_thirst
            OR
            _hunger isNotEqualTo life_hunger
        };
        
        _damage = damage player;
        _alive = life_is_alive;
        _thirst = life_thirst;
        _hunger = life_hunger;
    };
};  
