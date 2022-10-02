/*

	Function: 	MPClient_fnc_escInterupt
	Project: 	AsYetUntitled
	Author:     Tonic, Nikko, IceEagle132
	Github:		https://github.com/Ni1kko/FrameworkV2
	
*/

disableSerialization;  
 
private _escSync = {
    disableSerialization;

    //Timer Finished Disapy Exit Button
    if(_this)then{
        private _thread = [] spawn {
            disableSerialization;
            private _timeStamp = time + 10;
            waitUntil {
                ((uiNamespace getVariable "RscDisplayMPInterrupt") displayCtrl 104) ctrlSetText format[localize "STR_NOTF_AbortESC",[(_timeStamp - time),"SS.MS"] call BIS_fnc_secondsToString];
                ((uiNamespace getVariable "RscDisplayMPInterrupt") displayCtrl 104) ctrlCommit 0;
                round(_timeStamp - time) <= 0 || isNull (uiNamespace getVariable "RscDisplayMPInterrupt")
            };
            ((uiNamespace getVariable "RscDisplayMPInterrupt") displayCtrl 104) ctrlSetText "Exit";
            ((uiNamespace getVariable "RscDisplayMPInterrupt") displayCtrl 104) ctrlCommit 0;
        };
        waitUntil{scriptDone _thread || isNull (uiNamespace getVariable "RscDisplayMPInterrupt")};
        ((uiNamespace getVariable "RscDisplayMPInterrupt") displayCtrl 104) ctrlEnable true; //Enable Exit Button
    };
};

private _SaveSync = {
    disableSerialization;

    //Timer Finished Disapy save Button
    if((life_var_lastSynced + (5 * 60)) < time)then{
        private _thread = [] spawn {
            disableSerialization;
            private _timeStamp = life_var_lastSynced + (5 * 60);
            waitUntil {
                ((uiNamespace getVariable ["RscDisplayMPInterrupt",displayNull]) displayCtrl 103) ctrlSetText format["SyncData Blocked For %1",[(_timeStamp - time),"SS.MS"] call BIS_fnc_secondsToString];
                ((uiNamespace getVariable ["RscDisplayMPInterrupt",displayNull]) displayCtrl 103) ctrlCommit 0;
                round(_timeStamp - time) <= 0 || isNull (uiNamespace getVariable ["RscDisplayMPInterrupt",displayNull])
            }; 
            ((uiNamespace getVariable ["RscDisplayMPInterrupt",displayNull])displayCtrl 103) ctrlSetText "Sync Data";
            ((uiNamespace getVariable ["RscDisplayMPInterrupt",displayNull]) displayCtrl 103) ctrlCommit 0;
        };
        waitUntil{scriptDone _thread || isNull (uiNamespace getVariable ["RscDisplayMPInterrupt",displayNull])};
        ((uiNamespace getVariable ["RscDisplayMPInterrupt",displayNull]) displayCtrl 103) ctrlEnable true; //Enable Save Btn
    };
};

private _canUseControls = {
    (playerSide isEqualTo west) || {!((player getVariable ["restrained",false]) || {player getVariable ["Escorting",false]} || {player getVariable ["transporting",false]} || {life_var_arrested} || {life_var_tazed} || {life_var_unconscious})}
};

//Handle Esacpe Menu > Configure Btn
[]spawn{
    for "_i" from 0 to 1 step 0 do {
        //Esc > Game
        waitUntil{!isNull (uiNamespace getVariable ["RscDisplayGameOptions",displayNull])};
        //Difficulty
        ((uiNamespace getVariable "RscDisplayGameOptions") displayCtrl 304) ctrlEnable false;
        ((uiNamespace getVariable "RscDisplayGameOptions") displayCtrl 304) ctrlSetText "Disabled"; 
        //Colors
        ((uiNamespace getVariable "RscDisplayGameOptions") displayCtrl 2404) ctrlEnable true;
        ((uiNamespace getVariable "RscDisplayGameOptions") displayCtrl 2404) ctrlSetText "Game Colors";
        //Layout
        ((uiNamespace getVariable "RscDisplayGameOptions") displayCtrl 2405) ctrlEnable false;
        ((uiNamespace getVariable "RscDisplayGameOptions") displayCtrl 2405) ctrlSetText "AntiCheat Patch";
        
        waitUntil{isNull (uiNamespace getVariable ["RscDisplayGameOptions",displayNull])};
    };
};

//Handle Esacpe Menu
for "_i" from 0 to 1 step 0 do {
    waitUntil{!isNull (uiNamespace getVariable ["RscDisplayMPInterrupt",displayNull])};
    
    //Name
    ((uiNamespace getVariable "RscDisplayMPInterrupt") displayCtrl 523) ctrlSetText profileName;
    ((uiNamespace getVariable "RscDisplayMPInterrupt") displayCtrl 523) ctrlSetToolTip "Your Arma3 Profile Name";

    //SteamID (Short)
    ((uiNamespace getVariable "RscDisplayMPInterrupt") displayCtrl 109) ctrlSetText format["%1|%2",(profileNameSteam),([(getPlayerUID player), 12, 17] call BIS_fnc_trimString)];
    ((uiNamespace getVariable "RscDisplayMPInterrupt") displayCtrl 109) ctrlSetToolTip "SteamName & Last 5 Number Of Your SteamID";

    //Continue Btn
    ((uiNamespace getVariable "RscDisplayMPInterrupt") displayCtrl 2) ctrlEnable true; //Continue
    ((uiNamespace getVariable "RscDisplayMPInterrupt") displayCtrl 2) ctrlSetText "Resume";//Continue

    //Save Btn
    ((uiNamespace getVariable "RscDisplayMPInterrupt") displayCtrl 103) ctrlRemoveAllEventHandlers "ButtonDown";
    ((uiNamespace getVariable "RscDisplayMPInterrupt") displayCtrl 103) ctrlEnable true;
    ((uiNamespace getVariable "RscDisplayMPInterrupt") displayCtrl 103) ctrlSetText "Sync Data";
    ((uiNamespace getVariable "RscDisplayMPInterrupt") displayCtrl 103) ctrlSetToolTip "Sync Player Data To Hive";
    ((uiNamespace getVariable "RscDisplayMPInterrupt") displayCtrl 103) ctrlAddEventHandler ["ButtonDown", "[] call MPClient_fnc_syncData"];

    //Respawn Btn
    ((uiNamespace getVariable "RscDisplayMPInterrupt") displayCtrl 1010) ctrlEnable false;
    ((uiNamespace getVariable "RscDisplayMPInterrupt") displayCtrl 1010) ctrlSetText "Respawn";
    ((uiNamespace getVariable "RscDisplayMPInterrupt") displayCtrl 1010) ctrlSetToolTip "Kills You And Gives You A New Life & Choice Of Spawn Locations";

    //Configure Btn
    ((uiNamespace getVariable "RscDisplayMPInterrupt") displayCtrl 101) ctrlSetText "Game Options";
    ((uiNamespace getVariable "RscDisplayMPInterrupt") displayCtrl 101) ctrlEnable true;
    ((uiNamespace getVariable "RscDisplayMPInterrupt") displayCtrl 101) ctrlSetToolTip "Configure Arma Options";

    //Field manual Btn
    ((uiNamespace getVariable "RscDisplayMPInterrupt") displayCtrl 122) ctrlRemoveAllEventHandlers "ButtonDown";
    ((uiNamespace getVariable "RscDisplayMPInterrupt") displayCtrl 122) ctrlEnable false;
    ((uiNamespace getVariable "RscDisplayMPInterrupt") displayCtrl 122) ctrlSetText "Disabled"; 
    ((uiNamespace getVariable "RscDisplayMPInterrupt") displayCtrl 122) ctrlSetToolTip "";
    
    //Exit Btn
    ((uiNamespace getVariable "RscDisplayMPInterrupt") displayCtrl 104) ctrlRemoveAllEventHandlers "ButtonDown";
    ((uiNamespace getVariable "RscDisplayMPInterrupt") displayCtrl 104) ctrlEnable false;
    ((uiNamespace getVariable "RscDisplayMPInterrupt") displayCtrl 104) ctrlSetText "Exit";
    ((uiNamespace getVariable "RscDisplayMPInterrupt") displayCtrl 104) ctrlAddEventHandler ["ButtonDown", "_this spawn MPClient_fnc_abort"];
    ((uiNamespace getVariable "RscDisplayMPInterrupt") displayCtrl 104) ctrlSetToolTip "Abandon Server And Sync Data";

    
    //Enable Contols
    _usebleCtrl = call _canUseControls; 
    _usebleCtrl spawn _escSync;
    if(_usebleCtrl)then{
        //Respawn Btn.
        ((uiNamespace getVariable "RscDisplayMPInterrupt") displayCtrl 1010) ctrlEnable true;
        //SaveBtn
        []spawn _SaveSync;
    };
    waitUntil{isNull (uiNamespace getVariable ["RscDisplayMPInterrupt",displayNull])};
};