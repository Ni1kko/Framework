#include "\life_backend\script_macros.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

params [
   ["_upper", true, [false]]
];

private _queryWeekDay = ["CURRENTDAY"] call MPServer_fnc_database_request;

_queryWeekDay params [
   ["_dayname", "", [""]]
];

if !(toUpper _dayname in ["MONDAY","TUESDAY","WEDNESDAY","THURSDAY","FRIDAY","SATURDAY","SUNDAY"]) then {
   _dayname = "Error";
};

if _upper then {
   _dayname = toUpper _dayname;
}else{
   _dayname = toLower _dayname;
};

_dayname