class RscDisplayVehicleTrunk 
{
    idd = 3500; 
    movingEnable = 0;
    enableSimulation = 1;
    onLoad="uiNamespace setVariable ['RscDisplayVehicleTrunk', _this#0];";
    onUnload="uiNamespace setVariable ['RscDisplayVehicleTrunk', displayNull]";
    onDestroy="uiNamespace setVariable ['RscDisplayVehicleTrunk', displayNull]";


    class controlsBackground {
        class RscTitleBackground: RscDefineText {
            colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", "(profilenamespace getvariable ['GUI_BCG_RGB_A',0.7])"};
            idc = -1;
            x = 0.1;
            y = 0.2;
            w = 0.7;
            h = (1 / 25);
        };

        class RscBackground: RscDefineText {
            colorBackground[] = {0, 0, 0, 0.7};
            idc = -1;
            x = 0.1;
            y = 0.2 + (11 / 250);
            w = 0.7;
            h = 0.7 - (22 / 250);
        };

        class RscTitleText: RscDefineTitle {
            colorBackground[] = {0, 0, 0, 0};
            idc = 3501;
            text = "";
            x = 0.1;
            y = 0.2;
            w = 0.7;
            h = (1 / 25);
        };

        class VehicleWeight : RscTitleText {
            idc = 3504;
            style = 1;
            text = "";
        };

        class RscTrunkText: RscDefineText {
            idc = -1;
            colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", 0.5};
            text = "$STR_Trunk_TInventory";
            sizeEx = 0.04;
            x = 0.11;
            y = 0.25;
            w = 0.3;
            h = 0.04;
        };

        class RscPlayerText: RscDefineText {
            idc = -1;
            colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", 0.5};
            text = "$STR_Trunk_PInventory";
            sizeEx = 0.04;
            x = 0.49;
            y = 0.25;
            w = 0.3;
            h = 0.04;
        };
    };

    class Controls {
        class TrunkGear: RscDefineListBox {
            idc = 3502;
            text = "";
            sizeEx = 0.030;
            x = 0.11;
            y = 0.29;
            w = 0.3;
            h = 0.42;
        };

        class PlayerGear: RscDefineListBox {
            idc = 3503;
            text = "";
            sizeEx = 0.030;

            x = 0.49;
            y = 0.29;
            w = 0.3;
            h = 0.42;
        };

        class TrunkEdit: RscDefineTextEdit {
            idc = 3505;
            text = "1";
            sizeEx = 0.030;
            x = 0.11;
            y = 0.72;
            w = 0.3;
            h = 0.03;
        };

        class PlayerEdit: RscDefineTextEdit {
            idc = 3506;
            text = "1";
            sizeEx = 0.030;
            x = 0.49;
            y = 0.72;
            w = 0.3;
            h = 0.03;
        };

        class TakeItem: RscDefineButtonMenu {
            idc = -1;
            text = "$STR_Trunk_Take";
            colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", 0.5};
            onButtonClick = "[] call MPClient_fnc_vehTakeItem;";
            x = 0.19;
            y = 0.78;
            w = (6.25 / 40);
            h = (1 / 25);
        };

        class StoreItem: RscDefineButtonMenu {
            idc = -1;
            text = "$STR_Trunk_Store";
            colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", 0.5};
            onButtonClick = "[] call MPClient_fnc_vehStoreItem;";
            x = 0.57;
            y = 0.78;
            w = (6.25 / 40);
            h = (1 / 25);
        };

        class ButtonClose: RscDefineButtonMenu {
            idc = -1;
            //shortcuts[] = {0x00050000 + 2};
            text = "$STR_Global_Close";
            onButtonClick = "closeDialog 0;";
            x = 0.1;
            y = 0.9 - (1 / 25);
            w = (6.25 / 40);
            h = (1 / 25);
        };
    };
};