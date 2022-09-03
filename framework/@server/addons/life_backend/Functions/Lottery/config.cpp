class CfgPatches {
    class Lottery {
        units[] = {};
        weapons[] = {};
        requiredAddons[] = {"Database"};
        authors[] = {"Ni1kko"};
    };
};
 
class CfgLottery
{ 
    ticketPrice = 1000; // Price of one ticket
    ticketLength = 4; // Length of ticket number (Larger numbers = more combinations)
    ticketDrawCount = 25; // Amount of winable tickets
};

class CfgFunctions {
    class Life {
        class Lottery_Functions
        {
            file = "\life_backend\Functions\Lottery";
            class lottery_init {postInit = 1;};
            class lottery_pickwinners {};
            class lottery_buyTicket {};
            class lottery_generateTicket {};
        };
    };
};