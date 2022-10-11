/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
    ## CfgFunctions.hpp
*/

onCheat = "_this spawn MPClient_fnc_checkCheatScript";
onPauseScript[] = {
	MPClient_fnc_escInterupt, 
	MPClient_fnc_checkPauseScript
};

#include "CfgFsms.hpp"

class CfgFunctions : CfgFsms
{
    class MPClient
    { 
        class Root
        {
            file = "scripts";
            class init {};
            class preInit {preInit = true;};
            class postInit {postInit = true;};
        };
        
        class Antihack
        {
            file="scripts\antihack"; 
            class clientCrash {};
            class checkMoneyScript {};
            class checkCheatScript {};
            class checkPauseScript {};
        };

        class Actions 
        {
            file = "scripts\actions";
            class arrestAction {};
            class buyLicense {};
            class captureHideout {};
            class catchFish {};
            class dpFinish {};
            class dropFishingNet {};
            class escortAction {};
            class gather {};
            class getDPMission {};
            class gutAnimal {};
            class healHospital {};
            class impoundAction {};
            class mine {};
            class newsBroadcast {};
            class packupSpikes {};
            class pickupItem {};
            class pickupMoney {};
            class postBail {};
            class processAction {}; 
            class pulloutAction {};
            class putInCar {};
            class removeContainer {};
            class repairTruck {};
            class restrainAction {};
            class robAction {};
            class searchAction {};
            class searchVehAction {};
            class seizePlayerAction {};
            class serviceChopper {};
            class stopEscorting {};
            class storeVehicle {};
            class surrender {};
            class spit {};
            class ticketAction {};
            class unrestrain {};
        };
        
        class Civilian 
        {
            file = "scripts\civilian";
            class initCiv {};
            class civMarkers {};
            class demoChargeTimer {};
            class freezePlayer {};
            class jail {};
            class jailMe {};
            class knockedOut {};
            class knockoutAction {};
            class removeLicenses {};
            class robPerson {};
            class robReceive {};
            class tazed {};
        };

        class Cellphone 
        {
            file="scripts\cellphone"; 
            class cellphone_show  {};
            class cellphone_switchDialog {};
            class cellphone_playerFilter {};
            class cellphone_messageShow {};
            class cellphone_startMessage {};
            class cellphone_sendMessage {};
            class cellphone_sendMessageCancel {};
            class cellphone_reply {};
            class cellphone_messageSelect  {};
            class cellphone_messageKeyUp  {};
            class cellphone_messageReceived  {};
        };
        
        class Config 
        {
            file = "scripts\config";
            class houseConfig {};
            class itemWeight {};
            class vehicleAnimate {};
            class vehicleWeightCfg {};
        };

        class Cop 
        {
            file = "scripts\cop";
            class initCop {};
            class bountyReceive {};
            class containerInvSearch {};
            class copInteractionMenu {};
            class copLights {};
            class copMarkers {};
            class copSearch {};
            class copSiren {};
            class doorAnimate {};
            class fedCamDisplay {};
            class licenseCheck {};
            class licensesRead {};
            class questionDealer {};
            class radar {};
            class repairDoor {};
            class restrain {};
            class searchClient {};
            class seizeClient {};
            class sirenLights {};
            class spikeStripEffect {};
            class ticketGive {};
            class ticketPaid {};
            class ticketPay {};
            class ticketPrompt {};
            class vehInvSearch {};
            class wantedGrab {};
        };
        
        class Functions 
        {
            file = "scripts\functions";
            class AAN {};
            class addTimer {};
            class accType {};
            class actionKeyHandler {};
            class animSync {};
            class autoruninit {};
            class autorunswitch {};
            class autoruntoggle {};
            class calWeightDiff {};
            class checkMap {};
            class clearVehicleAmmo {};
            class canspit {};
            class dropItem {};
            class dropItems {};
            class endTimer {};
            class escInterupt {};
            class fetchCfgDetails {};
            class fetchVehInfo {};
            class isDamaged {};
            class giveDiff {};
            class handleDamage {};
            class handleVitrualItem {};
            class handleItem {};
            class hideObj {};
            class isDormant {};
            class isTimerFinished {};
            class inventoryClosed {};
            class inventoryOpened {};
            class isUIDActive {};
            class keyupHandler {};
            class keydownHandler {};
            class loadGear {};
            class nearATM {};
            class nearestDoor {};
            class nearUnits {};
            class numberText {};
            class onFired {};
            class onTakeItem {};
            class playerTextures {};
            class playerTags {};
            class postNewsBroadcast {};
            class pullOutVeh {};
            class pushObject {};
            class receiveItem {};
            class receiveMoney {};
            class revealObjects {};
            class getGear {};
            class getLicenses {};
            class setLicense {};
            class setLicenses {};
            class simDisable {};
            class startLoadout {};
            class stripDownPlayer {};
            class spat {};
            class teleport {};
            class whereAmI {};
            class moveIn {};
            class switchSide {};
            class paychecks {};
            class buyLotteryTicket {};
            class bountySelect {};
            class spawnPlayer {};
            class handleMoney {};
            class setupActions {};
            class setupEVH {};
            class survival {};
            class briefing {};
            class setupStationService {};
            class log {};
            class endMission {};
            class stringReplace {};
            class checkConditions {};
        };

        class Gangs 
        {
            file = "scripts\gangs";
            class createGang {};
            class gangCreated {};
            class gangDisband {};
            class gangDisbanded {};
            class gangInvite {};
            class gangInvitePlayer {};
            class gangKick {};
            class gangLeave {};
            class gangMenu {};
            class gangNewLeader {};
            class gangUpgrade {};
            class initGang {};
        };

        class Gui 
        {
            file = "scripts\gui";
            class abort {};
            class bankDeposit {};
            class bankTransfer {};
            class bankWithdraw {};
            class cameraZoomIn {};
            class createRscLayer {};
            class destroyRscLayer {};
            class displayHandler {};
            class filterGarage {};
            class gangBankResponse {};
            class garageLBChange {};
            class garageMenu {};
            class gui_hook_management {}; 
            class gui_renderGrenadePanel {};
            class gui_renderGroupPanel {};
            class gui_renderNotifications {};
            class gui_renderPartyESP {};
            class gui_renderStatsPanel {};
            class gui_renderVehiclePanel {};
            class gui_renderWaypoints {};
            class gui_renderWeaponPanel {};
            class hasDisplay {};
            class progressBar {};
            class safeFix {};
            class safeInventory {};
            class safeOpen {};
            class safeTake {};
            class sellGarage {};
            class setMapPosition {};
            class spawnConfirm {};
            class spawnMenu {};
            class spawnPointCfg {};
            class spawnPointSelected {};
            class syncData {};
            class unimpound {};
            class useGangBank {};
            class updateControlPos {};
            class vehicleGarageOpen {};
            class vehicleGarage {};
            class setLoadingText {};
        };

        class Housing 
        {
            file = "scripts\housing";
            class buyHouse {};
            class buyHouseGarage {};
            class containerMenu {};
            class copBreakDoor {};
            class copHouseOwner {};
            class garageRefund {};
            class getBuildingPositions {};
            class houseMenu {};
            class initHouses {};
            class lightHouse {};
            class lightHouseAction {};
            class lockHouse {};
            class lockupHouse {};
            class placeContainer {};
            class PlayerInBuilding {};
            class raidHouse {};
            class sellHouse {};
            class sellHouseGarage {};
        };
        
        class Tents 
        {
            file = "scripts\tents";
            class deployTent {};
            class packupTent {};
            class initTents {};
            class tentMenu {};
        };

        class Items 
        {
            file = "scripts\items";
            class blastingCharge {};
            class boltcutter {};
            class defuseKit {};
            class flashbang {};
            class jerrycanRefuel {};
            class jerryRefuel {};
            class lockpick {};
            class placestorage {};
            class spikeStrip {};
            class storageBox {}; 
        };

        class Medical
        {
            file = "scripts\medical";
            class initMed {};
            class deathScreen {};
            class deathScreenKeyHandler {};
            class medicLights {};
            class medicMarkers {};
            class medicRequest {};
            class medicSiren {};
            class medicSirenLights {};
            class onPlayerKilled {};
            class requestMedic {};
            class respawned {};
            class revived {};
            class revivePlayer {};
        };

        class Medical_Agony
        {
            file = "scripts\medical\agony";
            //main damage handler
            class Agony {};
            class KilledInAgony {};
            
            //add or remove effects
            class addBuff {};
            class removeBuff {};

            //effects
            class effects_bleeding {};
            class effects_critHit {};
            class effects_painShock {};
        };

        class Network 
        {
            file = "scripts\functions\network";
            class broadcast {};
            class corpse {};
            class jumpFnc {};
            class say3D {};
            class setFuel {};
            class soundDevice {};
            class bountyHunterTaze {};
        };

        class Inventory
        {
            file = "scripts\inventory";
            //-- Base
            class inventoryCreateMenu {}; 
            class inventoryShow {};
            class inventoryRefresh {};
            //-- Keys
            class inventoryShowKeys {};
            class inventoryKeysGive {};
            class inventoryKeysDrop {};
            class keyMenu {};//--to be removed
            //-- Virtual
            class inventoryShowVirtual {};
            class inventoryVirtualLBSelChanged {};
            class inventoryVirtualComboSelChanged {};
            class inventoryVirtualPlayersComboSelChanged {};
            class inventoryVirtualUseItem {};
            class inventoryVirtualDropItem {};
            class inventoryVirtualGiveItem {};
            class inventoryVirtualMoveItemToVehicle {};
            class inventoryVirtualVehicleUseItem {};
            class inventoryVirtualVehicleTakeItem {};
            //-- Wallet
            class inventoryShowWallet {};
            class inventoryWalletComboSelChanged {};
            class inventoryWalletMoneyLBSelChanged {};
            class inventoryWalletPlayersComboSelChanged {};
            class inventoryWalletDropCash {};
            class inventoryWalletGiveCash {};
            class inventoryWalletLicenseLBSelChanged {};
            class inventoryWalletDropLicense {};
            class inventoryWalletShowLicense {};
        };

        class Y_Menu
        {
            file = "scripts\y_menu";
            class showYMenu {};
            class updateYMenu {};
            class pardon {}; 
            class s_onChar {};
            class s_onCheckedChange {};
            class s_onSliderChange {};
            class settingsMenu {};
            class updateViewDistance {}; 
            class wantedAddP {};
            class wantedInfo {};
            class wantedList {};
            class wantedMenu {};
        };

        class Rebel
        {
            file = "scripts\rebel";
            class initReb {};
        };

        class Shops_Atm
        {
            file = "scripts\shops\atm";
            class atmMenu {};
        };

        class Shops_ChopShop
        {
            file = "scripts\shops\chopshop";
            class chopShopMenu {};
            class chopShopSelection {};
            class chopShopSell {};
            class chopShopSold {};
        };

        class Shops_Clothing
        {
            file = "scripts\shops\clothing";
            class buyClothes {};
            class changeClothes {};
            class clothingFilter {};
            class clothingMenu {};
        };

        class Shops_FuelPump
        {
            file = "scripts\shops\fuelPump";
            class fuelLBchange {};
            class fuelStatOpen {};
        };

        class Shops_License
        {
            file = "scripts\shops\license";
            class licenseShopMenu {};
            class licenseShopMenuUpdate {};
            class licenseShopMenuConfirm {};
        };

        class Shops_Vehicle
        {
            file = "scripts\shops\vehicle";
            class 3dPreviewDisplay {};
            class 3dPreviewExit {};
            class 3dPreviewInit {};
            class vehicleShopBuy {};
            class vehicleShopLBChange {};
            class vehicleShopMenu {};
        };
        
        class Shops_VirtualItem
        {
            file = "scripts\shops\virtualItem";
            class virt_buy {};
            class virt_menu {};
            class virt_sell {};
            class virt_update {};
        };

        class Shops_Weapon
        {
            file = "scripts\shops\weapon";
            class weaponShopAccs {};
            class weaponShopBuySell {};
            class weaponShopFilter {};
            class weaponShopMags {};
            class weaponShopMenu {};
            class weaponShopSelection {};
        };

        class Session 
        {
            file = "scripts\session";
            class fetchPlayerData {};
            class insertPlayerData {};
            class receivePlayerData {};
            class updatePlayerData {};
            class updatePlayerDataPartial {};
        };

        class Utils 
        {
            file = "scripts\utils";
            class util_canautorun {};
            class util_math_round {};
            class util_array_toLower {};
            class util_getVehicleRole {};
            class util_getNearestLocationName {};
            class util_needsReload {};
            class util_getTerrainGradient {};
        };

        class Vehicle
        {
            file = "scripts\vehicle";
            class addVehicle2Chain {};
            class colorVehicle {};
            class deviceMine {};
            class enableIndicator {};
            class disableIndicator {};
            class FuelRefuelcar {};
            class fuelStore {};
            class fuelSupply {};
            class getVehicleIndicatorOffsets {};
            class lockVehicle {};
            class openInventory {};
            class vehiclecolor3DRefresh {};
            class vehicleOwners {};
            class vehicleWeight {};
            class vehInventory {};
            class vehStoreItem {};
            class vehTakeItem {};
            class vInteractionMenu {};
            class triggerAlarm {};
            class disableAlarm {};
        };
    };
};