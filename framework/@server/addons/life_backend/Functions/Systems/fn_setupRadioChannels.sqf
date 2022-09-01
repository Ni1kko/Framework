/*
	## Nikko Renolds
	## https://github.com/Ni1kko/Framework
*/

{
    _x params [
        ["_channelVar", "", [""]],
        ["_channelName", "", [""]],
        ["_channelColor", [0.5,1,0.5,1], [[]]]
    ];

    private _channelData = [_channelColor, _channelName, "%UNIT_NAME", []];
    private _channelIndex = radioChannelCreate _channelData;
    
    missionNamespace setVariable [_channelVar, _channelIndex];

    if(_channelIndex >= 0) then {
        life_var_radioChannels pushBackUnique [_channelVar, _channelIndex, _channelData];
    };
}forEach [
    ["life_radio_west",  "Side Channel",    [0, 0.95, 1, 0.8]],
    ["life_radio_east",  "Side Channel",    [0, 0.95, 1, 0.8]],
    ["life_radio_civ",   "Side Channel",    [0, 0.95, 1, 0.8]],
    ["life_radio_indep", "Side Channel",    [0, 0.95, 1, 0.8]],
    ["life_radio_staff", "Staff Channel",   [0.05, 1, 0.25, 0.8]]
];

true