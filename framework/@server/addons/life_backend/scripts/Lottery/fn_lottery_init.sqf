#include "\life_backend\script_macros.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

RUN_SERVER_ONLY;
FORCE_SUSPEND("MPServer_fnc_lottery_init");

waitUntil {!isNil "life_var_currentDay"};

["[Life Lottery System] Initializing..."] call MPServer_fnc_log;

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

["[Life Lottery System] Initialized"] call MPServer_fnc_log;

//-- Start the lottery
if(count _ticketDrawTimes > 0)then
{
	["[Life Lottery System] Winners Will Be Picked Today!"] call MPServer_fnc_log;
 
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
	[format["[Life Lottery System] Winners Will Be Picked on %1!",_ticketDrawDay]] call MPServer_fnc_log;
};

true
