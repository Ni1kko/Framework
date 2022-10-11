class RscDisplayPlayerInventoryKeyManagement 
{
    idd = 2700;
    movingEnable = 0;
    enableSimulation = 1;
    onLoad="uiNamespace setVariable ['RscDisplayPlayerInventoryKeyManagement', _this#0];_this spawn MPClient_fnc_keyMenu;";
    onUnload="uiNamespace setVariable ['RscDisplayPlayerInventoryKeyManagement', displayNull];";
    onDestroy="uiNamespace setVariable ['RscDisplayPlayerInventoryKeyManagement', displayNull]";

    class controlsBackground 
    {
        class RscDefineTitleBackground: RscDefineText 
        {
            idc = 1;
            x = 0.1;
            y = 0.2;
            w = 0.6;
            h = (1 / 25);
            colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", "(profilenamespace getvariable ['GUI_BCG_RGB_A',0.7])"};
        };

        class MainBackground: RscDefineTitleBackground 
        {
            idc = 2;
            y = 0.2 + (11 / 250);
            h = 0.6 - (22 / 250);
            colorBackground[] = {0, 0, 0, 0.7};
        };
    };

    class controls 
    {
        class Title: RscDefineTitle 
        {
            colorBackground[] = {0, 0, 0, 0};
            idc = 3;
            text = "$STR_Keys_Title";
            x = 0.1;
            y = 0.2;
            w = 0.6;
            h = (1 / 25);
        };

        class KeyChainList: RscDefineListBox 
        {
            idc = 4;
            text = "";
            sizeEx = 0.035;
            x = 0.12;
            y = 0.26;
            w = 0.56;
            h = 0.370;
        };

        class NearPlayers: RscDefineCombo 
        {
            idc = 5;
            x = 0.26;
            y = 0.645;
            w = 0.275;
            h = 0.03;
        };

        class ButtonDrop: RscDefineButtonMenu 
        {
            idc = 6;
            text = "$STR_Keys_DropKey";
            onMouseButtonUp = "";
            x = 0.1 + (6.25 / 40) + (1 / 250 / (safezoneW / safezoneH));
            y = 0.8 - (1 / 25);
            w = (6.25 / 40);
            h = (1 / 25);
        };

        class ButtonGive: ButtonDrop 
        {
            idc = 7;
            text = "$STR_Keys_GiveKey";
            onMouseButtonUp = "";
            x = 0.32;
            y = 0.69; 
        };

        class ButtonClose: ButtonGive 
        {
            idc = 8;
            text = "$STR_Global_Close";
            onMouseButtonUp = "closeDialog 0;";
            x = -0.06 + (6.25 / 40) + (1 / 250 / (safezoneW / safezoneH));
            y = 0.8 - (1 / 25);
        };
    };
};