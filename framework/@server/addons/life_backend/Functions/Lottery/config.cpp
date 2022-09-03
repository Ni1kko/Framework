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
};

class CfgFunctions {
    class Life {
        class Lottery_Functions
        {
            file = "\life_backend\Functions\Lottery";
            class lottery_init {postInit = 1;};
            class lottery_pickwinners {};
            class lottery_buyTicket {};
        };
    };
};