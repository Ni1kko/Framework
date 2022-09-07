/*
	## Nikko Renolds
	## https://github.com/Ni1kko/Framework
*/

params [
	["_side",playerSide,[sideUnknown]]
];

private _adminlevel = call life_adminlevel;
private _donorlevel = call life_donorlevel;
private _policeRank = call life_coplevel;
private _medicRank = call life_medLevel;
private _rebelRank = call life_reblevel;
private _civJobRank = call life_joblevel;

private _paycheck = switch _side do
{
	case west:
	{
		switch _policeRank do
		{
			default {25000};
			case 10: {27000};
			case 11: {30000};
			case 12: {35000};
			case 13: {40000};
			case 14: {45000};
			case 15: {50000};
		};
	};

	case independent:
	{
		switch _medicRank do
		{
			default {35000}; 
			case 3: {40000};
			case 4: {45000};
			case 5: {50000};
			case 6: {55000};
			case 7: {60000};
		};
	};

	case east:
	{
		switch _rebelRank do
		{
			default {25000}; 
			case 6: {30000};
			case 7: {32000};
			case 8: {35000};
			case 9: {40000};
			case 10: {45000};
			case 11: {50000};
		};
	};

	default
	{
		switch _civJobRank do
		{
			default {10000};
			case 1: {20000};
			case 2: {25000};
		};
	};
};

// Admin Perk
if(_adminlevel > 0) then {
	private _new = _paycheck * _adminlevel;
	private _diff = _new - _paycheck;
	_paycheck = _new;
	systemChat format["You are a tier %1 Admin, you receive a %2 bonus to your paycheck.",_adminlevel,_diff];
}else{ 
	// Donation Perk
	if(_donorlevel > 0) then {
		private _new = _paycheck * (_donorlevel + 0.50);
		private _diff = _new - _paycheck;
		_paycheck = _new;
		systemChat format["You are a tier %1 Donor, you receive a %2 bonus to your paycheck.",_donorlevel,_diff];
	};
};


//Todo: edit into FSM
if(isNil "life_var_paycheckThread")then{life_var_paycheckThread = scriptNull};
if(!isNull life_var_paycheckThread)then{
	terminate "life_var_paycheckThread";
	waitUntil {scriptDone life_var_paycheckThread};
};

life_var_paycheckThread = [_paycheck] spawn {
	private _paycheck = param [0,-1];
	private _time = diag_tickTime;
	private _nextpaycheck = 20;
	while {_paycheck > 0} do {
		systemChat format["Next paycheck in %1 minutes.",_nextpaycheck];
		waitUntil {diag_tickTime - _time > (_nextpaycheck * 60)};
		_time = diag_tickTime;
		life_var_cash = life_var_cash + _paycheck;
		systemChat format["You received $%1 from your paycheck.",_paycheck];
	};
	true
};
