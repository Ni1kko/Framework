/*
    File: fn_packupSpikes.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Packs up a deployed spike strip.
*/
private ["_spikes"];
_spikes = nearestObjects[getPos player,["Land_Razorwire_F"],8] select 0;
if (isNil "_spikes") exitWith {};

if (["ADD","spikeStrip",1] call MPClient_fnc_handleVitrualItem) then {
    titleText[localize "STR_NOTF_SpikeStrip","PLAIN"];
    player removeAction life_action_spikeStripPickup;
    life_action_spikeStripPickup = nil;
    deleteVehicle _spikes;
};