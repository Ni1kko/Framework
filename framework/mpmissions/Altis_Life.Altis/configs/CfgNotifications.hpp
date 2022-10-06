/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
    ## CfgNotifications.hpp
*/

class CfgNotifications 
{
    class MedicalRequestEmerg 
	{
        title = "$STR_MedicalRequestEmerg_Title";
        iconPicture = "\A3\ui_f\data\map\mapcontrol\taskIcon_ca.paa";
        description = "%1";
        duration = 5;
        priority = 7;
    };

    class DeliveryAssigned 
	{
        title = "$STR_DeliveryAssigned_Title";
        iconPicture = "\A3\ui_f\data\map\mapcontrol\taskIcon_ca.paa";
        description = "%1";
        duration = 10;
        priority = 7;
    };

    class DeliveryFailed 
	{
        title = "$STR_DeliveryFailed_Title";
        iconPicture = "\A3\ui_f\data\map\mapcontrol\taskiconfailed_ca.paa";
        description = "%1";
        duration = 7;
        priority = 7;
    };

    class DeliverySucceeded 
	{
        title = "$STR_DeliverySucceeded_Title";
        iconPicture = "\A3\ui_f\data\map\mapcontrol\taskIcondone_ca.paa";
        description = "%1";
        duration = 6;
        priority = 6;
    };

    class TextMessage 
	{
        title = "$STR_TextMessage_Title";
        iconPicture = "textures\icons\ico_messageNew.paa";
        description = "%1";
        duration = 10;
        priority = 6;
    };

    class PoliceDispatch 
	{
        title = "$STR_PoliceDispatch_Title";
        iconPicture = "textures\icons\ico_messagePolice.paa";
        description = "%1";
        duration = 10;
        priority = 6;
    };

    class AdminDispatch 
	{
        title = "$STR_AdminDispatch_Title";
        iconPicture = "textures\icons\ico_messageAdmin.paa";
        description = "%1";
        duration = 10;
        priority = 6;
    };

    class AdminMessage 
	{
        title = "$STR_AdminMessage_Title";
        iconPicture = "textures\icons\ico_messageAdmin.paa";
        description = "%1";
        duration = 10;
        priority = 5;
    };
};