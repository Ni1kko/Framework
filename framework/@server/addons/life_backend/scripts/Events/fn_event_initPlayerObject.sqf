/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
    ## fn_event_initPlayerObject.sqf
*/

param [
    ["_unit", objNull, [objNull]]
];
 
if (isServer) then
{ 
    //Random clothing for our NPC's to add a bit of spice. 
    if(getNumber(configFile >> "CfgEvents" >> "randomNPC_Uniforms") == 1) then
    {
        if (local _unit && !isPlayer _unit) then
        {
            _unit forceAddUniform (selectRandom getArray(configFile >> "CfgEvents" >> "NPC_Uniforms"));
        };
    };

    //
    if(getNumber(configFile >> "CfgEvents" >> "fixHeadGear") == 1) then
    {
        [_unit] call MPServer_fnc_fix_headgear;
    };
};

true