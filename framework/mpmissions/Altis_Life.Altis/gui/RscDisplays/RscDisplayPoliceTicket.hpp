class RscDisplayPoliceTicket 
{
    idd = 2650;
    movingEnable = 0;
    enableSimulation = 1;
    onLoad = "uiNamespace setVariable ['RscDisplayPoliceTicket',_this select 0]";
    onUnload="uiNamespace setVariable ['RscDisplayPoliceTicket', displayNull]";
    onDestroy="uiNamespace setVariable ['RscDisplayPoliceTicket', displayNull]";

    class controlsBackground {
        class RscDefineTitleBackground: RscDefineText {
            colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", "(profilenamespace getvariable ['GUI_BCG_RGB_A',0.7])"};
            idc = -1;
            x = 0.3;
            y = 0.2;
            w = 0.47;
            h = (1 / 25);
        };

        class MainBackground: RscDefineText {
            colorBackground[] = {0, 0, 0, 0.7};
            idc = -1;
            x = 0.3;
            y = 0.2 + (11 / 250);
            w = 0.47;
            h = 0.3 - (22 / 250);
        };
    };

    class controls {
        class Title: RscDefineTitle {
            colorBackground[] = {0, 0, 0, 0};
            idc = 2651;
            text = "";
            x = 0.3;
            y = 0.2;
            w = 0.6;
            h = (1 / 25);
        };

        class moneyEdit: RscDefineTextEdit {
            idc = 2652;
            text = "100";
            sizeEx = 0.030;
            x = 0.40;
            y = 0.30;
            w = 0.25;
            h = 0.03;
        };

        class payTicket: RscDefineButtonMenu {
            idc = -1;
            text = "$STR_Ticket_GiveTicket";
            colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", 0.5};
            onButtonClick = "[] call MPClient_fnc_ticketGive";
            x = 0.45;
            y = 0.35;
            w = (6.25 / 40);
            h = (1 / 25);
        };
    };
};

class Life_ticket_pay {
    idd = 2600;
    name = "life_ticket_pay";
    movingEnable = 0;
    enableSimulation = 1;

    class controlsBackground {
        class RscDefineTitleBackground: RscDefineText {
            colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", "(profilenamespace getvariable ['GUI_BCG_RGB_A',0.7])"};
            idc = -1;
            x = 0.3;
            y = 0.2;
            w = 0.47;
            h = (1 / 25);
        };

        class MainBackground: RscDefineText {
            colorBackground[] = {0, 0, 0, 0.7};
            idc = -1;
            x = 0.3;
            y = 0.2 + (11 / 250);
            w = 0.47;
            h = 0.3 - (22 / 250);
        };
    };

    class controls {
        class InfoMsg: RscDefineStructuredText {
            idc = 2601;
            sizeEx = 0.020;
            text = "";
            x = 0.287;
            y = 0.2 + (11 / 250);
            w = 0.5;
            h = 0.12;
        };

        class payTicket: RscDefineButtonMenu {
            idc = -1;
            text = "$STR_Ticket_PayTicket";
            colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", 0.5};
            onButtonClick = "[] call MPClient_fnc_ticketPay;";
            x = 0.2 + (6.25 / 40) + (1 / 250 / (safezoneW / safezoneH));
            y = 0.42 - (1 / 25);
            w = (6.25 / 40);
            h = (1 / 25);
        };

        class refuseTicket: RscDefineButtonMenu {
            idc = -1;
            text = "$STR_Ticket_RefuseTicket";
            colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", 0.5};
            onButtonClick = "closeDialog 0;";
            x = 0.4 + (6.25 / 40) + (1 / 250 / (safezoneW / safezoneH));
            y = 0.42 - (1 / 25);
            w = (6.25 / 40);
            h = (1 / 25);
        };
    };
};