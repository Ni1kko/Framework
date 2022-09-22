class RscDisplayInventory 
{
    idd = 2001;
    movingEnable = 1;
    enableSimulation = 1;
    onLoad="uiNamespace setVariable ['RscDisplayInventory', _this#0];";
    onUnload="uiNamespace setVariable ['RscDisplayInventory', displayNull]";

    class controlsBackground 
    {
        //-- Title Background (idc: 100)
        class Life_RscTitleBackground: Life_RscText 
        {
            colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", "(profilenamespace getvariable ['GUI_BCG_RGB_A',0.7])"};
            idc = 100;
            x = 0.1;
            y = 0.2;
            w = 0.8;
            h = (1 / 25);
        };

        //-- Main Background (idc: 101)
        class MainBackground: Life_RscText 
        {
            colorBackground[] = {0, 0, 0, 0.7};
            idc = 101;
            x = 0.1;
            y = 0.2 + (11 / 250);
            w = 0.8;
            h = 0.6 - (22 / 250);
        };
    };

    class controls 
    {
        //-- Title (idc: 102)
        class Title: Life_RscTitle 
        {
            colorBackground[] = {0, 0, 0, 0};
            idc = 102;
            text = "$STR_PM_Title";
            x = 0.1;
            y = 0.2;
            w = 0.8;
            h = (1 / 25);
        };
        
        //-- Money Info Title (idc: 103)
        class moneySHeader: Life_RscText 
        {
            idc = 103;
            colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", 0.5};
            text = "$STR_PM_MoneyStats";
            sizeEx = 0.04;
            x = 0.11;
            y = 0.26;
            w = 0.219;
            h = 0.04;
        };
        //-- Money Info (idc: 104)
        class moneyStatusInfo: Life_RscStructuredText 
        {
            idc = 104;
            sizeEx = 0.020;
            text = "";
            x = 0.105;
            y = 0.30;
            w = 0.3;
            h = 0.6;
        };
        //-- Money Value Edit (idc: 105)
        class moneyEdit: Life_RscEdit 
        {
            idc = 105;
            text = "1";
            sizeEx = 0.030;
            x = 0.12;
            y = 0.42;
            w = 0.18;
            h = 0.03;
        };
        //-- Money Drop (idc: 106)
        class moneyDrop: Life_RscButtonMenu 
        {
            idc = 106;
            text = "$STR_Global_Give";
            colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", 0.5};
            onButtonClick = "[] call MPClient_fnc_giveMoney";
            sizeEx = 0.025;
            x = 0.135;
            y = 0.50;
            w = 0.13;
            h = 0.036;
        };
        //-- Near Players (idc: 107)
        class NearPlayersListbox1: Life_RscCombo 
        {
            idc = 107;
            x = 0.12;
            y = 0.46;
            w = 0.18;
            h = 0.03;
        };
        //-- Item Title (idc: 108)
        class itemHeader: Life_RscText 
        {
            idc = 108;
            colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", 0.5};
            text = "$STR_PM_cItems";
            sizeEx = 0.04;
            x = 0.62;
            y = 0.26;
            w = 0.275;
            h = 0.04;
        };
        //-- Item List (idc: 109)
        class itemListBox: Life_RscListBox 
        {
            idc = 109;
            sizeEx = 0.030;
            x = 0.62;
            y = 0.30;
            w = 0.275;
            h = 0.3;
        };
        //-- Item Value Edit (idc: 110)
        class itemEdit: Life_RscEdit 
        {
            idc = 110;
            text = "1";
            sizeEx = 0.030;
            x = 0.62;
            y = 0.61;
            w = 0.275;
            h = 0.03;

        };
        //-- Near Players (idc: 111)
        class NearPlayersListbox2: Life_RscCombo 
        {
            idc = 111;
            x = 0.62;
            y = 0.65;
            w = 0.275;
            h = 0.03;
        };  
        //-- Item Give (idc: 112)
        class DropButton: Life_RscButtonMenu 
        {
            idc = 112;
            text = "$STR_Global_Give";
            colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", 0.5};
            onButtonClick = "[] call MPClient_fnc_giveItem;";
            x = 0.765;
            y = 0.70;
            w = (5.25 / 40);
            h = (1 / 25);
        };
        //-- Item Use (idc: 113)
        class UseButton: Life_RscButtonMenu 
        {
            idc = 113;
            text = "$STR_Global_Use";
            colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", 0.5};
            onButtonClick = "[] call MPClient_fnc_useItem;";
            x = 0.62;
            y = 0.70;
            w = (5.25 / 40);
            h = (1 / 25);
        };
        //-- Remove Item (idc: 114)
        class RemoveButton: Life_RscButtonMenu 
        {
            idc = 114;
            text = "$STR_Global_Remove";
            colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", 0.5};
            onButtonClick = "[] call MPClient_fnc_removeItem;";
            x = 0.475;
            y = 0.70;
            w = (5.25 / 40);
            h = (1 / 25);
        };
        //-- License Title (idc: 115)
        class licenseHeader: Life_RscText 
        {
            idc = 115;
            colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", 0.5};
            text = "$STR_PM_Licenses";
            sizeEx = 0.04;
            x = 0.336;
            y = 0.26;
            w = 0.275;
            h = 0.04;
        };
        //-- License List (idc: 116 - 120)
        class Licenses_Group : Life_RscControlsGroup {
            idc = 116;
            w = 0.28;
            h = 0.38;
            x = 0.34;
            y = 0.30;

            class Controls {
                class Life_Licenses: Life_RscStructuredText {
                    idc = 117;
                    sizeEx = 0.020;
                    text = "";
                    x = 0;
                    y = 0;
                    w = 0.27;
                    h = 0.65;
                };
            };
        };
        //-- Weight (idc: 121)
        class Weight: Title 
        {
            idc = 121;
            style = 1;
            text = "";
        };

        //-- Exit menu (idc: 122)
        class ButtonClose: Life_RscButtonMenu 
        {
            idc = 122;
            text = "$STR_Global_Close";
            onButtonClick = "closeDialog 0;";
            x = 0.1;
            y = 0.8 - (1 / 25);
            w = (6.25 / 40);
            h = (1 / 25);
        };
        //-- Settings menu (idc: 123)
        class ButtonSettings: Life_RscButtonMenu 
        {
            idc = 123;
            text = "$STR_Global_Settings";
            onButtonClick = "[] call MPClient_fnc_settingsMenu;";
            x = 0.1 + (6.25 / 40) + (1 / 250 / (safezoneW / safezoneH));
            y = 0.8 - (1 / 25);
            w = (6.25 / 40);
            h = (1 / 25);
        };
        //-- Gang menu (idc: 124)
        class ButtonMyGang: Life_RscButtonMenu 
        {
            idc = 124;
            text = "$STR_PM_MyGang";
            onButtonClick = "if (isNil ""life_action_gangInUse"") then {if (isNil {(group player) getVariable ""gang_owner""}) then {createDialog ""Life_Create_Gang_Diag"";} else {[] spawn MPClient_fnc_gangMenu;};};";
            x = 0.1 + (6.25 / 19.8) + (1 / 250 / (safezoneW / safezoneH));
            y = 0.8 - (1 / 25);
            w = (6.25 / 40);
            h = (1 / 25);
        };
        //-- Wanted menu (idc: 125)
        class ButtonWanted: Life_RscButtonMenu 
        {
            idc = 125;
            text = "$STR_PM_WantedList";
            onButtonClick = "[] call MPClient_fnc_wantedMenu";
            x = 0.1 + (6.25 / 19.8) + (1 / 250 / (safezoneW / safezoneH));
            y = 0.8 - (1 / 25);
            w = (6.25 / 40);
            h = (1 / 25);
        };
        //-- Key chain menu (idc: 126)
        class ButtonKeys: Life_RscButtonMenu 
        {
            idc = 126;
            text = "$STR_PM_KeyChain";
            onButtonClick = "createDialog ""Life_key_management"";";
            x = 0.26 + (6.25 / 19.8) + (1 / 250 / (safezoneW / safezoneH));
            y = 0.8 - (1 / 25);
            w = (6.25 / 40);
            h = (1 / 25);
        };
        //-- Cell phone menu (idc: 127)
        class ButtonCell: Life_RscButtonMenu 
        {
            idc = 127;
            text = "$STR_PM_CellPhone";
            onButtonClick = "[] spawn MPClient_fnc_cellphone_show;";
            x = 0.42 + (6.25 / 19.8) + (1 / 250 / (safezoneW / safezoneH));
            y = 0.8 - (1 / 25);
            w = (6.25 / 40);
            h = (1 / 25);
        };
        //-- Bounty menu (idc: 128)
        class ButtonBountyList: Life_RscButtonMenu 
        {
            idc = 128;
            text = "$STR_PM_BountyList";
            onButtonClick = "[true] call MPClient_fnc_wantedMenu";
            x = 0.1 + (6.25 / 40) + (1 / 250 / (safezoneW / safezoneH));
            y = 0.805;
            w = (6.25 / 40);
            h = (1 / 25);
        };
        //-- Admin menu (idc: 129)
        class ButtonAdminMenu: Life_RscButtonMenu {
            idc = 129;
            text = "$STR_PM_AdminMenu";
            onButtonClick = "closeDialog 0;[]spawn MPClient_fnc_admin_showmenu;";
            show = 0;
            x = 0.1;
            y = 0.805;
            w = (6.25 / 40);
            h = (1 / 25);
        };
    };
};
