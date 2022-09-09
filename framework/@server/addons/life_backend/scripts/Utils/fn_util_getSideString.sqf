/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

private _input = param [0, player, [objNull,sideUnknown]];
private _shortName = param [1, false, [false]];
private _side = (if(typeName _input isEqualTo "OBJECT")then{if(isNull _input)then{sideUnknown}else{side _input}}else{_input});

private _array = switch _side do 
{
   case civilian: {['civilian', 'civ']};
   case west:{['west', 'cop']};
   case east:{['east', 'reb']};
   case independent:{['independent', 'med']};
   default{['unknown', '']};
};

private _string = _array select _shortName;

_string