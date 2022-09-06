/*
	## Nikko Renolds
	## https://github.com/Ni1kko/Framework
*/

if(!canSuspend)exitWith{_this spawn life_fnc_lottery_init};

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
	toUpper(getText(configFile >> "CfgLottery" >> "ticketDrawDay"))
];

(call life_var_lotto_config) params [
	"_ticketPrice",
	"_ticketLength",
	"_ticketDrawCount",
	"_ticketsReclaim",
	"_ticketBonusballPrice",
	"_ticketDrawDay"
];

//-- Boradcast some data to all clients
{publicVariable _x}forEach [
	"life_var_lotto_config",
	"life_fnc_lottery_generateTicket",
	"life_fnc_lottery_generateBonusBall"
];

//-- Wait for bank system to ready up
waitUntil {isFinal "life_var_banksReady"}; 
_vaultObject = missionNamespace getVariable ["fed_bank",objNull];

//--
if _ticketsReclaim then{
	[] spawn life_fnc_lottery_checkOldTickets;
};

diag_log "[Life Lottery] Initialized!";

//-- Start the lottery
if(_ticketDrawDay isEqualTo ([] call life_fnc_util_getCurrentDay))then{
	diag_log "[Life Lottery] Winners Will Be Picked Today!";
	life_var_lottery_initTime = diag_tickTime;
	life_var_severScheduler pushBack [10 * 60, {
		private _vaultObject = param [0,objNull];
		switch (floor((diag_tickTime - life_var_lottery_initTime))) do 
		{
			case 3:  { [0,"The Altis Lottery will be drawn today in 90 minutes."] remoteExec ["life_fnc_broadcast",0]; };
			case 6:  { [0,"The Altis Lottery will be drawn today in 60 minutes."] remoteExec ["life_fnc_broadcast",0]; };
			case 9:  { [0,"The Altis Lottery will be drawn today in 30 Minutes."] remoteExec ["life_fnc_broadcast",0]; };
			case 11: { [0,"The Altis Lottery will be drawn todayin 10 Minutes."] remoteExec ["life_fnc_broadcast",0]; Life_var_lottoDrawLock = true; publicVariable "Life_var_lottoDrawLock"; };
			case 12: { [_vaultObject] spawn life_fnc_lottery_pickwinners; life_var_lottery_initTime = diag_tickTime; };
		};
	}, [_vaultObject]]
}else{
	diag_log format["[Life Lottery] Winners Will Be Picked on %1!",_ticketDrawDay];
};

true
