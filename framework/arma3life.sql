-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Sep 05, 2022 at 01:15 AM
-- Server version: 10.4.24-MariaDB
-- PHP Version: 8.1.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `arma3life`
--
CREATE DATABASE IF NOT EXISTS `arma3life` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `arma3life`;

DELIMITER $$
--
-- Procedures
--
DROP PROCEDURE IF EXISTS `deactiveLotteryTickets`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deactiveLotteryTickets` ()   BEGIN
   UPDATE `lotteryTickets` SET `active`= 0;
END$$

DROP PROCEDURE IF EXISTS `deleteCellMessages`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteCellMessages` ()   BEGIN
  DELETE FROM `cellphone_messages` WHERE `remove` = 0;
END$$

DROP PROCEDURE IF EXISTS `deleteClaimedLotteryTickets`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteClaimedLotteryTickets` ()   BEGIN
  DELETE FROM `unclaimedLotteryTickets` WHERE `claimed` = 0;
END$$

DROP PROCEDURE IF EXISTS `deleteDeadTents`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteDeadTents` ()   BEGIN
  DELETE FROM `tents` WHERE `alive` = 0;
END$$

DROP PROCEDURE IF EXISTS `deleteDeadVehicles`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteDeadVehicles` ()   BEGIN
  DELETE FROM `vehicles` WHERE `alive` = 0;
END$$

DROP PROCEDURE IF EXISTS `deleteOldContainers`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteOldContainers` ()   BEGIN
  DELETE FROM `containers` WHERE `owned` = 0;
END$$

DROP PROCEDURE IF EXISTS `deleteOldGangs`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteOldGangs` ()   BEGIN
  DELETE FROM `gangs` WHERE `active` = 0;
END$$

DROP PROCEDURE IF EXISTS `deleteOldHouses`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteOldHouses` ()   BEGIN
  DELETE FROM `houses` WHERE `owned` = 0;
END$$

DROP PROCEDURE IF EXISTS `deleteOldLotteryTickets`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteOldLotteryTickets` ()   BEGIN
  DELETE FROM `lotteryTickets` WHERE `active` = 0;
END$$

DROP PROCEDURE IF EXISTS `deleteOldWanted`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteOldWanted` ()   BEGIN
  DELETE FROM `wanted` WHERE `active` = 0;
END$$

DROP PROCEDURE IF EXISTS `increaseServerRestarts`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `increaseServerRestarts` ()   BEGIN
   UPDATE `servers` SET restartcount = restartcount + 1;
END$$

DROP PROCEDURE IF EXISTS `resetActivePlayerList`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `resetActivePlayerList` ()   BEGIN
  UPDATE `servers` SET `currentplayers`=  '"[]"';
END$$

DROP PROCEDURE IF EXISTS `resetFedVault`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `resetFedVault` ()   BEGIN
  UPDATE `servers` SET `vault`= 0;
END$$

DROP PROCEDURE IF EXISTS `resetLifeVehicles`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `resetLifeVehicles` ()   BEGIN
  UPDATE `vehicles` SET `active`= 0;
END$$

DROP PROCEDURE IF EXISTS `resetPlayersLife`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `resetPlayersLife` ()   BEGIN
  UPDATE `players` SET `alive`= 0 WHERE `alive` = 1;
END$$

DROP PROCEDURE IF EXISTS `completeRemoteExecRequests`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `resetPlayersLife` ()   BEGIN
  UPDATE `remoteexec` SET `Completed`= 'true' WHERE `Completed` = 'false';
END$$

DROP PROCEDURE IF EXISTS `deleteCompletedRemoteExecRequests`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `resetPlayersLife` ()   BEGIN
  DELETE FROM `remoteexec` WHERE `Completed` = 'true';
END$$

DROP PROCEDURE IF EXISTS `increaseImpoundFee`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `increaseImpoundFee` ()   BEGIN
   UPDATE `impounded_vehicles` SET impound_fee = impound_fee + 300;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `admin_logs`
--

DROP TABLE IF EXISTS `admin_logs`;
CREATE TABLE `admin_logs` (
  `id` int(11) NOT NULL,
  `Type` varchar(12) NOT NULL,
  `BEGuid` varchar(64) NOT NULL,
  `steamID` varchar(17) NOT NULL,
  `log` text NOT NULL,
  `occured` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `antihack_logs`
--

DROP TABLE IF EXISTS `antihack_logs`;
CREATE TABLE `antihack_logs` (
  `id` int(11) NOT NULL,
  `Type` varchar(12) NOT NULL,
  `BEGuid` varchar(64) NOT NULL,
  `steamID` varchar(17) NOT NULL,
  `log` text NOT NULL,
  `occured` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `bankaccounts`
--

DROP TABLE IF EXISTS `bankaccounts`;
CREATE TABLE `bankaccounts` (
  `accountID` int(11) NOT NULL,
  `BEGuid` varchar(64) NOT NULL,
  `funds` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `cellphone_messages`
--

DROP TABLE IF EXISTS `cellphone_messages`;
CREATE TABLE `cellphone_messages` (
  `id` int(11) NOT NULL,
  `sender` varchar(64) NOT NULL,
  `receiver` varchar(64) NOT NULL,
  `message` text NOT NULL,
  `sent_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `remove` tinyint(4) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `containers`
--

DROP TABLE IF EXISTS `containers`;
CREATE TABLE `containers` (
  `id` int(11) NOT NULL,
  `pid` varchar(17) NOT NULL,
  `classname` varchar(32) NOT NULL,
  `pos` varchar(32) DEFAULT NULL,
  `inventory` text NOT NULL,
  `gear` text NOT NULL,
  `dir` varchar(128) DEFAULT NULL,
  `active` tinyint(4) NOT NULL DEFAULT 0,
  `owned` tinyint(4) NOT NULL DEFAULT 0,
  `insert_time` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `gangs`
--

DROP TABLE IF EXISTS `gangs`;
CREATE TABLE `gangs` (
  `id` int(11) NOT NULL,
  `owner` varchar(17) NOT NULL,
  `name` varchar(32) DEFAULT NULL,
  `members` text DEFAULT NULL,
  `maxmembers` int(11) DEFAULT 8,
  `bank` int(11) DEFAULT 0,
  `active` tinyint(4) NOT NULL DEFAULT 1,
  `insert_time` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `houses`
--

DROP TABLE IF EXISTS `houses`;
CREATE TABLE `houses` (
  `id` int(11) NOT NULL,
  `pid` varchar(17) NOT NULL,
  `pos` varchar(32) DEFAULT NULL,
  `owned` tinyint(4) DEFAULT 0,
  `garage` tinyint(4) NOT NULL DEFAULT 0,
  `insert_time` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `lotterytickets`
--

DROP TABLE IF EXISTS `lotterytickets`;
CREATE TABLE `lotterytickets` (
  `ticketID` int(11) NOT NULL,
  `serverID` int(11) NOT NULL,
  `BEGuid` varchar(64) NOT NULL,
  `numbers` varchar(255) NOT NULL,
  `bonusball` varchar(12) NOT NULL,
  `active` tinyint(4) NOT NULL DEFAULT 1,
  `Purchased` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `players`
--

DROP TABLE IF EXISTS `players`;
CREATE TABLE `players` (
  `uid` int(11) NOT NULL,
  `serverID` int(11) NOT NULL,
  `BEGuid` varchar(64) NOT NULL,
  `pid` varchar(17) NOT NULL,
  `name` varchar(32) NOT NULL,
  `aliases` text NOT NULL,
  `cash` int(11) NOT NULL DEFAULT 0,
  `coplevel` enum('0','1','2','3','4','5','6','7','8','9','10','11','12','13','14','15') NOT NULL DEFAULT '0',
  `reblevel` enum('0','1','2','3','4','5','6','7') NOT NULL DEFAULT '0',
  `mediclevel` enum('0','1','2','3','4','5','6','7','8','9','10') NOT NULL DEFAULT '0',
  `joblevel` enum('0','1','2','3','4','5','6','7') NOT NULL DEFAULT '0',
  `virtualitems` text NOT NULL,
  `civ_licenses` text NOT NULL,
  `cop_licenses` text NOT NULL,
  `reb_licenses` text NOT NULL,
  `med_licenses` text NOT NULL,
  `civ_gear` text NOT NULL,
  `cop_gear` text NOT NULL,
  `reb_gear` text NOT NULL,
  `med_gear` text NOT NULL,
  `stats` varchar(25) NOT NULL DEFAULT '"[100,100,0]"',
  `arrested` tinyint(4) NOT NULL DEFAULT 0,
  `adminlevel` enum('0','1','2','3','4','5','6','7','8','9','10') NOT NULL DEFAULT '0',
  `donorlevel` enum('0','1','2','3') NOT NULL DEFAULT '0',
  `blacklist` tinyint(4) NOT NULL DEFAULT 0,
  `alive` tinyint(4) NOT NULL DEFAULT 0,
  `position` varchar(32) NOT NULL DEFAULT '"[]"',
  `playtime` varchar(32) NOT NULL DEFAULT '"[0,0,0,0]"',
  `insert_time` timestamp NOT NULL DEFAULT current_timestamp(),
  `last_seen` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `rcon_logs`
--

DROP TABLE IF EXISTS `rcon_logs`;
CREATE TABLE `rcon_logs` (
  `id` int(11) NOT NULL,
  `Type` varchar(12) NOT NULL,
  `BEGuid` varchar(64) NOT NULL,
  `pid` varchar(17) NOT NULL,
  `reason` text NOT NULL,
  `occured` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `servers`
--

DROP TABLE IF EXISTS `servers`;
CREATE TABLE `servers` (
  `serverID` int(11) NOT NULL,
  `hardwareID` varchar(64) NOT NULL,
  `name` varchar(255) NOT NULL,
  `world` varchar(64) NOT NULL,
  `currentplayers` text NOT NULL,
  `vault` int(11) NOT NULL DEFAULT 0,
  `maxplayercount` int(11) NOT NULL DEFAULT 0,
  `restartcount` int(11) NOT NULL DEFAULT 0,
  `runtime` int(11) NOT NULL DEFAULT 0,
  `firstRun` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Table structure for table `remoteexec`
--

DROP TABLE IF EXISTS `remoteexec`;
CREATE TABLE `remote_exec` (
  `JobID` int(11) NOT NULL,
  `serverID` int(11) NOT NULL,
  `expression` text NOT NULL,
  `targets` int(11) NOT NULL DEFAULT 2,
  `completed` enum('false','true') NOT NULL DEFAULT 'false'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `tents`
--

DROP TABLE IF EXISTS `tents`;
CREATE TABLE `tents` (
  `id` int(11) NOT NULL,
  `BEGuid` varchar(64) NOT NULL,
  `tentID` varchar(64) NOT NULL,
  `type` varchar(64) NOT NULL,
  `position` varchar(32) DEFAULT NULL,
  `vitems` text NOT NULL,
  `alive` tinyint(4) NOT NULL DEFAULT 1,
  `insert_time` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `unclaimedlotterytickets`
--

DROP TABLE IF EXISTS `unclaimedlotterytickets`;
CREATE TABLE `unclaimedlotterytickets` (
  `ticketID` int(11) NOT NULL,
  `serverID` int(11) NOT NULL,
  `BEGuid` varchar(64) NOT NULL,
  `winnings` int(11) NOT NULL DEFAULT 0,
  `bonusball` tinyint(4) NOT NULL DEFAULT 1,
  `bonusballWinnings` int(11) NOT NULL DEFAULT 0,
  `claimed` tinyint(4) NOT NULL DEFAULT 0,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `vehicles`
--

DROP TABLE IF EXISTS `vehicles`;
CREATE TABLE `vehicles` (
  `id` int(11) NOT NULL,
  `pid` varchar(17) NOT NULL,
  `side` varchar(10) NOT NULL,
  `classname` varchar(64) NOT NULL,
  `type` varchar(16) NOT NULL,
  `alive` tinyint(4) NOT NULL DEFAULT 1,
  `blacklist` tinyint(4) NOT NULL DEFAULT 0,
  `active` tinyint(4) NOT NULL DEFAULT 0,
  `plate` mediumint(9) NOT NULL,
  `color` int(11) NOT NULL,
  `inventory` text NOT NULL,
  `gear` text NOT NULL,
  `fuel` double NOT NULL DEFAULT 1,
  `damage` varchar(256) NOT NULL,
  `impounded` tinyint(4) NOT NULL DEFAULT 0,
  `insert_time` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `impounded_vehicles`
--

DROP TABLE IF EXISTS `impounded_vehicles`;
CREATE TABLE `impounded_vehicles` (
  `impound_id` int(11) NOT NULL,
  `vehicle_id` int(11) NOT NULL,
  `impound_by_guid` varchar(64) NOT NULL, 
  `impound_fee` int(11) NOT NULL DEFAULT 0,
  `impound_time` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `wanted`
--

DROP TABLE IF EXISTS `wanted`;
CREATE TABLE `wanted` (
  `wantedID` varchar(17) NOT NULL,
  `wantedName` varchar(32) NOT NULL,
  `wantedCrimes` text NOT NULL,
  `wantedBounty` int(11) NOT NULL,
  `active` tinyint(4) NOT NULL DEFAULT 0,
  `insert_time` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin_logs`
--
ALTER TABLE `admin_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fkIdx_players_admin_logs` (`BEGuid`);

--
-- Indexes for table `antihack_logs`
--
ALTER TABLE `antihack_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fkIdx_players_ah_logs` (`BEGuid`);

--
-- Indexes for table `bankaccounts`
--
ALTER TABLE `bankaccounts`
  ADD PRIMARY KEY (`accountID`),
  ADD KEY `fkIdx_players_bankaccounts` (`BEGuid`);

--
-- Indexes for table `cellphone_messages`
--
ALTER TABLE `cellphone_messages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fkIdx_players_cellmsgsender` (`sender`),
  ADD KEY `fkIdx_players_cellmsgreceiver` (`receiver`);

--
-- Indexes for table `containers`
--
ALTER TABLE `containers`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fkIdx_players_containers` (`pid`);

--
-- Indexes for table `gangs`
--
ALTER TABLE `gangs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_name` (`name`),
  ADD KEY `fkIdx_players_gangs` (`owner`);

--
-- Indexes for table `houses`
--
ALTER TABLE `houses`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fkIdx_players_houses` (`pid`);

--
-- Indexes for table `lotterytickets`
--
ALTER TABLE `lotterytickets`
  ADD PRIMARY KEY (`ticketID`),
  ADD KEY `fkIdx_players_lottery` (`BEGuid`),
  ADD KEY `fkIdx_servers_serverID` (`serverID`);

--
-- Indexes for table `players`
--
ALTER TABLE `players`
  ADD PRIMARY KEY (`pid`),
  ADD UNIQUE KEY `unique_uid` (`uid`),
  ADD UNIQUE KEY `unique_beguid` (`BEGuid`),
  ADD KEY `FK_server_id` (`serverID`),
  ADD KEY `index_name` (`name`),
  ADD KEY `index_blacklist` (`blacklist`);

--
-- Indexes for table `rcon_logs`
--
ALTER TABLE `rcon_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fkIdx_players_logs` (`BEGuid`);

--
-- Indexes for table `servers`
--
ALTER TABLE `servers`
  ADD PRIMARY KEY (`serverID`),
  ADD UNIQUE KEY `unique_serverid` (`serverID`);

--
-- Indexes for table `remoteexec`
--
ALTER TABLE `remoteexec`
  ADD PRIMARY KEY (`JobID`),
  ADD KEY `ServerID` (`ServerID`);

--
-- Indexes for table `tents`
--
ALTER TABLE `tents`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fkIdx_players_tents` (`BEGuid`);

--
-- Indexes for table `unclaimedlotterytickets`
--
ALTER TABLE `unclaimedlotterytickets`
  ADD PRIMARY KEY (`ticketID`),
  ADD KEY `fkIdx_players_unclaimedlottery` (`BEGuid`),
  ADD KEY `fkIdx_servers_unclaimedlottery` (`serverID`);

--
-- Indexes for table `vehicles`
--
ALTER TABLE `vehicles`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fkIdx_players_vehicles` (`pid`),
  ADD KEY `index_side` (`side`),
  ADD KEY `index_type` (`type`);

--
-- Indexes for table `impounded_vehicles`
--
ALTER TABLE `impounded_vehicles`
  ADD PRIMARY KEY (`impound_id`),
  ADD KEY `vehicle_id` (`vehicle_id`),
  ADD KEY `impound_by_guid` (`impound_by_guid`);

--
-- Indexes for table `wanted`
--
ALTER TABLE `wanted`
  ADD PRIMARY KEY (`wantedID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admin_logs`
--
ALTER TABLE `admin_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `antihack_logs`
--
ALTER TABLE `antihack_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `bankaccounts`
--
ALTER TABLE `bankaccounts`
  MODIFY `accountID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cellphone_messages`
--
ALTER TABLE `cellphone_messages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `containers`
--
ALTER TABLE `containers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `gangs`
--
ALTER TABLE `gangs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `houses`
--
ALTER TABLE `houses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `lotterytickets`
--
ALTER TABLE `lotterytickets`
  MODIFY `ticketID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `players`
--
ALTER TABLE `players`
  MODIFY `uid` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `rcon_logs`
--
ALTER TABLE `rcon_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `servers`
--
ALTER TABLE `servers`
  MODIFY `serverID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `remoteexec`
--
ALTER TABLE `remoteexec`
  MODIFY `JobID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tents`
--
ALTER TABLE `tents`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `unclaimedlotterytickets`
--
ALTER TABLE `unclaimedlotterytickets`
  MODIFY `ticketID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `vehicles`
--
ALTER TABLE `vehicles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `impounded_vehicles`
--
ALTER TABLE `impounded_vehicles`
  MODIFY `impound_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `admin_logs`
--
ALTER TABLE `admin_logs`
  ADD CONSTRAINT `FK_players_admin_logs` FOREIGN KEY (`BEGuid`) REFERENCES `players` (`BEGuid`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `antihack_logs`
--
ALTER TABLE `antihack_logs`
  ADD CONSTRAINT `FK_players_ah_logs` FOREIGN KEY (`BEGuid`) REFERENCES `players` (`BEGuid`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `bankaccounts`
--
ALTER TABLE `bankaccounts`
  ADD CONSTRAINT `FK_players_bankaccounts` FOREIGN KEY (`BEGuid`) REFERENCES `players` (`BEGuid`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `cellphone_messages`
--
ALTER TABLE `cellphone_messages`
  ADD CONSTRAINT `FK_players_cellmsgreceiver` FOREIGN KEY (`receiver`) REFERENCES `players` (`BEGuid`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_players_cellmsgsender` FOREIGN KEY (`sender`) REFERENCES `players` (`BEGuid`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `containers`
--
ALTER TABLE `containers`
  ADD CONSTRAINT `FK_players_containers` FOREIGN KEY (`pid`) REFERENCES `players` (`pid`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `gangs`
--
ALTER TABLE `gangs`
  ADD CONSTRAINT `FK_players_gangs` FOREIGN KEY (`owner`) REFERENCES `players` (`pid`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `houses`
--
ALTER TABLE `houses`
  ADD CONSTRAINT `FK_players_houses` FOREIGN KEY (`pid`) REFERENCES `players` (`pid`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `remoteexec`
--
ALTER TABLE `remoteexec`
  ADD CONSTRAINT `fdidx_remoteexec_servers` FOREIGN KEY (`ServerID`) REFERENCES `servers` (`serverID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `lotterytickets`
--
ALTER TABLE `lotterytickets`
  ADD CONSTRAINT `FK_players_lottery` FOREIGN KEY (`BEGuid`) REFERENCES `players` (`BEGuid`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_servers_serverID` FOREIGN KEY (`serverID`) REFERENCES `servers` (`serverID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `players`
--
ALTER TABLE `players`
  ADD CONSTRAINT `FK_server_id` FOREIGN KEY (`serverID`) REFERENCES `servers` (`serverID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `rcon_logs`
--
ALTER TABLE `rcon_logs`
  ADD CONSTRAINT `FK_players_logs` FOREIGN KEY (`BEGuid`) REFERENCES `players` (`BEGuid`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `tents`
--
ALTER TABLE `tents`
  ADD CONSTRAINT `FK_players_tents` FOREIGN KEY (`BEGuid`) REFERENCES `players` (`BEGuid`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `unclaimedlotterytickets`
--
ALTER TABLE `unclaimedlotterytickets`
  ADD CONSTRAINT `FK_players_unclaimedlottery` FOREIGN KEY (`BEGuid`) REFERENCES `players` (`BEGuid`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_servers_unclaimedlottery` FOREIGN KEY (`serverID`) REFERENCES `servers` (`serverID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `vehicles`
--
ALTER TABLE `vehicles`
  ADD CONSTRAINT `FK_players_vehicles` FOREIGN KEY (`pid`) REFERENCES `players` (`pid`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `impounded_vehicles`
--
ALTER TABLE `impounded_vehicles`
  ADD CONSTRAINT `FK_IMPOUNDED_PLAYERS_BEGUID` FOREIGN KEY (`impound_by_guid`) REFERENCES `players` (`BEGuid`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_IMPOUNDED_VEHICLES_ID` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `wanted`
--
ALTER TABLE `wanted`
  ADD CONSTRAINT `FK_players_wanted` FOREIGN KEY (`wantedID`) REFERENCES `players` (`pid`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
