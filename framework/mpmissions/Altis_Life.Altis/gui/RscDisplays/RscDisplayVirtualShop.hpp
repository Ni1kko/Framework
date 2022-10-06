class RscDisplayVirtualShop 
{
    idd = 2400;
    movingEnable = 0;
    enableSimulation = 1;
    onLoad="uiNamespace setVariable ['RscDisplayVirtualShop', _this#0];";
    onUnload="uiNamespace setVariable ['RscDisplayVirtualShop', displayNull]";
    onDestroy="uiNamespace setVariable ['RscDisplayVirtualShop', displayNull]";

    class controlsBackground {
        class RscDefineTitleBackground: RscDefineText {
            colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", "(profilenamespace getvariable ['GUI_BCG_RGB_A',0.7])"};
            idc = -1;
            x = 0.1;
            y = 0.2;
            w = 0.8;
            h = (1 / 25);
        };

        class MainBackground: RscDefineText {
            colorBackground[] = {0, 0, 0, 0.7};
            idc = -1;
            x = 0.1;
            y = 0.2 + (11 / 250);
            w = 0.8;
            h = 0.6 - (22 / 250);
        };

        class vasText: RscDefineText {
            idc = -1;
            colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", 0.5};
            text = "$STR_VS_SI";
            sizeEx = 0.04;
            x = 0.12;
            y = 0.27;
            w = 0.350;
            h = 0.04;
        };

        class vasgText: RscDefineText {
            idc = -1;
            colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", 0.5};
            text = "$STR_VS_PI";
            sizeEx = 0.04;
            x = 0.53;
            y = 0.27;
            w = 0.350;
            h = 0.04;
        };
    };

    class controls {
        class itemList: RscDefineListBox {
            idc = 2401;
            text = "";
            sizeEx = 0.030;
            x = 0.12;
            y = 0.31;
            w = 0.350;
            h = 0.340;
        };

        class pItemlist: RscDefineListBox {
            idc = 2402;
            text = "";
            sizeEx = 0.030;
            x = 0.53;
            y = 0.31;
            w = 0.350;
            h = 0.340;
        };

        class Title: RscDefineTitle {
            colorBackground[] = {0, 0, 0, 0};
            idc = 2403;
            text = "";
            x = 0.1;
            y = 0.2;
            w = 0.8;
            h = (1 / 25);
        };

        class PlayersName: Title {
            idc = 601;
            style = 1;
            text = "";
        };

        class buyEdit: RscDefineTextEdit {
            idc = 2404;
            text = "1";
            sizeEx = 0.030;
            x = 0.12;
            y = 0.66;
            w = 0.35;
            h = 0.03;
        };

        class sellEdit: RscDefineTextEdit {
            idc = 2405;
            text = "1";
            sizeEx = 0.030;
            x = 0.53;
            y = 0.66;
            w = 0.35;
            h = 0.03;
        };

        class ButtonAddG: RscDefineButtonMenu {
            idc = -1;
            text = "$STR_VS_BuyItem";
            colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", 0.5};
            onButtonClick = "[] call MPClient_fnc_virt_buy;";
            x = 0.12 + (0.35 / 2) - ((6.25 / 40) / 2);
            y = 0.70;
            w = (6.25 / 40);
            h = (1 / 25);
        };

        class ButtonRemoveG: RscDefineButtonMenu {
            idc = -1;
            text = "$STR_VS_SellItem";
            colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", 0.5};
            onButtonClick = "[] call MPClient_fnc_virt_sell";
            x = 0.53 + (0.35 / 2) - ((6.25 / 40) / 2);
            y = 0.70;
            w = (6.25 / 40);
            h = (1 / 25);
        };

        class ButtonClose: RscDefineButtonMenu {
            idc = -1;
            text = "$STR_Global_Close";
            onButtonClick = "closeDialog 0;";
            x = 0.1;
            y = 0.8 - (1 / 25);
            w = (6.25 / 40);
            h = (1 / 25);
        };
    };
};