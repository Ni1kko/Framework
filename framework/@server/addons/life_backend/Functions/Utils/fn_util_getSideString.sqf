/*
	## Nikko Renolds
	## https://github.com/Ni1kko/Framework
*/

private _object = param [0, player, [objNull]];
private _side = side _object;

if(isNull _object) then {_side = sideUnknown};

private _string = switch _side do 
{
   case civilian: {'civilian'};
   case west:{'west'};
   case east:{'east'};
   case independent:{'independent'};
   default{'unknown'};
};

_string