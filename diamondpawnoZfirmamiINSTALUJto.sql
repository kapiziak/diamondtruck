-- phpMyAdmin SQL Dump
-- version 3.5.5
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: May 08, 2015 at 08:49 PM
-- Server version: 5.5.21-log
-- PHP Version: 5.3.20

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `diamondpawno`
--

-- --------------------------------------------------------

--
-- Table structure for table `applications`
--

CREATE TABLE IF NOT EXISTS `applications` (
  `id` int(50) NOT NULL AUTO_INCREMENT,
  `nick` varchar(50) NOT NULL,
  `uid` int(50) NOT NULL,
  `company` int(50) NOT NULL,
  `text` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin2 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `bank`
--

CREATE TABLE IF NOT EXISTS `bank` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) NOT NULL,
  `uidto` int(11) NOT NULL,
  `price` int(11) NOT NULL,
  `text` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin2 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `bans`
--

CREATE TABLE IF NOT EXISTS `bans` (
  `id` int(50) NOT NULL AUTO_INCREMENT,
  `nick` varchar(50) NOT NULL,
  `gcpi` varchar(200) NOT NULL,
  `ip` varchar(50) NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `reason` varchar(200) NOT NULL,
  `admin` varchar(50) NOT NULL,
  `banto` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin2 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `cargos`
--

CREATE TABLE IF NOT EXISTS `cargos` (
  `id` int(50) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `minlegal` int(50) NOT NULL DEFAULT '0',
  `minnielegal` int(50) NOT NULL DEFAULT '0',
  `Legal` enum('0','1') NOT NULL DEFAULT '0',
  `NoLegal` enum('0','1') NOT NULL DEFAULT '0',
  `vip` enum('0','1') NOT NULL DEFAULT '0',
  `score` int(50) NOT NULL DEFAULT '0',
  `money` int(50) NOT NULL DEFAULT '0',
  `special` enum('0','1') NOT NULL DEFAULT '0',
  `gabaryt` enum('0','1') NOT NULL DEFAULT '0',
  `adr` enum('0','1') NOT NULL DEFAULT '0',
  `wio` enum('0','1') NOT NULL DEFAULT '0',
  `zwierzeta` enum('0','1') NOT NULL DEFAULT '0',
  `inne` enum('0','1') NOT NULL DEFAULT '0',
  `naczepka` enum('0','1') NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin2 AUTO_INCREMENT=5 ;

--
-- Dumping data for table `cargos`
--

INSERT INTO `cargos` (`id`, `name`, `minlegal`, `minnielegal`, `Legal`, `NoLegal`, `vip`, `score`, `money`, `special`, `gabaryt`, `adr`, `wio`, `zwierzeta`, `inne`, `naczepka`) VALUES
(1, 'Drewno', 0, 0, '1', '0', '0', 5, 100, '0', '0', '0', '0', '0', '0', '1'),
(2, 'Wegorze', 0, 0, '0', '1', '0', 10, 120, '0', '0', '0', '0', '0', '0', '1'),
(3, 'Rakieta', 0, 0, '0', '1', '1', 20, 20, '0', '0', '0', '0', '0', '0', '1'),
(4, 'Rakieta V9', 5, 5, '1', '0', '1', 54, 548, '0', '0', '0', '0', '0', '0', '1');

-- --------------------------------------------------------

--
-- Table structure for table `chat`
--

CREATE TABLE IF NOT EXISTS `chat` (
  `id` int(50) NOT NULL AUTO_INCREMENT,
  `nick` varchar(50) NOT NULL,
  `text` varchar(250) NOT NULL,
  `ingame` enum('0','1') NOT NULL,
  `waiting` enum('0','1') NOT NULL,
  `date` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin2 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `company`
--

CREATE TABLE IF NOT EXISTS `company` (
  `id` int(50) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `spawnx` varchar(100) NOT NULL,
  `spawny` varchar(100) NOT NULL,
  `spawnz` varchar(100) NOT NULL,
  `color` varchar(50) NOT NULL DEFAULT 'FFFFFF',
  `colorinphp` varchar(50) NOT NULL,
  `budget` int(50) NOT NULL DEFAULT '10000',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin2 AUTO_INCREMENT=6 ;

--
-- Dumping data for table `company`
--

INSERT INTO `company` (`id`, `name`, `spawnx`, `spawny`, `spawnz`, `color`, `colorinphp`, `budget`) VALUES
(1, 'Policja', '0.0', '0.0', '4.0', '0xFFFFFFFF', 'FFFFFF', 12760),
(2, 'Pomoc Drogowa', '8.0', '4.0', '8.0', '0x9c0000AA', '9c0000', 100000),
(3, 'Pogotowie', '3.0', '10.0', '8.0', '0x1f8300AA', '1f8300', 10000),
(4, 'Taxi', '0.0', '51.0', '10.0', '0xd5e737AA', 'd5e737', 10000),
(5, 'Euro-Trans', '0.0', '8.0', '8.0', '0x3544ffAA', '3544ff', 15720);

-- --------------------------------------------------------

--
-- Table structure for table `config`
--

CREATE TABLE IF NOT EXISTS `config` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `value` varchar(200) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin2 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `earnedinfo`
--

CREATE TABLE IF NOT EXISTS `earnedinfo` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) NOT NULL,
  `company` int(11) NOT NULL,
  `text` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `data` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `count` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `employess`
--

CREATE TABLE IF NOT EXISTS `employess` (
  `id` int(50) NOT NULL AUTO_INCREMENT,
  `nick` varchar(100) NOT NULL,
  `uid` int(50) NOT NULL,
  `company` int(50) NOT NULL,
  `earned` int(100) NOT NULL DEFAULT '0',
  `range` int(50) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin2 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `fotoradary`
--

CREATE TABLE IF NOT EXISTS `fotoradary` (
  `id` int(30) NOT NULL AUTO_INCREMENT,
  `X` varchar(50) NOT NULL,
  `Y` varchar(50) NOT NULL,
  `Z` varchar(50) NOT NULL,
  `RX` varchar(50) NOT NULL,
  `RY` varchar(50) NOT NULL,
  `RZ` varchar(50) NOT NULL,
  `predkosc` int(50) NOT NULL,
  `kwota` int(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin2 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `fuelstations`
--

CREATE TABLE IF NOT EXISTS `fuelstations` (
  `id` int(50) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `x` varchar(100) NOT NULL,
  `y` varchar(100) NOT NULL,
  `z` varchar(100) NOT NULL,
  `cost` int(50) NOT NULL DEFAULT '5',
  `Paliwo` int(50) NOT NULL DEFAULT '1000',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin2 AUTO_INCREMENT=6 ;

--
-- Dumping data for table `fuelstations`
--

INSERT INTO `fuelstations` (`id`, `name`, `x`, `y`, `z`, `cost`, `Paliwo`) VALUES
(1, 'Magazyny', '64.446311', '-225.900314', '1.572371', 4, 1000),
(2, 'Komisariat_LV', '2204.800048', '2467.850585', '11.261672', 6, 1000),
(3, 'PrzytorowaLV', '2145.095214', '2747.596191', '11.253211', 3, 1000),
(4, 'UFO', '-94.022010', '1355.637817', '10.677564', 5, 1000),
(5, 'Come-A-Lot', '2118.677978', '920.856445', '11.274482', 10, 1000);

-- --------------------------------------------------------

--
-- Table structure for table `houses`
--

CREATE TABLE IF NOT EXISTS `houses` (
  `id` int(50) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `x` varchar(100) NOT NULL,
  `y` varchar(100) NOT NULL,
  `z` varchar(100) NOT NULL,
  `owner` varchar(100) NOT NULL,
  `sell` enum('0','1') NOT NULL DEFAULT '1',
  `price` int(255) NOT NULL DEFAULT '20000',
  `spawn` enum('0','1') DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin2 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `licences`
--

CREATE TABLE IF NOT EXISTS `licences` (
  `id` int(50) NOT NULL AUTO_INCREMENT,
  `ip` varchar(20) NOT NULL,
  `to` date NOT NULL,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin2 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `loading`
--

CREATE TABLE IF NOT EXISTS `loading` (
  `id` int(50) NOT NULL AUTO_INCREMENT,
  `name` varchar(60) NOT NULL,
  `x` varchar(50) NOT NULL,
  `y` varchar(50) NOT NULL,
  `z` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin2 AUTO_INCREMENT=17 ;

--
-- Dumping data for table `loading`
--

INSERT INTO `loading` (`id`, `name`, `x`, `y`, `z`) VALUES
(1, 'Magazyny NULL Farmy', '2.7040', '14.9070', '3.1172'),
(2, 'Kopalnia', '674.775146', '901.421020', '-40.398437'),
(3, 'Elektrownia', '281.143615', '1359.981079', '10.585937'),
(4, 'Farma Ryszarda', '1935.107666', '172.491073', '37.718406'),
(5, 'Come-A-Lot', '2118.380859', '1035.718017', '11.256595'),
(6, 'Statek Piratow', '2019.612060', '1544.627685', '11.301112'),
(7, 'UczelniaLV', '1496.512695', '2773.869628', '11.271026'),
(8, 'Stare Lotnisko', '377.068176', '2541.007568', '16.976362'),
(9, 'Baza Wojskowa', '161.699645', '1974.306884', '19.303382'),
(10, 'U Kosmitow', '-94.558227', '1346.005493', '10.819395'),
(11, 'Fort Carson', '-261.580474', '1212.133911', '20.192955'),
(12, 'Amunation', '-327.148773', '805.485656', '16.139270'),
(13, 'SF Budowa', '-2093.331298', '207.661376', '35.419208'),
(14, 'Budowa LV', '2622.099853', '839.884216', '5.742457'),
(15, 'Doki Wojskowe SF', '-1863.338012', '1398.888549', '7.642146'),
(16, 'Stocznia SF', '-1597.840209', '86.879257', '4.001793');

-- --------------------------------------------------------

--
-- Table structure for table `loginlogs`
--

CREATE TABLE IF NOT EXISTS `loginlogs` (
  `id` int(50) NOT NULL AUTO_INCREMENT,
  `nick` varchar(50) NOT NULL,
  `ip` varchar(50) NOT NULL,
  `gpci` varchar(130) NOT NULL,
  `date` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin2 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `logs`
--

CREATE TABLE IF NOT EXISTS `logs` (
  `id` int(50) NOT NULL AUTO_INCREMENT,
  `nick` varchar(50) NOT NULL,
  `value` varchar(100) NOT NULL,
  `date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin2 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `logsp`
--

CREATE TABLE IF NOT EXISTS `logsp` (
  `id` int(100) NOT NULL AUTO_INCREMENT,
  `desc` varchar(150) NOT NULL,
  `playername` varchar(100) NOT NULL,
  `ingame` enum('0','1') NOT NULL,
  `date` datetime NOT NULL,
  `ip` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin2 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `news`
--

CREATE TABLE IF NOT EXISTS `news` (
  `id` int(50) NOT NULL AUTO_INCREMENT,
  `nick` varchar(50) NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `temat` varchar(50) NOT NULL,
  `text` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin2 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE IF NOT EXISTS `orders` (
  `id` int(50) NOT NULL AUTO_INCREMENT,
  `playeruid` int(50) NOT NULL,
  `vehicle` int(50) NOT NULL,
  `trailer` int(50) NOT NULL,
  `cargo` int(50) NOT NULL,
  `kilometers` varchar(100) NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `status` enum('0','1') NOT NULL DEFAULT '0',
  `unload` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin2 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `poz`
--

CREATE TABLE IF NOT EXISTS `poz` (
  `nr` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) NOT NULL,
  `tresc` text COLLATE utf8_polish_ci NOT NULL,
  `status` enum('0','tak','nie') COLLATE utf8_polish_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`nr`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `trashes`
--

CREATE TABLE IF NOT EXISTS `trashes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `X` varchar(50) NOT NULL,
  `Y` varchar(50) NOT NULL,
  `Z` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin2 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE IF NOT EXISTS `users` (
  `id` int(50) NOT NULL AUTO_INCREMENT,
  `nick` varchar(100) NOT NULL,
  `password` varchar(100) NOT NULL,
  `score` int(50) NOT NULL DEFAULT '0',
  `money` int(50) NOT NULL DEFAULT '0',
  `ip` varchar(30) NOT NULL,
  `host` varchar(40) NOT NULL,
  `team` int(50) NOT NULL DEFAULT '0',
  `vip` enum('0','1') NOT NULL DEFAULT '0',
  `vipto` date NOT NULL,
  `leveladmin` int(50) NOT NULL DEFAULT '0',
  `online` enum('0','1') NOT NULL DEFAULT '0',
  `lastlogin` date NOT NULL DEFAULT '0000-00-00',
  `legal` int(50) NOT NULL DEFAULT '0',
  `nolegal` int(50) NOT NULL DEFAULT '0',
  `osiag1` enum('0','1') NOT NULL DEFAULT '0',
  `osiag2` enum('0','1') NOT NULL DEFAULT '0',
  `osiag3` enum('0','1') NOT NULL DEFAULT '0',
  `osiag4` enum('0','1') NOT NULL DEFAULT '0',
  `skin` int(50) NOT NULL DEFAULT '0',
  `poziom` int(11) NOT NULL DEFAULT '1',
  `bank` int(50) NOT NULL DEFAULT '0',
  `Zlecenia` int(50) NOT NULL DEFAULT '0',
  `autologin` enum('0','1') NOT NULL DEFAULT '1',
  `ADR` enum('0','1') NOT NULL DEFAULT '0',
  `PrawkoA` enum('0','1') NOT NULL DEFAULT '0',
  `PrawkoB` enum('0','1') NOT NULL DEFAULT '0',
  `PrawkoC` enum('0','1') NOT NULL DEFAULT '0',
  `PrawkoD` enum('0','1') NOT NULL DEFAULT '0',
  `PrawkoAto` datetime DEFAULT '0000-00-00 00:00:00',
  `PrawkoBto` datetime DEFAULT '0000-00-00 00:00:00',
  `PrawkoCto` datetime DEFAULT '0000-00-00 00:00:00',
  `PrawkoDto` datetime DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin2 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `vehicles`
--

CREATE TABLE IF NOT EXISTS `vehicles` (
  `id` int(50) NOT NULL AUTO_INCREMENT,
  `model` int(50) NOT NULL,
  `owner` varchar(50) NOT NULL DEFAULT 'Brak',
  `x` varchar(100) NOT NULL,
  `y` varchar(100) NOT NULL,
  `z` varchar(100) NOT NULL,
  `a` varchar(100) NOT NULL,
  `color1` int(50) NOT NULL DEFAULT '0',
  `color2` int(50) NOT NULL DEFAULT '0',
  `team` int(50) NOT NULL DEFAULT '0',
  `price` int(50) NOT NULL DEFAULT '70000',
  `sell` enum('0','1') NOT NULL DEFAULT '0',
  `Paliwo` int(50) NOT NULL DEFAULT '300',
  `Przebieg` varchar(100) NOT NULL DEFAULT '0.00',
  `Olej` int(11) NOT NULL DEFAULT '10',
  `Rynkowa` int(11) NOT NULL DEFAULT '70000',
  `Podatek` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin2 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `versions`
--

CREATE TABLE IF NOT EXISTS `versions` (
  `id` int(50) NOT NULL AUTO_INCREMENT,
  `ver` varchar(50) NOT NULL,
  `name` varchar(50) NOT NULL,
  `desc` text NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin2 AUTO_INCREMENT=1 ;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
