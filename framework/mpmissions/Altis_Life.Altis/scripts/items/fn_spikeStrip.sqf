#include "..\..\clientDefines.hpp"
/*
    File: fn_spikeStrip.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Creates a spike strip and preps it.
*/
private ["_spikeStrip"];
if (!isNil "life_action_spikeStripPickup") exitWith {hint localize "STR_ISTR_SpikesDeployment"};    // avoid conflicts with addactions allowing duplication.
_spikeStrip = "Land_Razorwire_F" createVehicle [0,0,0];
_spikeStrip attachTo[player,[0,5.5,0]];
_spikeStrip setDir 90;
_spikeStrip setVariable ["item","spikeDeployed",true];

life_action_spikeStripDeploy = player addAction[localize "STR_ISTR_Spike_Place",{if (!isNull life_var_vehicleStinger) then {detach life_var_vehicleStinger; life_var_vehicleStinger = objNull;}; player removeAction life_action_spikeStripDeploy; life_action_spikeStripDeploy = nil;},"",999,false,false,"",'!isNull life_var_vehicleStinger'];
life_var_vehicleStinger = _spikeStrip;
waitUntil {isNull life_var_vehicleStinger};

if (!isNil "life_action_spikeStripDeploy") then {player removeAction life_action_spikeStripDeploy;};
if (isNull _spikeStrip) exitWith {life_var_vehicleStinger = objNull;};

_spikeStrip setPos [(getPos _spikeStrip select 0),(getPos _spikeStrip select 1),0];
_spikeStrip setDamage 1;

life_action_spikeStripPickup = player addAction[localize "STR_ISTR_Spike_Pack",MPClient_fnc_packupSpikes,"",0,false,false,"",
' _spikes = nearestObjects[getPos player,["Land_Razorwire_F"],8] select 0; !isNil "_spikes" && !isNil {(_spikes getVariable "item")}'];

if (count extdb_var_database_headless_clients > 0) then {
    [_spikeStrip] remoteExec ["HC_fnc_spikeStrip",extdb_var_database_headless_client]; //Send it to the HeadlessClient for monitoring.
} else {
    [_spikeStrip] remoteExec ["MPServer_fnc_spikeStrip",RE_SERVER]; //Send it to the server for monitoring.
};
