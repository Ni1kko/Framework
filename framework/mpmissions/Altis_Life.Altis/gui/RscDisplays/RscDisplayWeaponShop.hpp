class RscDisplayWeaponShop 
{
    idd = 38400;
    movingEnable = 0;
    enableSimulation = 1;
    onLoad="uiNamespace setVariable ['RscDisplayWeaponShop', _this#0];";
    onUnload="uiNamespace setVariable ['RscDisplayWeaponShop', displayNull]";
    onDestroy="uiNamespace setVariable ['RscDisplayWeaponShop', displayNull]";

    class controlsBackground {
        class RscTitleBackground: RscDefineText {
            colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", "(profilenamespace getvariable ['GUI_BCG_RGB_A',0.7])"};
            idc = -1;
            x = 0.1;
            y = 0.2;
            w = 0.32;
            h = (1 / 25);
        };

        class MainBackground: RscDefineText {
            colorBackground[] = {0,0,0,0.7};
            idc = -1;
            x = 0.1;
            y = 0.2 + (11 / 250);
            w = 0.32;
            h = 0.6 - (22 / 250);
        };

        class Title: RscDefineTitle {
            colorBackground[] = {0,0,0,0};
            idc = 38401;
            text = "";
            x = 0.1;
            y = 0.2;
            w = 0.32;
            h = (1 / 25);
        };

        class itemInfo: RscDefineStructuredText {
            idc = 38404;
            text = "";
            sizeEx = 0.035;
            x = 0.11;
            y = 0.68;
            w = 0.2;
            h = 0.2;
        };

        class FilterList: RscDefineCombo {
            idc = 38402;
            onLBSelChanged = "_this call MPClient_fnc_weaponShopFilter";
            x = 0.11;
            y = 0.64;
            w = 0.3;
            h = 0.035;
        };
    };

    class controls {
        class itemList: RscDefineListBox {
            idc = 38403;
            onLBSelChanged = "_this call MPClient_fnc_weaponShopSelection";
            sizeEx = 0.035;
            x = 0.11;
            y = 0.25;
            w = 0.3;
            h = 0.38;
        };

        class ButtonBuySell: RscDefineButtonMenu {
            idc = 38405;
            text = "$STR_Global_Buy";
            onButtonClick = "[] spawn MPClient_fnc_weaponShopBuySell; true";
            x = 0.1;
            y = 0.8 - (1 / 25);
            w = (6.25 / 40);
            h = (1 / 25);
        };

        class ButtonClose: RscDefineButtonMenu {
            idc = -1;
            text = "$STR_Global_Close";
            onButtonClick = "closeDialog 0;";
            x = 0.1 + (6.25 / 40) + (1 / 250 / (safezoneW / safezoneH));
            y = 0.8 - (1 / 25);
            w = (6.25 / 40);
            h = (1 / 25);
        };

        class ButtonMags: RscDefineButtonMenu {
            idc = 38406;
            text = "$STR_Global_Mags";
            onButtonClick = "_this call MPClient_fnc_weaponShopMags; _this call MPClient_fnc_weaponShopFilter";
            x = 0.1;
            y = 0.8 + (1 / 250 / (safezoneW / safezoneH));
            w = (6.25 / 40);
            h = (1 / 25);
        };

        class ButtonAccs: RscDefineButtonMenu {
            idc = 38407;
            text = "$STR_Global_Accs";
            onButtonClick = "_this call MPClient_fnc_weaponShopAccs; _this call MPClient_fnc_weaponShopFilter";
            x = 0.1 + (6.25 / 40) + (1 / 250 / (safezoneW / safezoneH));
            y = 0.8 + (1 / 250 / (safezoneW / safezoneH));
            w = (6.25 / 40);
            h = (1 / 25);
        };
    };
};