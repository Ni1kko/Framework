class RscDisplayVehicleGarage 
{
    idd = 2800;
    movingEnable = 0;
    enableSimulation = 1;
    onLoad="uiNamespace setVariable ['RscDisplayVehicleGarage', _this#0]; ctrlShow [2330,false];";
    onUnload="uiNamespace setVariable ['RscDisplayVehicleGarage', displayNull]";
    onDestroy="uiNamespace setVariable ['RscDisplayVehicleGarage', displayNull]";

    class controlsBackground 
    {
        class RscDefineTitleBackground: RscDefineText 
        {
            colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", "(profilenamespace getvariable ['GUI_BCG_RGB_A',0.7])"};
            idc = -1;
            x = 0.1;
            y = 0.2;
            w = 0.8;
            h = (1 / 25);
        };

        class MainBackground: RscDefineText 
        {
            colorBackground[] = {0,0,0,0.7};
            idc = -1;
            x = 0.1;
            y = 0.2 + (11 / 250);
            w = 0.8;
            h = 0.7 - (22 / 250);
        };

        class Title: RscDefineTitle 
        {
            idc = 2801;
            text = "$STR_GUI_Garage";
            x = 0.1;
            y = 0.2;
            w = 0.8;
            h = (1 / 25);
        };

        class VehicleTitleBox: RscDefineText 
        {
            idc = -1;
            text = "$STR_GUI_YourVeh";
            colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", "(profilenamespace getvariable ['GUI_BCG_RGB_A',0.7])"};
            x = 0.11;
            y = 0.26;
            w = 0.3;
            h = (1 / 25);
        };

        class VehicleInfoHeader: RscDefineText 
        {
            idc = 2830;
            text = "$STR_GUI_VehInfo";
            colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", "(profilenamespace getvariable ['GUI_BCG_RGB_A',0.7])"};
            x = 0.42;
            y = 0.26;
            w = 0.46;
            h = (1 / 25);
        };

        class CloseBtn: RscDefineButtonMenu 
        {
            idc = -1;
            text = "$STR_Global_Close";
            onButtonClick = "closeDialog 0;";
            x = -0.06 + (6.25 / 40) + (1 / 250 / (safezoneW / safezoneH));
            y = 0.9 - (1 / 25);
            w = (6.25 / 40);
            h = (1 / 25);
        };

        class RetrieveCar: RscDefineButtonMenu 
        {
            idc = -1;
            text = "$STR_Global_Retrieve";
            onButtonClick = "[] call MPClient_fnc_unimpound;";
            x = 0.1 + (6.25 / 40) + (1 / 250 / (safezoneW / safezoneH));
            y = 0.9 - (1 / 25);
            w = (6.25 / 40);
            h = (1 / 25);
        };

        class SellCar: RscDefineButtonMenu 
        {
            idc = -1;
            text = "$STR_Global_Sell";
            onButtonClick = "[] call MPClient_fnc_sellGarage; closeDialog 0;";
            x = 0.26 + (6.25 / 40) + (1 / 250 / (safezoneW / safezoneH));
            y = 0.9 - (1 / 25);
            w = (6.25 / 40);
            h = (1 / 25);
        };
    };

    class controls 
    {
        class VehicleList: RscDefineListBox 
        {
            idc = 2802;
            text = "";
            sizeEx = 0.04;
            colorBackground[] = {0.1,0.1,0.1,0.9};
            onLBSelChanged = "_this call MPClient_fnc_garageLBChange;";
            x = 0.11;
            y = 0.302;
            w = 0.303;
            h = 0.49;
        };

        class vehicleInfomationList: RscDefineStructuredText 
        {
            idc = 2803;
            text = "";
            sizeEx = 0.035;
            x = 0.41;
            y = 0.3;
            w = 0.5;
            h = 0.5;
        };

        class MainBackgroundHider: RscDefineText 
        {
            colorBackground[] = {0,0,0,1};
            idc = 2810;
            x = 0.1;
            y = 0.2 + (11 / 250);
            w = 0.8;
            h = 0.7 - (22 / 250);
        };

        class MainHideText: RscDefineText 
        {
            idc = 2811;
            text = "$STR_ANOTF_QueryGarage";
            sizeEx = 0.06;
            x = 0.24;
            y = 0.5;
            w = 0.6;
            h = (1 / 15);
        };

        class Search_veh: RscDefineTextEdit 
        {
            idc = 2812;
            text = "";
            x = 0.11;
            y = 0.8;
            w = 0.3;
            h = 0.04;
            onKeyUp = "[(_this # 0), 2802, 2803] spawn MPClient_fnc_filterGarage";
        };
    };
};