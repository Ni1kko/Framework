/*
	## Nikko Renolds
	## https://github.com/Ni1kko/Framework
*/

params [
	['_receiver',objNull,[objNull,sideUnknown,-100]],
	['_senderInput','',['']],
	['_senderName','',['']],
	['_requestType',-100,[-100]]
];

if(!isServer)exitwith{false};
if (_senderName isEqualTo "") exitWith {};

switch (_requestType) do {
	case 0 : {
		private _BEGuid_Sender = ('BEGuid' callExtension ("get:"+(param [4,'',['']])));
		private _BEGuid_Receiver = ('BEGuid' callExtension ("get:"+(getPlayerUID _receiver)));
		 
		["CREATE", "cellphone_messages", 
			[
				["sender", 			["DB","STRING", _BEGuid_Sender] call life_fnc_database_parse],
				["receiver", 		["DB","STRING", _BEGuid_Receiver] call life_fnc_database_parse],
				["message", 		["DB","STRING", _senderInput] call life_fnc_database_parse]
			]
		] call life_fnc_database_request;
 
		[
			[_senderName,_senderInput],
			{
				params ['_senderName','_senderInput'];
				hint parseText format ["<t color='#FFCC00'><t size='2'><t align='center'>New Message<br/><br/><t color='#33CC33'><t align='left'><t size='1'>To: <t color='#ffffff'>You<br/><t color='#33CC33'>From: <t color='#ffffff'>%1<br/><br/><t color='#33CC33'>Message:<br/><t color='#ffffff'>%2",_senderName,_senderInput];
				["TextMessage",[format ["You Received A New Private Message From %1",_senderName]]] call bis_fnc_showNotification;
				systemChat format [">>>MESSAGE FROM %1: %2",_senderName,_senderInput];
			}
		] remoteExec ["call",owner _receiver];
	};

	case 1 : {
		[
			[_senderName,_senderInput,param [4,'',['']],param [5,objNull,[objNull]]],
			{
				params ['_senderName','_senderInput','_gridlocation','_unit'];
				if (side player != west) exitWith {};  
				if (isNil "_gridlocation") then {_gridlocation = "Unknown";};
				hint parseText format ["<t color='#316dff'><t size='2'><t align='center'>New Dispatch<br/><br/><t color='#33CC33'><t align='left'><t size='1'>To: <t color='#ffffff'>All Officers<br/><t color='#33CC33'>From: <t color='#ffffff'>%1<br/><t color='#33CC33'>Coords: <t color='#ffffff'>%2<br/><br/><t color='#33CC33'>Message:<br/><t color='#ffffff'>%3",_senderName,_gridlocation,_senderInput];
				["PoliceDispatch",[format ["A New Police Report From: %1",_senderName]]] call bis_fnc_showNotification;
				systemChat format ["--- 911 DISPATCH FROM %1: %2",_senderName,_senderInput];
			}
		] remoteExec ["call",_receiver];
	};

	case 2 : {
		[
			[_senderName,_senderInput,param [4,'',['']],param [5,objNull,[objNull]]],
			{
				params ['_senderName','_senderInput','_gridlocation','_unit'];
				if ((call life_adminlevel) < 1) exitWith {};
				if (isNil "_gridlocation") then {_gridlocation = "Unknown";};
				hint parseText format ["<t color='#ffcefe'><t size='2'><t align='center'>Admin Request<br/><br/><t color='#33CC33'><t align='left'><t size='1'>To: <t color='#ffffff'>Admins<br/><t color='#33CC33'>From: <t color='#ffffff'>%1<br/><t color='#33CC33'>Coords: <t color='#ffffff'>%2<br/><br/><t color='#33CC33'>Message:<br/><t color='#ffffff'>%3",_senderName,_gridlocation,_senderInput];
				["AdminDispatch",[format ["%1 Has Requested An Admin!",_senderName]]] call bis_fnc_showNotification;
				systemChat format ["!!! ADMIN REQUEST FROM %1: %2",_senderName,_senderInput];
			}
		] remoteExec ["call",_receiver];
	};

	case 3 : {
		[
			[_senderName,_senderInput],
			{
				params ['_senderName','_senderInput'];
				hint parseText format ["<t color='#FF0000'><t size='2'><t align='center'>Admin Message<br/><br/><t color='#33CC33'><t align='left'><t size='1'>To: <t color='#ffffff'>You<br/><t color='#33CC33'>From: <t color='#ffffff'>An Admin<br/><br/><t color='#33CC33'>Message:<br/><t color='#ffffff'>%1",_senderInput];
				["AdminMessage",["You Have Received A Message From An Admin!"]] call bis_fnc_showNotification;
				systemChat format ["!!! ADMIN MESSAGE: %1",_senderInput];
			}
		] remoteExec ["call",_receiver];
	};

	case 4 : {
		[
			[_senderName,_senderInput],
			{
				params ['_senderName','_senderInput'];
				hint parseText format ["<t color='#FF0000'><t size='2'><t align='center'>Admin Message<br/><br/><t color='#33CC33'><t align='left'><t size='1'>To: <t color='#ffffff'>All Players<br/><t color='#33CC33'>From: <t color='#ffffff'>The Admins<br/><br/><t color='#33CC33'>Message:<br/><t color='#ffffff'>%1",_senderInput];
				["AdminMessage",["You Have Received A Message From An Admin!"]] call bis_fnc_showNotification;
				systemChat format ["!!!ADMIN MESSAGE: %1",_senderInput];
			}
		] remoteExec ["call",_receiver];
	};

	case 5: {
		[
			[_senderName,_senderInput,param [4,'',['']],param [5,objNull,[objNull]]],
			{
				params ['_senderName','_senderInput','_gridlocation','_unit'];
				if (side player != independent) exitWith {}; 
				hint parseText format ["<t color='#FFCC00'><t size='2'><t align='center'>EMS Request<br/><br/><t color='#33CC33'><t align='left'><t size='1'>To: <t color='#ffffff'>You<br/><t color='#33CC33'>From: <t color='#ffffff'>%1<br/><t color='#33CC33'>Coords: <t color='#ffffff'>%2<br/><br/><t color='#33CC33'>Message:<br/><t color='#ffffff'>%3",_senderName,_loc,_senderInput];
				["TextMessage",[format ["EMS Request from %1",_senderName]]] call bis_fnc_showNotification;
				systemChat format ["!!! EMS REQUEST: %1",_senderInput];
			}
		] remoteExec ["call",_receiver];
	};
};