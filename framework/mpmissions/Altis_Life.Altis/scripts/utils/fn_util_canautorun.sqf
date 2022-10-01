/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

//--- Helpers
private _isSwiming = ((underwater player) || ((getPosASL player)#2) < 0.1);
private _isDriving = ((vehicle player) isNotEqualTo player);
private _isLoading = (call BIS_fnc_isLoading);
private _isLegsBroken = ((player getHit "legs") >= 0.5);
private _isStarving = (life_var_hunger < 25);
private _isDehydrated = (life_var_thirst < 25);
private _isForcedWalked = (isForcedWalk player);
private _isDead = (!life_var_alive);
private _isStanding = ((stance player) isEqualTo "STAND");
private _isInterrupted = (life_var_autorun_interrupt);

private _canAutoRun = true;

//--- Checks
try {
	if (_isSwiming) throw false;//in water and autoswim disabled by server
	if (_isLoading) throw false;//loading screen
	if (_isDriving) throw false;//in vehicle 
	if (_isLegsBroken) throw false;//broke legs
	if (_isStarving) throw false;//starving
	if (_isDehydrated) throw false;//dehydrated
	if (_isForcedWalked) throw false;//force walked by another script?
	if (_isDead) throw false;//dead
	if (!_isStanding) throw false;//not standing
	if (_isInterrupted) throw false;//interrupted
	if !((getPlayerUID player) in getArray(missionConfigFile >> "enableDebugConsole"))then{//non developer checks
		if (!isNull(findDisplay 49)) throw false;//escape open
	};
} catch {
	_canAutoRun = _exception;
};

_canAutoRun