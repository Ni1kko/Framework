/*
	## Nikko Renolds
	## https://github.com/Ni1kko/Framework
*/

if(!canSuspend)exitWith{_this spawn life_fnc_lottery_init};

diag_log "[Life Lottery] Initializing...";
waitUntil {isFinal "extdb_var_database_key" AND isFinal "life_var_federlReserveReady"}; 

private _timer = 0;
private _vaultObject = missionNamespace getVariable ["fed_bank",objNull];

Life_var_lottoDrawLock = false;
life_var_lotto_config = compileFinal str [
	getNumber(configFile >> "CfgLottery" >> "ticketPrice"),
	getNumber(configFile >> "CfgLottery" >> "ticketLength"),
	getNumber(configFile >> "CfgLottery" >> "ticketDrawCount"),
	getNumber(configFile >> "CfgLottery" >> "ticketsReclaim") isEqualTo 1
];

publicVariable "life_var_lotto_config";

(call life_var_lotto_config) params [
	"_ticketPrice",
	"_ticketLength",
	"_ticketDrawCount",
	"_ticketsReclaim"
];

systemTimeUTC params ["_year","_month","_day","_hour","_minute","_second"];

//-- Run database procedures
["CALL", "deleteOldLotteryTickets"] call life_fnc_database_request;

//--
if _ticketsReclaim then{
	[] spawn life_fnc_lottery_checkOldTickets;
};

diag_log "[Life Lottery] Initialized!";

//-- Start the lottery
while {_day in [4,11,17,24,31]} do
{
	uiSleep (10 * 60);

	_timer = _timer + 1;
	
	switch (_timer) do 
	{
		case 3:  { [0,"The Altis Lottery will be drawn today in 90 minutes."] remoteExec ["life_fnc_broadcast",0]; };
		case 6:  { [0,"The Altis Lottery will be drawn today in 60 minutes."] remoteExec ["life_fnc_broadcast",0]; };
		case 9:  { [0,"The Altis Lottery will be drawn today in 30 Minutes."] remoteExec ["life_fnc_broadcast",0]; };
		case 11: { [0,"The Altis Lottery will be drawn todayin 10 Minutes."] remoteExec ["life_fnc_broadcast",0]; Life_var_lottoDrawLock = true; publicVariable "Life_var_lottoDrawLock"; };
		case 12: { [_vaultObject] spawn life_fnc_lottery_pickwinners; _timer = 0; };
	};
};

true
