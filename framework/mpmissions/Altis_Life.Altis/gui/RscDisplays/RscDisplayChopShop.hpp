class RscDisplayChopShop 
{
    idd = 39400;
    movingEnable = 0;
    enableSimulation = 1;
    onLoad="uiNamespace setVariable ['RscDisplayChopShop', _this#0]";
    onUnload="uiNamespace setVariable ['RscDisplayChopShop', displayNull]";
    onDestroy="uiNamespace setVariable ['RscDisplayChopShop', displayNull]";

    class controlsBackground {
        class RscTitleBackground: RscDefineText {
            colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", "(profilenamespace getvariable ['GUI_BCG_RGB_A',0.7])"};
            idc = -1;
            x = 0.1;
            y = 0.2;
            w = 0.32;
            h = (1 / 25);
        };

        class MainBackGround: RscDefineText {
            colorBackground[] = {0,0,0,0.7};
            idc = -1;
            x = 0.1;
            y = 0.2 + (11 / 250);
            w = 0.32;
            h = 0.6 - (22 / 250);
        };

        class Title: RscDefineTitle {
            colorBackground[] = {0,0,0,0};
            idc = -1;
            text = "$STR_ChopShop_Title";
            x = 0.1;
            y = 0.2;
            w = 0.32;
            h = (1 / 25);
        };

        class priceInfo: RscDefineStructuredText {
            idc = 39401;
            text = "";
            sizeEx = 0.035;
            x = 0.11;
            y = 0.68;
            w = 0.2;
            h = 0.2;
        };
    };

    class controls {
        class vehicleList: RscDefineListBox {
            idc = 39402;
            onLBSelChanged = "_this call MPClient_fnc_chopShopSelection";
            sizeEx = 0.04;
            x = 0.11;
            y = 0.25;
            w = 0.3;
            h = 0.38;
        };

        class BtnSell: RscDefineButtonMenu {
            idc = -1;
            text = "$STR_Global_Sell";
            onButtonclick = "[] call MPServer_fnc_chopShopSell;";
            x = 0.1 + (6.25 / 40) + (1 / 250 / (safezoneW / safezoneH));
            y = 0.8 - (1 / 25);
            w = (6.25 / 40);
            h = (1 / 25);
        };

        class BtnClose: RscDefineButtonMenu {
            idc = -1;
            text = "$STR_Global_Close";
            onButtonClick = "closeDialog 0";
            x = 0.1;
            y = 0.8 - (1 / 25);
            w = (6.25 / 40);
            h = (1 / 25);
        };
    };
};