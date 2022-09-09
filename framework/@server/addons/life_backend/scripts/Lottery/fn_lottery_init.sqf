/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

if(!canSuspend)exitWith{_this spawn MPServer_fnc_lottery_init};

waitUntil {!isNil "life_var_currentDay"};
diag_log "[Life Lottery] Initializing...";

private _timer = 0;
private _vaultObject = objNull; 

Life_var_lottoDrawLock = false;
life_var_lotto_config = compileFinal str [
	getNumber(configFile >> "CfgLottery" >> "ticketPrice"),
	getNumber(configFile >> "CfgLottery" >> "ticketLength"),
	getNumber(configFile >> "CfgLottery" >> "ticketDrawCount"),
	getNumber(configFile >> "CfgLottery" >> "ticketsReclaim") isEqualTo 1,
	getNumber(configFile >> "CfgLottery" >> "ticketBonusballPrice"),
	getArray(configFile >> "CfgLottery" >> "ticketDrawTimes" >> life_var_currentDay)
];

(call life_var_lotto_config) params [
	"_ticketPrice",
	"_ticketLength",
	"_ticketDrawCount",
	"_ticketsReclaim",
	"_ticketBonusballPrice",
	"_ticketDrawTimes"
];

//-- Boradcast some data to all clients
{publicVariable _x}forEach [
	"life_var_lotto_config",
	"MPServer_fnc_lottery_generateTicket",
	"MPServer_fnc_lottery_generateBonusBall"
];

//-- Wait for bank system to ready up
waitUntil {isFinal "life_var_banksReady"}; 
_vaultObject = missionNamespace getVariable ["fed_bank",objNull];

//--
if _ticketsReclaim then{
	[] spawn MPServer_fnc_lottery_checkOldTickets;
};

diag_log "[Life Lottery] Initialized!";
 
//-- Start the lottery
if(count _ticketDrawTimes > 0)then
{
	diag_log "[Life Lottery] Winners Will Be Picked Today!";
 
	while {true} do
	{
		waitUntil {
			uiSleep 30;
			private _timeInfo = [] call MPServer_fnc_lottery_getTimeInfo;
			_timeInfo params ["_timeRemaining","_configIndex","_configIndexValid"];
			_timeRemaining <= 0 AND _configIndexValid
		};

		[_vaultObject] spawn MPServer_fnc_lottery_pickwinners;

		waitUntil {
			uiSleep (5 * 60);
			private _timeInfo = [] call MPServer_fnc_lottery_getTimeInfo; 
			(_timeInfo#0) > 0
		};
	};
}else{
	diag_log format["[Life Lottery] Winners Will Be Picked on %1!",_ticketDrawDay];
};

true
