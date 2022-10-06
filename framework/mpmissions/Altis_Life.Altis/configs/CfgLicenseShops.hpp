/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
    ## cfgLicenseShops.hpp
*/

class cfgLicenseShops 
{
    class Civ_DMV
	{
        name = "Civillan DMV Center";
        side = "";
        conditions = "";
        items[] = {"driver", "trucking", "boat", "pilot"};
    };

	class Cop_DMV
	{
        name = "Police DMV Center";
        side = "cop";
        conditions = "";
        items[] = {"cAir", "cg"};
    };

	class Med_DMV
	{
        name = "Police DMV Center";
        side = "med";
        conditions = "";
        items[] = {"mAir"};
    };

	class Civ_Lic2 
	{
        name = "Civillan License Center";
        side = "civ";
        conditions = "";
        items[] = {"gun", "home", "dive", "bountyhunter", "rebel"};
    };

	class Drug_Cert
	{
		name = "Drug Dealer License Center";
		side = "";
		conditions = "";
		items[] = {"cocaine", "heroin", "marijuana"};
	};

	class Processer_Cert
	{
		name = "Processing License Center";
		side = "";
		conditions = "";
		items[] = {"oil", "diamond", "salt", "sand", "iron", "copper", "cement" };
	};
    
	class Med_dispensary
	{
		name = "Medical Dispensary";
		side = "";
		conditions = "";
		items[] = {"medmarijuana"};
	};
};
