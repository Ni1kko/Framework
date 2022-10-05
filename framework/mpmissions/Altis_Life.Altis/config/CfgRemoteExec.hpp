/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
    ## CfgRemoteExec.hpp
*/

class CfgRemoteExec 
{
    #define F(NAME,TARGET) class NAME { \
        allowedTargets = TARGET; \
    };
    #define JIP(NAME,TARGET) class NAME { \
        allowedTargets = TARGET; \
        jip = 1; \
    };

    #define ANYONE 0
    #define CLIENT 1
    #define SERVER 2
    #define HC extdb_var_database_headless_client
    
    class Functions {
        // RemoteExec modes:
		// 0 - disabled
		// 1 - allowed, taking whitelist into account
		// 2 - allowed, ignoring whitelist (default, because of backward compatibility)
		mode = 2;// 2 while we are developing

		// Ability to send JIP messages:
		// 0 - disable JIP messages
		// 1 - allow JIP messages (default)
		jip = 1;

		//-- Whitelist
        /* Client only functions */
            F(MPClient_fnc_AAN,CLIENT)
            F(MPClient_fnc_addVehicle2Chain,CLIENT)
            F(MPClient_fnc_bountyReceive,CLIENT)
            JIP(MPClient_fnc_copLights,CLIENT)
            F(MPClient_fnc_copSearch,CLIENT)
            JIP(MPClient_fnc_copSiren,CLIENT)
            F(MPClient_fnc_freezePlayer,CLIENT)
            F(MPClient_fnc_gangCreated,CLIENT)
            F(MPClient_fnc_gangDisbanded,CLIENT)
            F(MPClient_fnc_gangInvite,CLIENT)
            F(MPClient_fnc_garageRefund,CLIENT)
            F(MPClient_fnc_giveDiff,CLIENT)
            F(MPClient_fnc_hideObj,CLIENT)
            F(MPClient_fnc_garageMenu,CLIENT)
            F(MPClient_fnc_jail,CLIENT)
            F(MPClient_fnc_jailMe,CLIENT)
            F(MPClient_fnc_knockedOut,CLIENT)
            F(MPClient_fnc_licenseCheck,CLIENT)
            F(MPClient_fnc_licensesRead,CLIENT)
            F(MPClient_fnc_lightHouse,CLIENT)
            JIP(MPClient_fnc_mediclights,CLIENT)
            F(MPClient_fnc_medicRequest,CLIENT)
            JIP(MPClient_fnc_medicSiren,CLIENT)
            F(MPClient_fnc_moveIn,CLIENT)
            F(MPClient_fnc_pickupItem,CLIENT)
            F(MPClient_fnc_pickupMoney,CLIENT)
            F(MPClient_fnc_receiveItem,CLIENT)
            F(MPClient_fnc_receiveMoney,CLIENT)
            F(MPClient_fnc_removeLicenses,CLIENT)
            F(MPClient_fnc_restrain,CLIENT)
            F(MPClient_fnc_revived,CLIENT)
            F(MPClient_fnc_robPerson,CLIENT)
            F(MPClient_fnc_robReceive,CLIENT)
            F(MPClient_fnc_searchClient,CLIENT)
            F(MPClient_fnc_seizeClient,CLIENT)
            F(MPClient_fnc_soundDevice,CLIENT)
            F(MPClient_fnc_spikeStripEffect,CLIENT)
            F(MPClient_fnc_tazeSound,CLIENT)
            F(MPClient_fnc_ticketPaid,CLIENT)
            F(MPClient_fnc_ticketPrompt,CLIENT)
            F(MPClient_fnc_vehicleAnimate,CLIENT)
            F(MPClient_fnc_wantedList,CLIENT)
            F(MPClient_fnc_gangBankResponse,CLIENT)
            F(MPClient_fnc_chopShopSold,CLIENT)
            F(MPClient_fnc_fetchPlayerData,CLIENT)
            F(MPClient_fnc_insertPlayerData,CLIENT)
            F(MPClient_fnc_receivePlayerData,CLIENT)
            F(MPClient_fnc_updatePlayerData,CLIENT)
            F(MPServer_fnc_clientGangKick,CLIENT)
            F(MPServer_fnc_clientGangLeader,CLIENT)
            F(MPServer_fnc_clientGangLeft,CLIENT)
            F(MPServer_fnc_clientGetKey,CLIENT)
            F(MPClient_fnc_spat,CLIENT)
            F(MPClient_fnc_bountyHunterTaze,CLIENT)
            F(MPClient_fnc_handleMoney,CLIENT)
            F(MPClient_fnc_log,CLIENT)
            F(MPClient_fnc_enableIndicator,CLIENT)

        /* Server only functions */
            F(MPServer_fnc_rcon_ban,SERVER)
            F(MPServer_fnc_rcon_kick,SERVER)
            F(MPServer_fnc_clientMessageRequest,SERVER)
            F(MPServer_fnc_insertPlayerDataRequest,SERVER)
            F(MPServer_fnc_fetchPlayerDataRequest,SERVER)
            F(MPServer_fnc_updatePlayerDataRequest,SERVER)
            F(MPServer_fnc_updatePlayerDataRequestPartial,SERVER)
            F(MPServer_fnc_jailSys,SERVER)
            F(MPServer_fnc_wantedAdd,SERVER)
            F(MPServer_fnc_wantedBounty,SERVER)
            F(MPServer_fnc_wantedCrimes,SERVER)
            F(MPServer_fnc_wantedFetch,SERVER)
            F(MPServer_fnc_wantedProfUpdate,SERVER)
            F(MPServer_fnc_wantedRemove,SERVER)
            F(MPServer_fnc_addContainer,SERVER)
            F(MPServer_fnc_addHouse,SERVER)
            F(MPServer_fnc_chopShopSell,SERVER)
            F(MPServer_fnc_cleanupRequest,SERVER)
            F(MPServer_fnc_deleteDBContainer,SERVER)
            F(MPServer_fnc_getVehicles,SERVER)
            F(MPServer_fnc_insertGangDataRequest,SERVER)
            F(MPServer_fnc_keyManagement,SERVER)
            F(MPServer_fnc_managesc,SERVER)
            F(MPServer_fnc_pickupAction,SERVER)
            F(MPServer_fnc_sellHouse,SERVER)
            F(MPServer_fnc_sellHouseContainer,SERVER)
            F(MPServer_fnc_spawnVehicle,SERVER)
            F(MPServer_fnc_spikeStrip,SERVER)
            F(MPServer_fnc_updateGangDataRequestPartial,SERVER)
            F(MPServer_fnc_updateHouseContainers,SERVER)
            F(MPServer_fnc_updateHouseTrunk,SERVER)
            F(MPServer_fnc_log,SERVER)
            F(MPServer_fnc_setMarketDataValue,SERVER)
            F(MPClient_fnc_handleMoneyRequest,SERVER)

            //-- To be removed
            F(MPServer_fnc_vehicleCreate,SERVER)
            F(MPServer_fnc_vehicleDelete,SERVER)
            F(MPServer_fnc_vehicleStore,SERVER)
            //////////////////////////////////////////

            //--- New functions
            F(MPServer_fnc_vehicle_buyRequest,SERVER)
            F(MPServer_fnc_updateVehicleDataRequestPartial,SERVER)
            //////////////////////////////////////////
            
            F(MPServer_fnc_handleBlastingCharge,SERVER)
            F(MPServer_fnc_houseGarage,SERVER)
            F(MPServer_fnc_switchSideRequest,SERVER)
            F(MPServer_fnc_tents_buildRequest,SERVER)
            F(MPServer_fnc_tents_packupRequest,SERVER)
            F(MPServer_fnc_lottery_buyTicket,SERVER)

        /* HeadlessClient only functions */
            F(HC_fnc_addContainer,HC)
            F(HC_fnc_addHouse,HC)
            F(HC_fnc_chopShopSell,HC)
            F(HC_fnc_deleteDBContainer,HC) 
            F(HC_fnc_houseGarage,HC)
            F(HC_fnc_insertPlayerDataRequest,HC)
            F(HC_fnc_insertVehicleDataRequest,HC)
            F(HC_fnc_jailSys,HC)
            F(HC_fnc_keyManagement,HC)
            F(HC_fnc_fetchPlayerDataRequest,HC)
            F(HC_fnc_sellHouse,HC)
            F(HC_fnc_sellHouseContainer,HC)
            F(HC_fnc_spawnVehicle,HC)
            F(HC_fnc_spikeStrip,HC)
            F(HC_fnc_updateGang,HC)
            F(HC_fnc_updateHouseContainers,HC)
            F(HC_fnc_updateHouseTrunk,HC)
            F(HC_fnc_updatePlayerDataRequest,HC)
            F(HC_fnc_vehicleCreate,HC)
            F(HC_fnc_vehicleDelete,HC)
            F(HC_fnc_vehicleStore,HC)
            F(HC_fnc_wantedAdd,HC)
            F(HC_fnc_wantedBounty,HC)
            F(HC_fnc_wantedCrimes,HC)
            F(HC_fnc_wantedFetch,HC)
            F(HC_fnc_wantedProfUpdate,HC)
            F(HC_fnc_wantedRemove,HC)

        /* Functions for everyone */
            F(BIS_fnc_effectKilledAirDestruction,ANYONE)
            F(BIS_fnc_effectKilledSecondaries,ANYONE)
            F(MPClient_fnc_animSync,ANYONE)
            F(MPClient_fnc_broadcast,ANYONE)
            F(MPClient_fnc_colorVehicle,ANYONE)
            F(MPClient_fnc_corpse,ANYONE)
            F(MPClient_fnc_demoChargeTimer,ANYONE)
            F(MPClient_fnc_flashbang,ANYONE)
            F(MPClient_fnc_jumpFnc,ANYONE)
            F(MPClient_fnc_lockVehicle,ANYONE)
            F(MPClient_fnc_pulloutVeh,ANYONE)
            F(MPClient_fnc_say3D,ANYONE)
            F(MPClient_fnc_setFuel,ANYONE)
            F(MPClient_fnc_simDisable,ANYONE)
            F(bis_fnc_debugconsoleexec,ANYONE)
    };

    class Commands {
        mode = 1;
        jip = 0;

        F(addHandgunItem,ANYONE)
        F(addMagazine,ANYONE)
        F(addPrimaryWeaponItem,ANYONE)
        F(addWeapon,ANYONE)
        F(setFuel,ANYONE)
    };
};
