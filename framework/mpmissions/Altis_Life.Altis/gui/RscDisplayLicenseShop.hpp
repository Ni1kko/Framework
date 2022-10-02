class RscDisplayLicenseShop 
{
	idd = 5546;   
	movingEnable = 0;  
	enableSimulation = 1;
    onLoad="uiNamespace setVariable ['RscDisplayLicenseShop', _this#0];";
    onUnload="uiNamespace setVariable ['RscDisplayLicenseShop', displayNull]";
    onDestroy="uiNamespace setVariable ['RscDisplayLicenseShop', displayNull]";

	class controlsBackground 
    {
		class RscTitleBackground : life_RscText
		{
			colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", "(profilenamespace getvariable ['GUI_BCG_RGB_A',0.7])"};  
			idc = 2403;
			text = "$STR_Licenses_Title";
			x = 0.1;
			y = 0.2;
			w = 0.775;
			h = 0.04;
		};  

		class Mainbackground : life_RscText 
		{  
			colorBackground[] = {0,0,0,0.7};  
			idc = -1;  
			x = 0.1;  
			y = 0.244;  
			w = 0.775;  
			h = 0.52;  
		};  
	};
	
	class controls
	{
		class OwnedLicensesTitle : life_RscText 
		{  
			idc = -1;
			text = "Owned Licenses";
			x = 0.65;  
			y = 0.24;  
			w = 0.25; 
			h = 0.04; 
		};
		class AvailableLicensesTitle : OwnedLicensesTitle 
		{
			idc = -1;
			text = "Available Licenses"; 
			x = 0.1875;
		};
		class OwnedLicenses: life_RscStructuredText 
		{
			idc = 55131;  
			text = "";
			sizeEx = 0.035;
			x = 0.55;  
			y = 0.3;  
			w = 0.3125;  
			h = 0.4;  
		};
		class AvailableLicenses: life_RscListBox 
		{
			idc = 55126; 
			text = "";
			sizeEx = 0.035;  
			x = 0.1125;  
			y = 0.3;  
			w = 0.3125;  
			h = 0.4;  
		};
		class Closebutton: life_RscButtonMenu 
		{
			idc = -1;
			text = "$STR_Global_Close";
			x = 0.65;  
			y = 0.72;
			w = 0.15;
			h = 0.04;
			colorText[] = {1,1,1,1};
			colorBackground[] = {0,0,0,0.8};
			onButtonClick = "closeDialog 0;";
		};
		class Purchasebutton: Closebutton 
		{
			idc = 55127;
			text = "$STR_Global_Buy";
			x = 0.1875;
			onButtonClick = "_this spawn MPClient_fnc_licenseShopMenuConfirm;";
		};  
	};  
};  