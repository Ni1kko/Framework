/*

	Function: 	life_fnc_escInterupt
	Project: 	AsYetUntitled
	Author:     Tonic, Nikko, IceEagle132
	Github:		https://github.com/AsYetUntitled/Framework
	
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
                ((findDisplay 49) displayCtrl 104) ctrlSetText format[localize "STR_NOTF_AbortESC",[(_timeStamp - time),"SS.MS"] call BIS_fnc_secondsToString];
                ((findDisplay 49) displayCtrl 104) ctrlCommit 0;
                round(_timeStamp - time) <= 0 || isNull (findDisplay 49)
            };
            ((findDisplay 49) displayCtrl 104) ctrlSetText "Exit";
            ((findDisplay 49) displayCtrl 104) ctrlCommit 0;
        };
        waitUntil{scriptDone _thread || isNull (findDisplay 49)};
        ((findDisplay 49) displayCtrl 104) ctrlEnable true; //Enable Exit Button
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
                ((findDisplay 49) displayCtrl 103) ctrlSetText format["SyncData Blocked For %1",[(_timeStamp - time),"SS.MS"] call BIS_fnc_secondsToString];
                ((findDisplay 49) displayCtrl 103) ctrlCommit 0;
                round(_timeStamp - time) <= 0 || isNull (findDisplay 49)
            }; 
            ((findDisplay 49) displayCtrl 103) ctrlSetText "Sync Data";
            ((findDisplay 49) displayCtrl 103) ctrlCommit 0;
        };
        waitUntil{scriptDone _thread || isNull (findDisplay 49)};
        ((findDisplay 49) displayCtrl 103) ctrlEnable true; //Enable Save Btn
    };
};

private _canUseControls = {
    (playerSide isEqualTo west) || {!((player getVariable ["restrained",false]) || {player getVariable ["Escorting",false]} || {player getVariable ["transporting",false]} || {life_is_arrested} || {life_istazed} || {life_isknocked})}
};

//Handle Esacpe Menu > Configure Btn
[]spawn{
    for "_i" from 0 to 1 step 0 do {
        //Esc > Game
        waitUntil{!isNull (uiNamespace getVariable "RscDisplayGameOptions")};
        //Difficulty
        ((uiNamespace getVariable "RscDisplayGameOptions") displayCtrl 304) ctrlEnable false;
        ((uiNamespace getVariable "RscDisplayGameOptions") displayCtrl 304) ctrlSetText "Disabled"; 
        //Colors
        ((uiNamespace getVariable "RscDisplayGameOptions") displayCtrl 2404) ctrlEnable true;
        ((uiNamespace getVariable "RscDisplayGameOptions") displayCtrl 2404) ctrlSetText "Game Colors";
        //Layout
        ((uiNamespace getVariable "RscDisplayGameOptions") displayCtrl 2405) ctrlEnable false;
        ((uiNamespace getVariable "RscDisplayGameOptions") displayCtrl 2405) ctrlSetText "AntiCheat Patch";
        
        waitUntil{isNull (uiNamespace getVariable "RscDisplayGameOptions")};
    };
};

//Handle Esacpe Menu
for "_i" from 0 to 1 step 0 do {
    waitUntil{!isNull (findDisplay 49)};
    
    //Name
    ((findDisplay 49) displayCtrl 523) ctrlSetText profileName;
    ((findDisplay 49) displayCtrl 523) ctrlSetToolTip "Your Arma3 Profile Name";

    //SteamID (Short)
    ((findDisplay 49) displayCtrl 109) ctrlSetText format["%1|%2",(profileNameSteam),([(getPlayerUID player), 12, 17] call BIS_fnc_trimString)];
    ((findDisplay 49) displayCtrl 109) ctrlSetToolTip "SteamName & Last 5 Number Of Your SteamID";

    //Continue Btn
    ((findDisplay 49) displayCtrl 2) ctrlEnable true; //Continue
    ((findDisplay 49) displayCtrl 2) ctrlSetText "Resume";//Continue

    //Save Btn
    ((findDisplay 49) displayCtrl 103) ctrlEnable false;
    ((findDisplay 49) displayCtrl 103) ctrlSetText "Sync Data";
    ((findDisplay 49) displayCtrl 103) ctrlSetToolTip "Sync Player Data To Hive";
    ((findDisplay 49) displayCtrl 103) buttonSetAction "[] call SOCK_fnc_syncData";

    //Respawn Btn
    ((findDisplay 49) displayCtrl 1010) ctrlEnable false;
    ((findDisplay 49) displayCtrl 1010) ctrlSetText "Respawn";
    ((findDisplay 49) displayCtrl 1010) ctrlSetToolTip "Kills You And Gives You A New Life & Choice Of Spawn Locations";

    //Configure Btn
    ((findDisplay 49) displayCtrl 101) ctrlSetText "Game Options";
    ((findDisplay 49) displayCtrl 101) ctrlEnable true;
    ((findDisplay 49) displayCtrl 101) ctrlSetToolTip "Configure Arma Options";

    //Field manual Btn
    ((findDisplay 49) displayCtrl 122) ctrlEnable false;
    ((findDisplay 49) displayCtrl 122) ctrlSetText "Disabled"; 
    ((findDisplay 49) displayCtrl 122) ctrlSetToolTip "";
    
    //Exit Btn
    ((findDisplay 49) displayCtrl 104) ctrlEnable false;
    ((findDisplay 49) displayCtrl 104) ctrlSetText "Exit";
    ((findDisplay 49) displayCtrl 104) buttonSetAction "[] call life_fnc_abort;";
    ((findDisplay 49) displayCtrl 104) ctrlSetToolTip "Abandon Server And Sync Data";
    
    //Enable Contols
    _usebleCtrl = call _canUseControls; 
    _usebleCtrl spawn _escSync;
    if(_usebleCtrl)then{
        //Respawn Btn.
        ((findDisplay 49) displayCtrl 1010) ctrlEnable true;
        //SaveBtn
        []spawn _SaveSync;
    };
    waitUntil{isNull (findDisplay 49)};
};