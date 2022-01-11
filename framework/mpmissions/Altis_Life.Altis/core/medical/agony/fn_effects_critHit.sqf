/*

	Function: 	life_fnc_effects_critHit
	Project: 	Misty Peaks RPG
	Author:     Tonic, Merrick, Nikko, Affect & IceEagle132
	
*/
private["_sound","_critColorEffect"];
    while {life_var_critHit} do {
        uiSleep (15*60);
        if (life_var_critHit && alive(player) && player == vehicle player) then {
            _critColorEffect = ppEffectCreate ["colorCorrections", 2008];
            _critColorEffect ppEffectEnable true;
            _critColorEffect ppEffectAdjust [1, 1.1, -0.05, [0.4, 0.2, 0.3, -0.1], [0.3, 0.05, 0, 0], [0.5,0.5,0.5,0], [0,0,0,0,0,0,4]];
            _critColorEffect ppEffectCommit 18;
            [player,"ActsPknlMstpSnonWnonDnon_TreatingInjured_NikitinDead",true,true] remoteExecCall ["life_fnc_animSync",-2];
            _sound = ["action_cry_0", "action_cry_1"] call BIS_fnc_selectRandom;
            player say3D _sound;
            for "_i" from 1 to 20 do {
                titleText[format["You have a traumatic shock caused by a serious injury! You will wake up in %1 sec.", (21 - _i)],"PLAIN"];
                uiSleep 1;
                if (!alive(player) OR !life_var_critHit) exitWith {};
            };
            switch (true) do {
                case (!alive(player)) : {};
                case (player getVariable ["restrained",false]) : {player playMove "AmovPercMstpSnonWnonDnon_Ease"};
                default {[player,"amovpercmstpsnonwnondnon",true,true] remoteExecCall ["life_fnc_animSync",-2];};
            };
            ppEffectDestroy [_critColorEffect];
            player setFatigue 1;
            titleText["","PLAIN"];
        };
    };