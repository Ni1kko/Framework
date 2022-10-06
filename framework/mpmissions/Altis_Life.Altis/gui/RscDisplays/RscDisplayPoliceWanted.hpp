class RscDisplayPoliceWanted 
{
    idd = 2400;
    movingEnable = 0;
    enableSimulation = 1;
    onLoad = "uiNamespace setVariable ['RscDisplayPoliceWanted',_this select 0]";
    onUnload="uiNamespace setVariable ['RscDisplayPoliceWanted', displayNull]";
    onDestroy="uiNamespace setVariable ['RscDisplayPoliceWanted', displayNull]";

    class controlsBackground {
        class RscDefineTitleBackground: RscDefineText {
            colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", "(profilenamespace getvariable ['GUI_BCG_RGB_A',0.7])"};
            idc = -1;
            x = 0.1;
            y = 0.2;
            w = 0.6;
            h = (1 / 25);
        };

        class MainBackground: RscDefineText {
            colorBackground[] = {0, 0, 0, 0.7};
            idc = -1;
            x = 0.1;
            y = 0.2 + (11 / 250);
            w = 0.6;
            h = 0.6 - (22 / 250);
        };
    };

    class controls {
        class Title: RscDefineTitle {
            colorBackground[] = {0, 0, 0, 0};
            idc = -1;
            text = "$STR_Wanted_Title";
            x = 0.1;
            y = 0.2;
            w = 0.6;
            h = (1 / 25);
        };

        class WantedConnection: Title {
            idc = 2404;
            style = 1;
            text = "";
        };

        class WantedList: RscDefineListBox {
            idc = 2401;
            text = "";
            sizeEx = 0.035;
            onLBSelChanged = "[] spawn MPClient_fnc_wantedGrab";
            x = 0.12;
            y = 0.28;
            w = 0.2;
            h = 0.3;
        };

        class PlayerList: RscDefineListBox {
            idc = 2406;
            text = "";
            sizeEx = 0.035;
            //colorBackground[] = {0,0,0,0};
            onLBSelChanged = "";
            x = 0.34;
            y = 0.28;
            w = 0.2;
            h = 0.3;
        };

        class WantedDetails: RscDefineListBox {
            idc = 2402;
            text = "";
            sizeEx = 0.035;
            colorBackground[] = {0, 0, 0, 0};
            x = 0.12;
            y = 0.62;
            w = 0.48;
            h = 0.12;
        };

        class BountyPrice: RscDefineText    {
            idc = 2403;
            text = "";
            x = 0.12;
            y = 0.30;
            w = 0.6;
            h = 0.6;
        };

        class WantedAddL: RscDefineCombo    {
            idc = 2407;
            x = 0.542;
            y = 0.28;
            w = (8 / 52);
            h = 0.03;
        };

        class CloseButtonKey: RscDefineButtonMenu {
            idc = -1;
            text = "$STR_Global_Close";
            onButtonClick = "closeDialog 0;";
            x = -0.06 + (6.25 / 40) + (1 / 250 / (safezoneW / safezoneH));
            y = 0.8 - (1 / 25);
            w = (6.25 / 40);
            h = (1 / 25);
        };

        class PardonButtonKey: RscDefineButtonMenu {
            idc = 2405;
            text = "$STR_Wanted_Pardon";
            onButtonClick = "[] call MPClient_fnc_pardon; closeDialog 0;";
            x = 0.1 + (6.25 / 40) + (1 / 250 / (safezoneW / safezoneH));
            y = 0.8 - (1 / 25);
            w = (6.25 / 40);
            h = (1 / 25);
        };

        class ButtonWantedAdd: RscDefineButtonMenu {
            idc = 9800;
            //shortcuts[] = {0x00050000 + 2};
            text = "$STR_Wanted_Add";
            onButtonClick = "[] call MPClient_fnc_wantedAddP;";
            x = 0.1 + (6.25 / 19.8) + (1 / 250 / (safezoneW / safezoneH));
            y = 0.8 - (1 / 25);
            w = (6.25 / 40);
            h = (1 / 25);
        };

        class wantedText: RscDefineText {
            idc = 1000;
            text = "$STR_Wanted_People";
            x = 0.12;
            y = 0.11;
            w = 0.2;
            h = 0.3;
        };

        class citizensText: RscDefineText {
            idc = 1001;
            text = "$STR_Wanted_Citizens";
            x = 0.34;
            y = 0.11;
            w = 0.2;
            h = 0.3;
        };

        class crimesText: RscDefineText {
            idc = 1002;
            text = "$STR_Wanted_Crimes";
            x = 0.542;
            y = 0.245;
            w = (8 / 52);
            h = 0.03;
        };
    };
};

class life_bounty_menu {
	idd = 2400;
	name= "life_bounty_menu";
	movingEnable = false;
	enableSimulation = true;
	
	class controlsBackground {
		class RscDefineTitleBackground:RscDefineText {
			colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", "(profilenamespace getvariable ['GUI_BCG_RGB_A',0.7])"};
			idc = -1;
			x = 0.1;
			y = 0.2;
			w = 0.6;
			h = (1 / 25);
		};
		
		class MainBackground:RscDefineText {
			colorBackground[] = {0, 0, 0, 0.7};
			idc = -1;
			x = 0.1;
			y = 0.2 + (11 / 250);
			w = 0.6;
			h = 0.6 - (22 / 250);
		};
	};
	
	class controls {

		
		class Title : RscDefineTitle {
			colorBackground[] = {0, 0, 0, 0};
			idc = -1;
			text = "$STR_Bounty_Title";
			x = 0.1;
			y = 0.2;
			w = 0.6;
			h = (1 / 25);
		};
		
		class WantedConnection : Title {
			idc = 2404;
			style = 1;
			text = "";
		};
		
		class WantedList : RscDefineListBox 
		{
			idc = 2401;
			text = "";
			sizeEx = 0.035;
			//onLBSelChanged = "[] call MPClient_fnc_wantedInfo";
			
			x = 0.12; y = 0.26;
			w = 0.55; h = 0.4;
		}; 
		
		class CloseButtonKey : RscDefineButtonMenu {
			idc = -1;
			text = "$STR_Global_Close";
			onButtonClick = "closeDialog 0;";
			x = -0.06 + (6.25 / 40) + (1 / 250 / (safezoneW / safezoneH));
			y = 0.8 - (1 / 25);
			w = (6.25 / 40);
			h = (1 / 25);
		};
		
		class PardonButtonKey : RscDefineButtonMenu {
			idc = 2405;
			text = "$STR_Bounty_Select";
			onButtonClick = "[] call MPClient_fnc_bountySelect; closeDialog 0; [] call MPClient_fnc_updateInventoryMenu;";
			x = 0.1 + (6.25 / 40) + (1 / 250 / (safezoneW / safezoneH));
			y = 0.8 - (1 / 25);
			w = (6.25 / 40);
			h = (1 / 25);
		};
	};
};