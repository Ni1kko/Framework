/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
    ## CfgDebriefing.hpp
*/

class CfgDebriefing 
{
    class Default 
    {
        title = "Mission Failed";
        subtitle = "";
        description = "";
        pictureBackground = "";
        picture = "";
        pictureColor[] = {0,0.3,0.6,1};
    };

    class NotWhitelisted : Default
	{
        title = "$STR_NotWhitelisted_Title";
        subtitle = "$STR_NotWhitelisted_SubTitle";
        description = "$STR_NotWhitelisted_Descript";
    };

    class Blacklisted : Default
	{
        title = "$STR_Blacklisted_Title";
        subtitle = "$STR_Blacklisted_SubTitle";
        description = "$STR_Blacklisted_Descript";
    };

    class GenericError : Default
	{
        title = "Error";
        subtitle = "An error has occured!";
        description = "A error has occured, please try again or contact an admin if the problem persists.";
    };

    class ClientError : GenericError
	{
        title = "ClientSide Error";
        description = "A client side error has occured, please try again or contact an admin if the problem persists!";
    };

    class ServerError : ClientError
	{
        title = "ServerSide Error";
        description = "A server side error has occured, please try again or contact an admin if the problem persists!";
    };

    class Antihack : Default
	{
        title = "Antihack";
        subtitle = "Nobody likes a hacker";
        description = "You have been flagged for hacking";
    };

    class Logoff : Default
	{
        title = "Logged Off";
        subtitle = "You have logged off!";
        description = "Thank you for playing on our server!";
    };
};