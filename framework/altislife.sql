SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";
--
-- Compatible with newer MySQL versions. (After MySQL-5.5)
-- This SQL uses utf8mb4 and has CURRENT_TIMESTAMP function.
--


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Creates database `altislife` unless it already exists and uses `altislife`
-- Default Schema
--
CREATE DATABASE IF NOT EXISTS `altislife` DEFAULT CHARACTER SET utf8mb4;
USE `altislife`;

--
-- Drop procedures to ensure no conflicts
--
DROP PROCEDURE IF EXISTS `resetLifeVehicles`;
DROP PROCEDURE IF EXISTS `deleteDeadVehicles`;
DROP PROCEDURE IF EXISTS `deleteOldHouses`;
DROP PROCEDURE IF EXISTS `deleteOldGangs`;
DROP PROCEDURE IF EXISTS `deleteOldContainers`;
DROP PROCEDURE IF EXISTS `deleteOldWanted`;
DROP PROCEDURE IF EXISTS `resetActivePlayerList`;
DROP PROCEDURE IF EXISTS `resetPlayersLife`;
DROP PROCEDURE IF EXISTS `deleteCellMessages`;
DROP PROCEDURE IF EXISTS `deleteDeadTents`;
DROP PROCEDURE IF EXISTS `resetFedVault`;

DELIMITER $$
--
-- Procedures
-- CURRENT_USER function returns the name of the current user in the SQL Server database.
--

CREATE DEFINER=CURRENT_USER PROCEDURE `resetLifeVehicles`()
BEGIN
  UPDATE `vehicles` SET `active`= 0;
END$$

CREATE DEFINER=CURRENT_USER PROCEDURE `deleteDeadVehicles`()
BEGIN
  DELETE FROM `vehicles` WHERE `alive` = 0;
END$$

CREATE DEFINER=CURRENT_USER PROCEDURE `deleteOldHouses`()
BEGIN
  DELETE FROM `houses` WHERE `owned` = 0;
END$$

CREATE DEFINER=CURRENT_USER PROCEDURE `deleteOldGangs`()
BEGIN
  DELETE FROM `gangs` WHERE `active` = 0;
END$$

CREATE DEFINER=CURRENT_USER PROCEDURE `deleteOldContainers`()
BEGIN
  DELETE FROM `containers` WHERE `owned` = 0;
END$$

CREATE DEFINER=CURRENT_USER PROCEDURE `deleteOldWanted`()
BEGIN
  DELETE FROM `wanted` WHERE `active` = 0;
END$$

CREATE DEFINER=CURRENT_USER PROCEDURE `resetActivePlayerList`()
BEGIN
  UPDATE `servers` SET `currentplayers`=  '"[]"';
END$$

CREATE DEFINER=CURRENT_USER PROCEDURE `resetPlayersLife`()
BEGIN
  UPDATE `players` SET `alive`= 0 WHERE `alive` = 1;
END$$

CREATE DEFINER=CURRENT_USER PROCEDURE `deleteCellMessages` ()  BEGIN
  DELETE FROM `cellphone_messages` WHERE `remove` = 0;
END$$

CREATE DEFINER=CURRENT_USER PROCEDURE `deleteDeadTents` ()  BEGIN
  DELETE FROM `tents` WHERE `alive` = 0;
END$$

CREATE DEFINER=CURRENT_USER PROCEDURE `resetFedVault` ()  BEGIN
  UPDATE `servers` SET `vault`= 0;
END$$

CREATE DEFINER=CURRENT_USER PROCEDURE `deactiveLotteryTickets` ()  BEGIN
   UPDATE `lotteryTickets` SET `active`= 0;
END$$

CREATE DEFINER=CURRENT_USER PROCEDURE `deleteOldLotteryTickets` ()  BEGIN
  DELETE FROM `lotteryTickets` WHERE `active` = 0;
END$$

CREATE DEFINER=CURRENT_USER PROCEDURE `deleteClaimedLotteryTickets` ()  BEGIN
  DELETE FROM `unclaimedLotteryTickets` WHERE `claimed` = 0;
END$$

DELIMITER ;

--
-- Table structure for table `servers`
--

CREATE TABLE IF NOT EXISTS `servers` (
    `serverID`        INT NOT NULL AUTO_INCREMENT,
    `hardwareID`      VARCHAR(64) NOT NULL,
    `name`            VARCHAR(255) NOT NULL,
    `world`           VARCHAR(64) NOT NULL,
    `currentplayers`  TEXT NOT NULL,
    `vault`           INT NOT NULL DEFAULT 0,
    `maxplayercount`  INT NOT NULL DEFAULT 0,
    `restartcount`    INT NOT NULL DEFAULT 0,
    `runtime`         INT NOT NULL DEFAULT 0,
    TIMESTAMP         TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`serverID`),
    UNIQUE KEY `unique_serverid` (`serverID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Table structure for table `lotteryTickets`
--

CREATE TABLE IF NOT EXISTS `lotteryTickets` (
    `ticketID`        INT NOT NULL AUTO_INCREMENT,
    `BEGuid`          VARCHAR(64) NOT NULL,
    `numbers`         VARCHAR(255) NOT NULL,
    `bonusball`       INT NOT NULL DEFAULT 0,
    `active`          TINYINT NOT NULL DEFAULT 1,
    `Purchased`       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`ticketID`),
    INDEX `fkIdx_players_lottery` (`BEGuid`),
    CONSTRAINT `FK_players_lottery` FOREIGN KEY `fkIdx_players_lottery` (`BEGuid`)
      REFERENCES `players` (`BEGuid`)
      ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Table structure for table `unclaimedLotteryTickets`
--

CREATE TABLE IF NOT EXISTS `unclaimedLotteryTickets` (
    `ticketID`                INT NOT NULL AUTO_INCREMENT,
    `BEGuid`                  VARCHAR(64) NOT NULL,
    `winnings`                INT NOT NULL DEFAULT 0,
    `bonusball`               TINYINT NOT NULL DEFAULT 1,
    `bonusballWinnings`       INT NOT NULL DEFAULT 0,
    `claimed`                 TINYINT NOT NULL DEFAULT 0,
    `timestamp`               TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`ticketID`),
    INDEX `fkIdx_players_unclaimedlottery` (`BEGuid`),
    CONSTRAINT `FK_players_unclaimedlottery` FOREIGN KEY `fkIdx_players_unclaimedlottery` (`BEGuid`)
      REFERENCES `players` (`BEGuid`)
      ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `players`
--

CREATE TABLE IF NOT EXISTS `players` (
    `uid`          INT NOT NULL AUTO_INCREMENT,
    `serverID`     INT NOT NULL,
    `BEGuid`       VARCHAR(64) NOT NULL,
    `pid`          VARCHAR(17) NOT NULL,
    `name`         VARCHAR(32) NOT NULL,
    `aliases`      TEXT NOT NULL,
    `cash`         INT NOT NULL DEFAULT 0,
    `coplevel`     ENUM('0','1','2','3','4','5','6','7','8','9','10','11','12','13','14','15') NOT NULL DEFAULT '0',
    `reblevel`     ENUM('0','1','2','3','4','5','6','7') NOT NULL DEFAULT '0',
    `mediclevel`   ENUM('0','1','2','3','4','5','6','7','8','9','10') NOT NULL DEFAULT '0',
    `joblevel`     ENUM('0','1','2','3','4','5','6','7') NOT NULL DEFAULT '0',
    `virtualitems` TEXT NOT NULL,
    `civ_licenses` TEXT NOT NULL,
    `cop_licenses` TEXT NOT NULL,
    `reb_licenses` TEXT NOT NULL,
    `med_licenses` TEXT NOT NULL,
    `civ_gear`     TEXT NOT NULL,
    `cop_gear`     TEXT NOT NULL,
    `reb_gear`     TEXT NOT NULL,
    `med_gear`     TEXT NOT NULL,
    `stats`    VARCHAR(25) NOT NULL DEFAULT '"[100,100,0]"'
    `arrested`     TINYINT NOT NULL DEFAULT 0,
    `adminlevel`   ENUM('0','1','2','3','4','5','6','7','8','9','10')  NOT NULL DEFAULT '0',
    `donorlevel`   ENUM('0','1','2','3')  NOT NULL DEFAULT '0',
    `blacklist`    TINYINT NOT NULL DEFAULT 0,
    `alive`    TINYINT NOT NULL DEFAULT 0,
    `position` VARCHAR(32) NOT NULL DEFAULT '"[]"',
    `playtime`     VARCHAR(32) NOT NULL DEFAULT '"[0,0,0,0]"',
    `insert_time`  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `last_seen`    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    PRIMARY KEY (`pid`),
    UNIQUE KEY `unique_uid` (`uid`),
    UNIQUE KEY `unique_beguid` (`BEGuid`),
    CONSTRAINT `FK_server_id` FOREIGN KEY `fkIdx_server_id` (`serverID`) REFERENCES `servers` (`serverID`) ON UPDATE CASCADE ON DELETE CASCADE,
    INDEX `index_name` (`name`),
    INDEX `index_blacklist` (`blacklist`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `cellphone_messages`
--

CREATE TABLE IF NOT EXISTS `cellphone_messages` (
    `id`          INT NOT NULL AUTO_INCREMENT,
    `sender`      VARCHAR(64) NOT NULL,
    `receiver`    VARCHAR(64) NOT NULL,
    `message`     TEXT NOT NULL,
    `sent_at`     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `remove`      TINYINT NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    INDEX `fkIdx_players_cellmsgsender` (`sender`),
    INDEX `fkIdx_players_cellmsgreceiver` (`receiver`),
    CONSTRAINT `FK_players_cellmsgsender` FOREIGN KEY `fkIdx_players_cellmsgsender` (`sender`) REFERENCES `players` (`BEGuid`) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT `FK_players_cellmsgreceiver` FOREIGN KEY `fkIdx_players_cellmsgreceiver` (`receiver`) REFERENCES `players` (`BEGuid`) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `players`
--
CREATE TABLE IF NOT EXISTS `bankaccounts` (
    `accountID`   INT NOT NULL AUTO_INCREMENT,
    `BEGuid`      VARCHAR(64) NOT NULL,
    `funds`       INT NOT NULL DEFAULT 0, 
    
    PRIMARY KEY (`accountID`),
    INDEX `fkIdx_players_bankaccounts` (`BEGuid`),
    CONSTRAINT `FK_players_bankaccounts` FOREIGN KEY `fkIdx_players_bankaccounts` (`BEGuid`)
      REFERENCES `players` (`BEGuid`)
      ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `rcon_logs`
--

CREATE TABLE IF NOT EXISTS `rcon_logs` (
    `id`          INT NOT NULL AUTO_INCREMENT,
    `Type`        VARCHAR(12) NOT NULL,
    `BEGuid`      VARCHAR(64) NOT NULL,
    `pid`         VARCHAR(17) NOT NULL,
    `reason`      TEXT NOT NULL,
    `occured`     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (`id`),
    INDEX `fkIdx_players_logs` (`BEGuid`),
    CONSTRAINT `FK_players_logs` FOREIGN KEY `fkIdx_players_logs` (`BEGuid`)
      REFERENCES `players` (`BEGuid`)
      ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `antihack_logs`
--

CREATE TABLE IF NOT EXISTS `antihack_logs` (
    `id`          INT NOT NULL AUTO_INCREMENT,
    `Type`        VARCHAR(12) NOT NULL,
    `BEGuid`      VARCHAR(64) NOT NULL,
    `steamID`     VARCHAR(17) NOT NULL,
    `log`         TEXT NOT NULL,
    `occured`     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (`id`),
    INDEX `fkIdx_players_ah_logs` (`BEGuid`),
    CONSTRAINT `FK_players_ah_logs` FOREIGN KEY `fkIdx_players_ah_logs` (`BEGuid`)
      REFERENCES `players` (`BEGuid`)
      ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `admin_logs`
--

CREATE TABLE IF NOT EXISTS `admin_logs` (
    `id`          INT NOT NULL AUTO_INCREMENT,
    `Type`        VARCHAR(12) NOT NULL,
    `BEGuid`      VARCHAR(64) NOT NULL,
    `steamID`     VARCHAR(17) NOT NULL,
    `log`         TEXT NOT NULL,
    `occured`     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (`id`),
    INDEX `fkIdx_players_admin_logs` (`BEGuid`),
    CONSTRAINT `FK_players_admin_logs` FOREIGN KEY `fkIdx_players_admin_logs` (`BEGuid`)
      REFERENCES `players` (`BEGuid`)
      ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `vehicles`
--

CREATE TABLE IF NOT EXISTS `vehicles` (
    `id`          INT NOT NULL AUTO_INCREMENT,
    `pid`         VARCHAR(17) NOT NULL,
    `side`        VARCHAR(10) NOT NULL,
    `classname`   VARCHAR(64) NOT NULL,
    `type`        VARCHAR(16) NOT NULL,
    `alive`       TINYINT NOT NULL DEFAULT 1,
    `blacklist`   TINYINT NOT NULL DEFAULT 0,
    `active`      TINYINT NOT NULL DEFAULT 0,
    `plate`       MEDIUMINT NOT NULL,
    `color`       INT NOT NULL,
    `inventory`   TEXT NOT NULL,
    `gear`        TEXT NOT NULL,
    `fuel`        DOUBLE NOT NULL DEFAULT 1,
    `damage`      VARCHAR(256) NOT NULL,
    `insert_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    PRIMARY KEY (`id`),
    INDEX `fkIdx_players_vehicles` (`pid`),
    CONSTRAINT `FK_players_vehicles` FOREIGN KEY `fkIdx_players_vehicles` (`pid`)
      REFERENCES `players` (`pid`)
      ON UPDATE CASCADE ON DELETE CASCADE,
    INDEX `index_side` (`side`),
    INDEX `index_type` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `houses`
-- Needed for extDB latest update on git
--

CREATE TABLE IF NOT EXISTS `houses` (
    `id`          INT NOT NULL AUTO_INCREMENT,
    `pid`         VARCHAR(17) NOT NULL,
    `pos`         VARCHAR(32) DEFAULT NULL,
    `owned`       TINYINT DEFAULT 0,
    `garage`      TINYINT NOT NULL DEFAULT 0,
    `insert_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    PRIMARY KEY (`id`),
    INDEX `fkIdx_players_houses` (`pid`),
    CONSTRAINT `FK_players_houses` FOREIGN KEY `fkIdx_players_houses` (`pid`)
      REFERENCES `players` (`pid`)
      ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `tents`
--

CREATE TABLE IF NOT EXISTS `tents` (
    `id`          INT NOT NULL AUTO_INCREMENT,
    `BEGuid`      VARCHAR(64) NOT NULL,
    `tentID`      VARCHAR(64) NOT NULL,
    `type`        VARCHAR(64) NOT NULL,
    `position`    VARCHAR(32) DEFAULT NULL,
    `vitems`      TEXT NOT NULL,
    `alive`       TINYINT NOT NULL DEFAULT 1,
    `insert_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    PRIMARY KEY (`id`),
    INDEX `fkIdx_players_tents` (`BEGuid`),
    CONSTRAINT `FK_players_tents` FOREIGN KEY `fkIdx_players_tents` (`BEGuid`)
      REFERENCES `players` (`BEGuid`)
      ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `gangs`
-- Needed for extDB latest update on git
--

CREATE TABLE IF NOT EXISTS `gangs` (
    `id`          INT NOT NULL AUTO_INCREMENT,
    `owner`       VARCHAR(17) NOT NULL,
    `name`        VARCHAR(32) DEFAULT NULL,
    `members`     TEXT,
    `maxmembers`  INT DEFAULT 8,
    `bank`        INT DEFAULT 0,
    `active`      TINYINT NOT NULL DEFAULT 1,
    `insert_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    PRIMARY KEY (`id`),
    UNIQUE KEY `unique_name` (`name`),
    INDEX `fkIdx_players_gangs` (`owner`),
    CONSTRAINT `FK_players_gangs` FOREIGN KEY `fkIdx_players_gangs` (`owner`)
      REFERENCES `players` (`pid`)
      ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `containers`
-- Needed for extDB latest update on git
--

CREATE TABLE IF NOT EXISTS `containers` (
    `id`          INT NOT NULL AUTO_INCREMENT,
    `pid`         VARCHAR(17) NOT NULL,
    `classname`   VARCHAR(32) NOT NULL,
    `pos`         VARCHAR(32) DEFAULT NULL,
    `inventory`   TEXT NOT NULL,
    `gear`        TEXT NOT NULL,
    `dir`         VARCHAR(128) DEFAULT NULL,
    `active`      TINYINT NOT NULL DEFAULT 0,
    `owned`       TINYINT NOT NULL DEFAULT 0,
    `insert_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    PRIMARY KEY (`id`),
    INDEX `fkIdx_players_containers` (`pid`),
    CONSTRAINT `FK_players_containers` FOREIGN KEY `fkIdx_players_containers` (`pid`)
      REFERENCES `players` (`pid`)
      ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `wanted`
-- Needed for extDB latest update on git
--

CREATE TABLE IF NOT EXISTS `wanted` (
    `wantedID`     VARCHAR(17) NOT NULL,
    `wantedName`   VARCHAR(32) NOT NULL,
    `wantedCrimes` TEXT NOT NULL,
    `wantedBounty` INT NOT NULL,
    `active`       TINYINT NOT NULL DEFAULT 0,
    `insert_time`  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    PRIMARY KEY (`wantedID`),
    CONSTRAINT `FK_players_wanted` FOREIGN KEY `fkIdx_players_wanted` (`wantedID`)
      REFERENCES `players` (`pid`)
      ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
--
-- Creates default user `arma3` with password `changeme` unless it already exists
-- Granting permissions to user `arma3`, created below
-- Reloads the privileges from the grant tables in the MySQL system database.
--

CREATE USER IF NOT EXISTS `arma3`@`localhost` IDENTIFIED BY 'changeme';
GRANT SELECT, UPDATE, INSERT, EXECUTE ON `altislife`.* TO 'arma3'@'localhost';
FLUSH PRIVILEGES;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
