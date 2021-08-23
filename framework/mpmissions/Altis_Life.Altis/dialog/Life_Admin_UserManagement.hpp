class Life_Admin_UserManagement {
    idd = 9920;
    name= "Life_Admin_UserManagement";
    movingEnable = 0;
    enableSimulation = 1;
    onLoad = "[] spawn {waitUntil {!isNull (findDisplay 9920)}; ((findDisplay 9920) displayCtrl 9921) ctrlSetText ""Enter ban\kick message:""};";

    class controlsBackground {
        class Life_RscTitleBackground: Life_RscText {
            colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", "(profilenamespace getvariable ['GUI_BCG_RGB_A',0.7])"};
            idc = -1;
            x = 0.1;
            y = 0.2;
            w = 0.5;
            h = (1 / 25);
        };

        class MainBackground: Life_RscText {
            colorBackground[] = {0, 0, 0, 0.7};
            idc = -1;
            x = 0.1;
            y = 0.2 + (11 / 250);
            w = 0.5;
            h = 0.3 - (22 / 250);
        };
    };

    class controls { 
        class header_title : Life_RscTitle {
            colorBackground[] = {0, 0, 0, 0};
            idc = -1;
            text = "User Management";
            x = 0.1;
            y = 0.2;
            w = 0.5;
            h = (1 / 25);
        };

        class info_text: Life_RscStructuredText {
            idc = 9921;
            sizeEx = 0.020;
            text = "";
            x = 0.1;
            y = 0.25;
            w = 0.5;
            h = 0.11;
        };

        class msg_editbox: Life_RscEdit {
            idc = 9922;
            text = "";
            x = 0.04 + (6.25 / 40) + (1 / 250 / (safezoneW / safezoneH));
            y = 0.35;
            w = (13 / 40);
            h = (1 / 25);
        };

        class kick_btn: Life_RscButtonMenu {
            idc = -1;
            text = "KICK";
            colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", 0.5};
            onButtonClick = "[] spawn life_fnc_adminKick;";
            x = 0.40 * safezoneW + safezoneX;
            y = 0.5 - (1 / 25);
            w = (6.25 / 40);
            h = (1 / 25);
        };

        class ban_btn: Life_RscButtonMenu {
            idc = -1;
            text = "BAN";
            colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", 0.5};
            onButtonClick = "[] spawn life_fnc_adminBan;";
            x = 0.50 * safezoneW + safezoneX;
            y = 0.5 - (1 / 25);
            w = (6.25 / 40);
            h = (1 / 25);
        };
        class exit_btn: Life_RscButtonMenu {
            idc = -1;
            text = "$STR_Global_Close";
            onButtonClick = "closeDialog 0;";
            x = -0.06 + (6.25 / 40) + (1 / 250 / (safezoneW / safezoneH));
            y = 0.5 - (1 / 25);
            w = (6.25 / 40);
            h = (1 / 25);
        };
    };
};