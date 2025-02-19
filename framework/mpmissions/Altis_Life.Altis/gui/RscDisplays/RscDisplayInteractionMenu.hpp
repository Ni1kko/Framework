#define BGX 0.35
#define BGY 0.2
#define BGW 0.46

class RscDisplayInteractionMenu {
    idd = 37400;
    movingEnable = 0;
    enableSimulation = 1;

    class controlsBackground {
        class RscTitleBackground: RscDefineText {
            colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", "(profilenamespace getvariable ['GUI_BCG_RGB_A',0.7])"};
            idc = -1;
            x = BGX;
            y = BGY;
            w = BGW;
            h = (1 / 25);
        };

        class MainBackground: RscDefineText {
            idc = -1;
            colorBackground[] = {0,0,0,0.7};
            x = BGX;
            y = BGY + (11 / 250);
            w = BGW;
            h = 0.6 - (22 / 250) + 0.05;
        };

        class Title: RscDefineTitle    {
            colorBackground[] = {0,0,0,0};
            idc = 37401;
            text = "$STR_pInAct_Title";
            x = BGX;
            y = BGY;
            w = BGW;
            h = (1 / 25);
        };
    };

    class controls {
        class ButtonClose: RscDefineButtonMenu {
            idc = -1;
            //shortcuts[] = {0x00050000 + 2};
            text = "$STR_Global_Close";
            onButtonClick = "closeDialog 0;";
            x = BGX;
            y = 0.8 - (1 / 25) + 0.05;
            w = (6.25 / 40);
            h = (1 / 25);
        };

        class ButtonOne: RscDefineButtonMenu {
            idc = 37450;
            colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", 0.5};
            text = "";
            sizeEx = 0.025;
            x = BGX + 0.03;
            y = BGY + 0.07;
            w = 0.4;
            h = 0.038;
        };

        class ButtonTwo: RscDefineButtonMenu {
            idc = 37451;
            colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", 0.5};
            text = "";
            sizeEx = 0.025;
            x = BGX + 0.03;
            y = BGY + 0.12;
            w = 0.4;
            h = 0.038;
        };

        class ButtonThree: RscDefineButtonMenu {
            idc = 37452;
            colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", 0.5};
            text = "";
            sizeEx = 0.025;
            x = BGX + 0.03;
            y = BGY + 0.17;
            w = 0.4;
            h = 0.038;
        };

        class ButtonFour: RscDefineButtonMenu {
            idc = 37453;
            colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", 0.5};
            text = "";
            sizeEx = 0.025;
            x = BGX + 0.03;
            y = BGY + 0.22;
            w = 0.4;
            h = 0.038;
        };

        class ButtonFive: RscDefineButtonMenu {
            idc = 37454;
            colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", 0.5};
            text = "";
            sizeEx = 0.025;
            x = BGX + 0.03;
            y = BGY + 0.27;
            w = 0.4;
            h = 0.038;
        };

        class ButtonSix: RscDefineButtonMenu {
            idc = 37455;
            colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", 0.5};
            text = "";
            sizeEx = 0.025;
            x = BGX + 0.03;
            y = BGY + 0.32;
            w = 0.4;
            h = 0.038;
        };

        class ButtonSeven: RscDefineButtonMenu {
            idc = 37456;
            colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", 0.5};
            text = "";
            sizeEx = 0.025;
            x = BGX + 0.03;
            y = BGY + 0.37;
            w = 0.4;
            h = 0.038;
        };

        class ButtonEight: RscDefineButtonMenu {
            idc = 37457;
            colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", 0.5};
            text = "";
            sizeEx = 0.025;
            x = BGX + 0.03;
            y = BGY + 0.42;
            w = 0.4;
            h = 0.038;
        };
    };
};

class vInteraction_Menu {
    idd = 37400;
    movingEnable = 0;
    enableSimulation = 1;

    class controlsBackground {
        class RscTitleBackground: RscDefineText {
            colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", "(profilenamespace getvariable ['GUI_BCG_RGB_A',0.7])"};
            idc = -1;
            x = BGX;
            y = BGY;
            w = BGW;
            h = (1 / 25);
        };

        class MainBackground: RscDefineText {
            idc = -1;
            colorBackground[] = {0,0,0,0.7};
            x = BGX;
            y = BGY + (11 / 250);
            w = BGW;
            h = 0.6 - (22 / 250);
        };

        class Title: RscDefineTitle {
            colorBackground[] = {0,0,0,0};
            idc = 37401;
            text = "$STR_vInAct_Title";
            x = BGX;
            y = BGY;
            w = BGW;
            h = (1 / 25);
        };
    };

    class controls {
        class ButtonClose: RscDefineButtonMenu {
            idc = -1;
            //shortcuts[] = {0x00050000 + 2};
            text = "$STR_Global_Close";
            onButtonClick = "closeDialog 0;";
            x = BGX;
            y = 0.8 - (1 / 25);
            w = (6.25 / 40);
            h = (1 / 25);
        };

        class ButtonOne: RscDefineButtonMenu {
            idc = 37450;
            colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", 0.5};
            text = "";
            sizeEx = 0.025;
            x = BGX + 0.03;
            y = BGY + 0.07;
            w = 0.4;
            h = 0.038;
        };

        class ButtonTwo: RscDefineButtonMenu {
            idc = 37451;
            colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", 0.5};
            text = "";
            sizeEx = 0.025;
            x = BGX + 0.03;
            y = BGY + 0.12;
            w = 0.4;
            h = 0.038;
        };

        class ButtonThree: RscDefineButtonMenu {
            idc = 37452;
            colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", 0.5};
            text = "";
            sizeEx = 0.025;
            x = BGX + 0.03;
            y = BGY + 0.17;
            w = 0.4;
            h = 0.038;
        };

        class ButtonFour: RscDefineButtonMenu {
            idc = 37453;
            colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", 0.5};
            text = "";
            sizeEx = 0.025;
            x = BGX + 0.03;
            y = BGY + 0.22;
            w = 0.4;
            h = 0.038;
        };

        class ButtonFive: RscDefineButtonMenu {
            idc = 37454;
            colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", 0.5};
            text = "";
            sizeEx = 0.025;
            x = BGX + 0.03;
            y = BGY + 0.27;
            w = 0.4;
            h = 0.038;
        };

        class ButtonSix: RscDefineButtonMenu {
            idc = 37455;
            colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", 0.5};
            text = "";
            sizeEx = 0.025;
            x = BGX + 0.03;
            y = BGY + 0.32;
            w = 0.4;
            h = 0.038;
        };
    };
};
