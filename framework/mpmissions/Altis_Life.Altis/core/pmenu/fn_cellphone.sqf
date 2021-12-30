
if(!isNil "life_fnc_cellphone_show")exitWith{};

KRON_Replace = {
    private["_str","_old","_new","_out","_tmp","_jm","_la","_lo","_ln","_i"];
    _str=_this select 0;
    _arr=toArray(_str);
    _la=count _arr;
    _old=_this select 1;
    _new=_this select 2;
    _na=[_new] call KRON_StrToArray;
    _lo=[_old] call KRON_StrLen;
    _ln=[_new] call KRON_StrLen;
    _out="";
    for "_i" from 0 to (count _arr)-1 do {
        _tmp="";
        if (_i <= _la-_lo) then {
            for "_j" from _i to (_i+_lo-1) do {
                _tmp=_tmp + toString([_arr select _j]);
            };
        };
        if (_tmp==_old) then {
            _out=_out+_new;
            _i=_i+_lo-1;
        } else {
            _out=_out+toString([_arr select _i]);
        };
    };
    _out
};
  
life_fnc_cellphone_show = {
    if!(createDialog "RscDisplayCellPhone")exitWith{};

    private _display = (findDisplay 8500);
    if(isNull _display)exitWith{};

    {ctrlShow [_x,false]} forEach [1002, 1501, 1003, 2401, 1004, 2401,4000,4001,4002,4003,4004,4005,4006,4007,4008];

    private _playerList = _display displayCtrl 1500;
    private _messageList = _display displayCtrl 1501;

    life_cellphone_receiver = []; 
    life_cellphone_contacts = [
        [" Police Request", "999-REQ-POLICE", "", "\A3\ui_f\data\gui\Rsc\RscDisplayMultiplayerSetup\disabledai_ca.paa"],
        [" NHS Request", "999-REQ-MEDIC", "", "icons\cellphone\nhs.paa"],
        [" Admin Request", "XXX-REQ-ADMIN", "", "icons\cellphone\admin.paa"]
    ];

    {
        private _name = _x getVariable["realname",name _x];
        private _icon = format["icons\cellphone\%1_icon.paa",switch (side group _x) do {case west: {"police"};case independent: {"medic"}; default {"civilian"};}];
        private _BEGuid = call(player getVariable ["BEGUID",{""}]);
        
        if(!alive _x) then {_name = _x getVariable["name", name _x];};
        if(_BEGuid isNotEqualTo "") then {
            life_cellphone_contacts pushBack [_name, 0, _BEGuid, _icon];
        };
    } forEach playableUnits;
    
    [false] spawn life_fnc_cellphone_switchDialog;
    [] spawn life_fnc_cellphone_playerFilter;
    [] spawn life_fnc_cellphone_messageShow;
};
life_fnc_cellphone_switchDialog = {
    disableSerialization;
    private _isMsg = [_this,0,false,[false]] call BIS_fnc_param;

    private _display = findDisplay 8500;
    if(isNull _display) exitWith {};

    private _myMessages = [1002, 1501, 1003, 1004];
    private _sendMessage = [4000,4001,4002,4003,4004,4005,4006,4007,4008];

    private _replyMsg = _display displayCtrl 2401;
    private _cancelMsg = _display displayCtrl 4008;
    
    if(_isMsg) then {
        _replyMsg ctrlSetText "Send Message";
        _replyMsg buttonSetAction "[] call life_fnc_cellphone_sendMessage;";
        _cancelMsg buttonSetAction "[] call life_fnc_cellphone_sendMessageCancel;";
    } else {
        _replyMsg ctrlSetText "Reply";
        _replyMsg buttonSetAction "[] call life_fnc_cellphone_reply;";
    };
    _replyMsg ctrlShow true;
    {
        _ctrl = _display displayCtrl _x;
        _ctrl ctrlShow (!_isMsg);
    } forEach _myMessages; 
    {
        _ctrl = _display displayCtrl _x;
        _ctrl ctrlShow (_isMsg);
    } forEach _sendMessage;
};
life_fnc_cellphone_playerFilter = {
    disableSerialization;
    private _display = findDisplay 8500;
    if(isNull _display) exitWith {};
    if(count life_cellphone_contacts < 1) exitWith {};

    private _playerList = _display displayCtrl 1500;
    private _filter = ctrlText (_display displayCtrl 1400);
    waitUntil {sleep(random(0.2)); !life_cellphone_filterWorking};

    if(_filter != ctrlText (_display displayCtrl 1400)) exitWith {life_cellphone_filterWorking = false;};

    life_cellphone_filterWorking = true;
    private _queue = [];
    {
        if(_filter != ctrlText (_display displayCtrl 1400)) exitWith {life_cellphone_filterWorking = false;};
        if(_filter == "" || {_filter == "Enter Filter..."} || { ( ( toLower ( _x select 0 ) ) find ( toLower _filter ) ) > -1 }) then {
            _queue pushBack _x;
        };
    } forEach life_cellphone_contacts;

    lbClear _playerList;
    {
        _playerList lbAdd (_x#0);
        _playerList lbSetData [(lbSize _playerList -1), (str _x)];
        _playerList lbSetPicture [(lbSize _playerList -1),(_x#3)];
    } forEach _queue;
    lbSort _playerList;

    life_cellphone_filterWorking = false;
};
life_fnc_cellphone_messageShow = {
    disableSerialization;
	_display = findDisplay 8500;
	_messageList = _display displayCtrl 1501;
	lnbClear _messageList;
	for "_i" from count life_cellphone_messages -1 to 0 step -1 do {
		_item = life_cellphone_messages select _i;
		_excerpt = [_item select 3,23] call {
			private["_in","_len","_arr","_out"];
			_in=_this select 0;
			_len=(_this select 1)-1;
			_arr=[_in] call KRON_StrToArray;
			_out="";
			if (_len>=(count _arr)) then {
				_out=_in;
			} else {
				for "_i" from 0 to _len do {
					_out=_out + (_arr select _i);
				};
			};
			_out
		};
		if(_excerpt != _item select 3) then {_excerpt = _excerpt + "...";};
		_excerpt = [_excerpt, "\n", ""] call KRON_Replace;
		_msgType = switch (_item select 2) do
        {
            case "XXX-REQ-PLAYER": {"Text Message"};
            case "999-REQ-POLICE": {"Police Dispatch"};
            case "999-REQ-MEDIC":  {"NHS Dispatch"}; 
            case "XXX-REQ-ADMIN":  {"Admin Message"}; 
        };
		_messageList lnbAddRow [_item select 0, _msgType, _excerpt, if(_item select 5) then {"Viewed"} else {"New"}];
		_messageList lnbSetValue[[((lnbSize _messageList) select 0)-1,0],_i];
	};
};
life_fnc_cellphone_startMessage = {
    disableSerialization;
	_display = findDisplay 8500;
	if(isNull _display) exitWith {};
	_playerList = _display displayCtrl 1500;
	_id = lbCurSel _playerList;
	if(_id < 0) exitWith {hint "Please select a player/service."};
	_receiver = _playerList lbData (lbCurSel _playerList);
	_receiver = call compile _receiver;
	_writingTo = _display displayCtrl 4000;
	[true] call life_fnc_cellphone_switchDialog;  
	_receiverName = switch (_receiver select 1) do
	{
        case "XXX-REQ-PLAYER": {_receiver select 0};
        case "999-REQ-POLICE": {"Police Dispatch Centre"};
        case "999-REQ-MEDIC":  {"NHS Dispatch Centre"}; 
        case "XXX-REQ-ADMIN":  {"Admin Message - Emergencies Only!"};
	};

	life_cellphone_receiver = _receiver;
	_writingTo ctrlSetText format["Writing to %1", _receiverName];
};
life_fnc_cellphone_sendMessage = {
    disableSerialization;
	if(count life_cellphone_receiver < 1) exitWith {};
	private _display = findDisplay 8500;
	if(isNull _display) exitWith {};
	private _sendLoc = cbChecked (_display displayCtrl 4005);
	private _text = ctrlText (_display displayCtrl 4001);
	if(count _text < 1) exitWith {}; 
 
	private _trigger = false;
	{
		if(_x in toArray "`{}<>") exitWith {
			_trigger = true;
		};
	} foreach toArray _text; 
	if(_trigger) exitWith {hint "Please remove any restricted characters inside your text. Restricted Characters: `{}<>"};
    
    private _BEGuid = call(player getVariable ["BEGUID",{""}]);
    [life_cellphone_receiver#1,_text,_sendLoc,_BEGuid,life_cellphone_receiver#2] remoteExecCall ["TON_fnc_clientMessageRequest",2];
	
    closeDialog 0;
	[] spawn life_fnc_cellphone_show;
	hint "Message Sent!";
};
life_fnc_cellphone_sendMessageCancel = {
    disableSerialization;
};
life_fnc_cellphone_reply = {
    disableSerialization;
    private _display = findDisplay 8500;
    if(isNull _display) exitWith {};
    private _messageList = _display displayCtrl 1501;
    private _id = lbCurSel _messageList;
    if(_id < 0) exitWith {hint "Please select a message that you want to reply to."};
    private _messageIndex = _messageList lnbValue[(lbCurSel _messageList),0];
    private _receiver = life_cellphone_messages select _messageIndex;
    private _writingTo = _display displayCtrl 4000;
    [true] call life_fnc_cellphone_switchDialog; //Change our dialog over.

    //MSG TYPES  0: MSG 1: POLREQ 2: NHSREQ 3: ARAC 4: TAXI
    life_cellphone_receiver = [_receiver#0, "XXX-REQ-PLAYER", _receiver#1, ""];
    _writingTo ctrlSetText format["Writing to %1", _receiver#0];
};
life_fnc_cellphone_messageSelect = {
    disableSerialization;
	private _display = findDisplay 8500;
	if(isNull _display) exitWith {};
	private _messageList = _display displayCtrl 1501;
	private _messageViewer = _display displayCtrl 1004;
	if(lbCurSel _messageList < 0) exitWith {};
	private _messageIndex = _messageList lnbValue[(lbCurSel _messageList),0];
	private _messageData = life_cellphone_messages select _messageIndex;

	private _postion = "Sender Position: Withheld";
	if((_messageData#4) isNotEqualTo "Unknown") then {
		_postion = format["Sender Position: %1", _messageData#4];
	};

	_text = _messageData#3; 
	_text = [_text, "&", "&amp;"] call KRON_Replace;
	_text = [_text, "<", ""] call KRON_Replace;
	_text = [_text, ">", ""] call KRON_Replace;

	_textToFilter = _text;
	_filter = "`{}<>";
	_textToFilter = toArray _textToFilter;
	_filter = toArray _filter;
	_trigger = false;
	{
		if(_x in _filter) exitWith {
			_trigger = true;
		};
	} foreach _textToFilter;
	if(_trigger) exitWith {};

	_text = [_text, "\n", "<br/>"] call KRON_Replace;
	_messageViewer ctrlSetStructuredText parseText format[
		"Sender: %1<br/>Date: %4/%5/%6<br/>%2<br/><br/>%3",
		_messageData#0,
		_postion,
		_text,
		(_messageData#6)#2,
		(_messageData#6)#1,
		(_messageData#6)#0
	];

	(life_cellphone_messages select _messageIndex) set [5, true];
	[] call life_fnc_cellphone_messageShow;
};
life_fnc_cellphone_messageKeyUp = {
    disableSerialization;
    private _display = findDisplay 8500;
    if(isNull _display) exitWith {};
    private _ctrl = _display displayCtrl 4001;
    private _charText = _display displayCtrl 4003;

    if(count (ctrlText _ctrl) > 1500) exitWith {
        private _charArr = toArray(ctrlText _ctrl);
        _charArr resize 1500;
        _ctrl ctrlSetText (toString _charArr);
    }; 

    _charText ctrlSetText format["%1/1500",count (ctrlText _ctrl)];
};
life_fnc_cellphone_messageReceived = {
    disableSerialization;
    params['_senderName','_senderBEGuid','_cellphoneMode','_receiverBEGuid','_message','_pos'];

    if(_senderName == "" || _message == "") exitWith {};
    private _hasPos = true;
    if(_pos isEqualTo "Unknown") then {_hasPos = false;};
    
    private _exit = true;
    switch (true) do
    {
        case (_cellphoneMode == "999-REQ-POLICE" && playerSide == west): {_exit = false;};
        case (_cellphoneMode == "999-REQ-MEDIC" && playerSide == independent): {_exit = false;};
        case (_cellphoneMode == "XXX-REQ-ADMIN" && ((call life_adminlevel) > 0)): {_exit = false;}; 
        case (_cellphoneMode == "XXX-REQ-PLAYER"): {_exit = false;};
    };

    if(_exit) exitWith {};

    private _msgData = switch (_cellphoneMode) do {
        case "XXX-REQ-PLAYER": {["Text Message", "icons\mobile\textmsg.paa", format["Text From: %1", _senderName]]};
        case "999-REQ-POLICE": {["Police Dispatch","\A3\ui_f\data\gui\Rsc\RscDisplayMultiplayerSetup\disabledai_ca.paa","Police Dispatch Received"]};
        case "999-REQ-MEDIC":  {["NHS Dispatch","icons\mobile\nhs.paa","NHS Dispatch Received"]}; 
        case "XXX-REQ-ADMIN":  {["Admin Request","icons\mobile\admin.paa","Admin Request Received"]};  
    };

    ["Message",_msgData] call bis_fnc_showNotification;
 
    life_cellphone_messages pushBack [_senderName, _senderBEGuid, _cellphoneMode, _message, _pos, false, date];
    //life_cellphone_messages pushBack [_cellphoneMode, _message, _pos, _senderName, _senderBEGuid, _receiverBEGuid];
};