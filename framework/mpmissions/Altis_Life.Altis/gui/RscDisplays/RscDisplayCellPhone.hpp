class RscDisplayCellPhone
{
	idd = 8500;
	movingEnabled = 0;
    enableSimulation = 1;
	onLoad="uiNamespace setVariable ['RscDisplayCellPhone', _this#0];";
    onUnload="uiNamespace setVariable ['RscDisplayCellPhone', displayNull]";
    onDestroy="uiNamespace setVariable ['RscDisplayCellPhone', displayNull]";
	
	class controls
	{
		class PlayerListHead : RscDefineText
		{
			idc = 1000;
			text = "Phone Book";
			x = 0.129692 * safezoneW + safezoneX;
			y = 0.208817 * safezoneH + safezoneY;
			w = 0.1314 * safezoneW;
			h = 0.0279982 * safezoneH;
			colorBackground[] = {0.10196078431372,0.10196078431372,0.10196078431372,0.937124};
		};
		class PlayerSelectorBackground : RscDefineText
		{
			idc = 2200;
			x = 0.129692 * safezoneW + safezoneX;
			y = 0.236817 * safezoneH + safezoneY;
			w = 0.1314 * safezoneW;
			h = 0.615961 * safezoneH;
			colorBackground[] = {-1,-1,-1,0.5};
		};
		class PlayerList : RscDefineListBox
		{
			idc = 1500;
			x = 0.135665 * safezoneW + safezoneX;
			y = 0.245216 * safezoneH + safezoneY;
			w = 0.119454 * safezoneW;
			h = 0.534767 * safezoneH;
			sizeEx = 0.041;
		};
		class PlayerFilter: RscDefineTextEdit
		{
			idc = 1400;
			text = "Enter Filter..."; 
			x = 0.135665 * safezoneW + safezoneX;
			y = 0.785581 * safezoneH + safezoneY;
			w = 0.119454 * safezoneW;
			h = 0.0279982 * safezoneH;
			onKeyUp = "[] spawn MPClient_fnc_cellphone_playerFilter;";
		};
		class NewMessage : RscDefineButtonMenu
		{
			idc = 2400;
			text = "New Message";
			x = 0.135665 * safezoneW + safezoneX;
			y = 0.819181 * safezoneH + safezoneY;
			w = 0.119461 * safezoneW;
			h = 0.0279982 * safezoneH;
			onButtonClick = "[] call MPClient_fnc_cellphone_startMessage;";
		};
		class MyMessagesTitle : RscDefineText
		{
			idc = 1001;
			text = "My Messages";
			x = 0.273037 * safezoneW + safezoneX;
			y = 0.206018 * safezoneH + safezoneY;
			w = 0.45405 * safezoneW;
			h = 0.0279982 * safezoneH;
			colorBackground[] = {0.10196078431372,0.10196078431372,0.10196078431372,0.937124};
		};
		class MyMessagesBackground : RscDefineText
		{
			idc = 2201;
			x = 0.273037 * safezoneW + safezoneX;
			y = 0.234017 * safezoneH + safezoneY;
			w = 0.45405 * safezoneW;
			h = 0.590761 * safezoneH;
			colorBackground[] = {-1,-1,-1,0.5};
		};
		class MyInboxTitle : RscDefineText
		{
			idc = 1002;
			text = "Inbox";
			x = 0.284983 * safezoneW + safezoneX;
			y = 0.262015 * safezoneH + safezoneY;
			w = 0.43254 * safezoneW;
			h = 0.030798 * safezoneH;
			colorBackground[] = {0.10196078431372,0.10196078431372,0.10196078431372,0.937124};
		};
		class MessageList : RscDefineListNBox
		{
			idc = 1501;
			sizeEx = "(			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";
			colorBackground[] = {0, 0, 0, 0.0};
			columns[] = {0,0.3,0.5, 0.85};
			x = 0.284983 * safezoneW + safezoneX;
			y = 0.290013 * safezoneH + safezoneY;
			w = 0.432425 * safezoneW;
			h = 0.114784 * safezoneH;
			onLBSelChanged = "[] call MPClient_fnc_cellphone_messageSelect;";
		};
		class MessageViewerTitle : RscDefineText
		{
			idc = 1003;
			text = "Message Viewer";
			x = 0.284983 * safezoneW + safezoneX;
			y = 0.430004 * safezoneH + safezoneY;
			w = 0.43254 * safezoneW;
			h = 0.030798 * safezoneH;
			colorBackground[] = {0.10196078431372,0.10196078431372,0.10196078431372,0.937124};
		};
		class ReplyToMsg : RscDefineButtonMenu
		{
			idc = 2401;
			text = "Reply";
			x = 0.649 * safezoneW + safezoneX;
			y = 0.822 * safezoneH + safezoneY;
			w = 0.078 * safezoneW;
			h = 0.027 * safezoneH;
		};
		class CloseMenu : RscDefineButtonMenu
		{
			idc = 2402;
			text = "Close";
			x = 0.273 * safezoneW + safezoneX;
			y = 0.822 * safezoneH + safezoneY;
			w = 0.078 * safezoneW;
			h = 0.027 * safezoneH;
			onButtonClick = "closeDialog 0;";
		};
		class MessageViewerGroup : RscDefineControlsGroup {
			idc = -1;
			x = 0.284983 * safezoneW + safezoneX;
			y = 0.458003 * safezoneH + safezoneY;
			w = 0.432425 * safezoneW;
			h = 0.335979 * safezoneH;

			class Controls {
				class MessageViewer : RscDefineStructuredText
				{
				idc = 1004;
				x = 0;
				y = 0;
				w = 0.432420 * safezoneW;
				h = 1 * safezoneH;
				};
			};
		};
		class WritingToHeader: RscDefineText
		{
			idc = 4000;
			text = "Writing to %1";
			x = 0.284983 * safezoneW + safezoneX;
			y = 0.262015 * safezoneH + safezoneY;
			w = 0.43254 * safezoneW;
			h = 0.030798 * safezoneH;
			colorBackground[] = {0.10196078431372,0.10196078431372,0.10196078431372,0.937124};
		};
		class YourMessageText: RscDefineTextEdit
		{
			idc = 4001;
			x = 0.284983 * safezoneW + safezoneX;
			y = 0.374008 * safezoneH + safezoneY;
			w = 0.430035 * safezoneW;
			h = 0.419974 * safezoneH;
			colorBackground[] = {-1,-1,-1,0.7};
			text = "";
			type = 2;
			sizeEx = 0.030;
			style = 16;
			shadow = 0;
			onKeyUp = "[] call MPClient_fnc_cellphone_messageKeyUp;";
		};
		class CurrentCharactersUsedTitle : RscDefineText
		{
			idc = 4002;
			text = "Current Characters Used: ";
			x = 0.284983 * safezoneW + safezoneX;
			y = 0.318011 * safezoneH + safezoneY;
			w = 0.167236 * safezoneW;
			h = 0.0279982 * safezoneH;
			colorBackground[] = {-1,-1,-1,0.8};
		};
		class CurrentCharactersUsed : RscDefineText
		{
			idc = 4003;
			text = "0/1500";
			x = 0.452218 * safezoneW + safezoneX;
			y = 0.318011 * safezoneH + safezoneY;
			w = 0.167236 * safezoneW;
			h = 0.0279982 * safezoneH;
		};
		class SendGRIDREFTitle : RscDefineText
		{
			idc = 4004;
			text = "Send GRIDREF:";
			x = 0.284983 * safezoneW + safezoneX;
			y = 0.290013 * safezoneH + safezoneY;
			w = 0.167236 * safezoneW;
			h = 0.0279982 * safezoneH;
			colorBackground[] = {-1,-1,-1,0.8};
		};
		class SendGRIDREFCheckbox : RscDefineCheckbox
		{
			idc = 4005;
			x = 0.452218 * safezoneW + safezoneX;
			y = 0.290013 * safezoneH + safezoneY;
			w = 0.0131399 * safezoneW;
			h = 0.0279982 * safezoneH;
		};
		class YourMessageTextBackground: RscDefineText
		{
			idc = 4006;
			text = "";
			x = 0.284983 * safezoneW + safezoneX;
			y = 0.374008 * safezoneH + safezoneY;
			w = 0.430035 * safezoneW;
			h = 0.419974 * safezoneH;
			colorBackground[] = {-1,-1,-1,0.6};
		};
		class WriteYourMessageHeader: RscDefineText
		{
			idc = 4007;
			text = "Write your Message:";
			x = 0.284983 * safezoneW + safezoneX;
			y = 0.34601 * safezoneH + safezoneY;
			w = 0.43254 * safezoneW;
			h = 0.030798 * safezoneH;
			colorBackground[] = {0.10196078431372,0.10196078431372,0.10196078431372,0.937124};
		};

		class CancelMessage : RscDefineButtonMenu
		{
			idc = 4008;
			text = "Cancel";
			x = 0.5657 * safezoneW + safezoneX;
			y = 0.82198 * safezoneH + safezoneY;
			w = 0.0788393 * safezoneW;
			h = 0.0279982 * safezoneH;
			onButtonClick = "closeDialog 0; [] spawn MPClient_fnc_cellphone_show;";
		};
	};
};