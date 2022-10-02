#include "\life_backend\script_macros.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/
 
private _drugDealers = [
	"Dealer_1",
	"Dealer_2",
	"Dealer_3"
];

{
	private _dealer = missionNamespace getVariable [_x, objNull];

	if(!isNull _dealer)then{
		_dealer setVariable ["sellers",[],true];	
	};
} forEach _drugDealers;

true