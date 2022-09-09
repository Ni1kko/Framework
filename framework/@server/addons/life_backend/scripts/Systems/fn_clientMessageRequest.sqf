/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

params [
	['_requestType','',['']],
	['_senderInput','',['']],
	['_senderLocation',false,[false]],
	['_BEGuid_Sender','',['']],
	['_BEGuid_Receiver','']
];

if(!isServer)exitwith{false};
if (_BEGuid_Sender isEqualTo "") exitWith {};

private _object_Sender =  [_BEGuid_Sender] call MPServer_fnc_util_getPlayerObject;
private _gridPos_Sender = if(_senderLocation)then{mapGridPosition _object_Sender}else{"Unknown"};

[name _object_Sender,_BEGuid_Sender,_requestType,_BEGuid_Receiver,_senderInput,_gridPos_Sender] remoteExec ["MPClient_fnc_cellphone_messageReceived",switch (_requestType) do 
{
	//Player
	case "XXX-REQ-PLAYER" : { 
		private _object_Receiver =  [_BEGuid_Receiver] call MPServer_fnc_util_getPlayerObject;
  
		["CREATE", "cellphone_messages", 
			[
				["sender", 			["DB","STRING", _BEGuid_Sender] call MPServer_fnc_database_parse],
				["receiver", 		["DB","STRING", _BEGuid_Receiver] call MPServer_fnc_database_parse],
				["message", 		["DB","STRING", _senderInput] call MPServer_fnc_database_parse]
			]
		] call MPServer_fnc_database_request;
 
		owner _object_Receiver
	};
	case "999-REQ-POLICE" : {west};
	case "999-REQ-MEDIC": {independent};
	case "XXX-REQ-ADMIN" : {-2};
	default {-100};
}];