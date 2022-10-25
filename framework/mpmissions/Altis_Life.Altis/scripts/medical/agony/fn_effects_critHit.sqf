/*

	Function: 	MPClient_fnc_effects_critHit
	Project: 	AsYetUntitled
	Author:     Merrick, Nikko, Affect & IceEagle132
	
*/
params [
	["_section","",[""]],
	["_time",0,[0]]
];

if(life_var_critHitRunning) exitWith{false};
life_var_critHitRunning = true;

while {life_var_critHit} do 
{
    sleep (15*60);
    if (life_var_critHit && alive(player) && player == vehicle player) then 
    {
        private _critColorEffect = ppEffectCreate ["colorCorrections", 2008];
        _critColorEffect ppEffectEnable true;
        _critColorEffect ppEffectAdjust [1, 1.1, -0.05, [0.4, 0.2, 0.3, -0.1], [0.3, 0.05, 0, 0], [0.5,0.5,0.5,0], [0,0,0,0,0,0,4]];
        _critColorEffect ppEffectCommit 18;
        [player,"ActsPknlMstpSnonWnonDnon_TreatingInjured_NikitinDead",true,true] remoteExecCall ["MPClient_fnc_animSync",-2];
        private _sound = ["action_cry_0", "action_cry_1"] call BIS_fnc_selectRandom;
        player say3D _sound;
        for "_i" from 1 to 20 do {
            titleText[format["You have a traumatic shock caused by a serious injury! You will wake up in %1 sec.", (21 - _i)],"PLAIN"];
            sleep 1;
            if (!alive(player) OR !life_var_critHit) exitWith {};
        };
        switch (true) do {
            case (!alive(player)) : {};
            case (player getVariable ["restrained",false]) : {player playMove "AmovPercMstpSnonWnonDnon_Ease"};
            default {[player,"amovpercmstpsnonwnondnon",true,true] remoteExecCall ["MPClient_fnc_animSync",-2];};
        };
        ppEffectDestroy [_critColorEffect];
        player setFatigue 1;
        titleText["","PLAIN"];
    };
};

life_var_critHitRunning = false;

true