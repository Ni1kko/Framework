/*
	## Nikko Renolds
	## https://github.com/Ni1kko/Framework
*/

if(!canSuspend)exitWith{_this spawn life_fnc_lottery_init};

waitUntil {isFinal "extdb_var_database_key" AND isFinal "life_var_federlReserveReady"}; 

diag_log "[Life Lottery] Initializing...";

private _vaultObject = missionNamespace getVariable ["fed_bank",objNull];

Life_var_lottoDrawLock = false;

life_var_lotto_config = compileFinal str [
	getNumber(configFile >> "CfgLottery" >> "ticketPrice")
];

publicVariable "life_var_lotto_config";

//-- Delete dead tickets from database
["CALL", "deleteOldLotteryTickets"] call life_fnc_database_request;
 
private _timer = 0;
while {true} do
{
	uiSleep (10 * 60);
	_timer = _timer + 1;
	switch (_timer) do {
		case 3:  { [0,"The Altis Lottery will be drawn in 90 minutes."] remoteExec ["life_fnc_broadcast",0]; };
		case 6:  { [0,"The Altis Lottery will be drawn in 1 Hour."] remoteExec ["life_fnc_broadcast",0]; };
		case 9:  { [0,"The Altis Lottery will be drawn in 30 Minutes."] remoteExec ["life_fnc_broadcast",0]; };
		case 11: { [0,"The Altis Lottery will be drawn in 10 Minutes."] remoteExec ["life_fnc_broadcast",0]; Life_var_lottoDrawLock = true; publicVariable "Life_var_lottoDrawLock"; };
		case 12: { [_vaultObject] spawn life_fnc_lottery_pickwinners; _timer = 0; };
	};
};
