if (isServer) exitWith {};
if ((call life_adminlevel) < 1) exitWith {hint localize "STR_CELLMSG_NoAdmin";};
private ["_msg","_from"];
ctrlShow[3021,false];
_msg = ctrlText 3003;
if (_msg isEqualTo "") exitWith {hint localize "STR_CELLMSG_EnterMSG";ctrlShow[3021,true];};

[-2,_msg,name player,4] remoteExecCall ["TON_fnc_clientMessageRequest",2];
[] call life_fnc_cellphone;
hint format [localize "STR_CELLMSG_AdminToAll",_msg];
ctrlShow[3021,true];