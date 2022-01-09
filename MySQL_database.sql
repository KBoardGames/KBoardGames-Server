-- phpMyAdmin SQL Dump
-- version 4.8.3
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 08, 2021 at 01:50 AM
-- Server version: 10.1.36-MariaDB
-- PHP Version: 7.2.11

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `board_games`
--
CREATE DATABASE IF NOT EXISTS `board_games` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE `board_games`;

-- --------------------------------------------------------

--
-- Table structure for table `banned`
--

CREATE TABLE `banned` (
  `id` bigint(20) NOT NULL,
  `user` varchar(12) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `message` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `ip` varchar(16) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `daily_quests`
--

CREATE TABLE `daily_quests` (
  `id` bigint(20) NOT NULL,
  `user` varchar(12) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `three_in_a_row` varchar(2) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '0',
  `chess_5_moves_under` varchar(2) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '0',
  `snakes_under_4_moves` varchar(2) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '0',
  `win_5_minute_game` varchar(2) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '0',
  `buy_four_house_items` varchar(2) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '0',
  `finish_signature_game` varchar(2) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '0',
  `reversi_occupy_50_units` varchar(2) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '0',
  `checkers_get_6_kings` varchar(2) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '0',
  `play_all_5_board_games` varchar(2) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '0',
  `day_name` varchar(10) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `rewards` varchar(6) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '0,0,0',
  `timestamp` varchar(12) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `events`
--

CREATE TABLE `events` (
  `id` bigint(20) NOT NULL,
  `name` varchar(30) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `description` text CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `month_0` int(2) NOT NULL DEFAULT '0',
  `month_1` int(2) NOT NULL DEFAULT '0',
  `month_2` int(2) NOT NULL DEFAULT '0',
  `month_3` int(2) NOT NULL DEFAULT '0',
  `month_4` int(2) NOT NULL DEFAULT '0',
  `month_5` int(2) NOT NULL DEFAULT '0',
  `month_6` int(2) NOT NULL DEFAULT '0',
  `month_7` int(2) NOT NULL DEFAULT '0',
  `month_8` int(2) NOT NULL DEFAULT '0',
  `month_9` int(2) NOT NULL DEFAULT '0',
  `month_10` int(2) NOT NULL DEFAULT '0',
  `month_11` int(2) NOT NULL DEFAULT '0',
  `day_1` int(2) NOT NULL DEFAULT '0',
  `day_2` int(2) NOT NULL DEFAULT '0',
  `day_3` int(2) NOT NULL DEFAULT '0',
  `day_4` int(2) NOT NULL DEFAULT '0',
  `day_5` int(2) NOT NULL DEFAULT '0',
  `day_6` int(2) NOT NULL DEFAULT '0',
  `day_7` int(2) NOT NULL DEFAULT '0',
  `day_8` int(2) NOT NULL DEFAULT '0',
  `day_9` int(2) NOT NULL DEFAULT '0',
  `day_10` int(2) NOT NULL DEFAULT '0',
  `day_11` int(2) NOT NULL DEFAULT '0',
  `day_12` int(2) NOT NULL DEFAULT '0',
  `day_13` int(2) NOT NULL DEFAULT '0',
  `day_14` int(2) NOT NULL DEFAULT '0',
  `day_15` int(2) NOT NULL DEFAULT '0',
  `day_16` int(2) NOT NULL DEFAULT '0',
  `day_17` int(2) NOT NULL DEFAULT '0',
  `day_18` int(2) NOT NULL DEFAULT '0',
  `day_19` int(2) NOT NULL DEFAULT '0',
  `day_20` int(2) NOT NULL DEFAULT '0',
  `day_21` int(2) NOT NULL DEFAULT '0',
  `day_22` int(2) NOT NULL DEFAULT '0',
  `day_23` int(2) NOT NULL DEFAULT '0',
  `day_24` int(2) NOT NULL DEFAULT '0',
  `day_25` int(2) NOT NULL DEFAULT '0',
  `day_26` int(2) NOT NULL DEFAULT '0',
  `day_27` int(2) NOT NULL DEFAULT '0',
  `day_28` int(2) NOT NULL DEFAULT '0',
  `background_colour` int(2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `events`
--

INSERT INTO `events` (`id`, `name`, `description`, `month_0`, `month_1`, `month_2`, `month_3`, `month_4`, `month_5`, `month_6`, `month_7`, `month_8`, `month_9`, `month_10`, `month_11`, `day_1`, `day_2`, `day_3`, `day_4`, `day_5`, `day_6`, `day_7`, `day_8`, `day_9`, `day_10`, `day_11`, `day_12`, `day_13`, `day_14`, `day_15`, `day_16`, `day_17`, `day_18`, `day_19`, `day_20`, `day_21`, `day_22`, `day_23`, `day_24`, `day_25`, `day_26`, `day_27`, `day_28`, `background_colour`) VALUES
(53, 'Credits', 'Win a game and earn credits. You can use credits to improve your board game account. When you have enough credits you can redeem your credits for something available at the website.\r\nA credit is given only when you win a game on the day that this event is active. There are credits_today and credits_total for each player in the database. The credits_total will plus one in count every time a credit at credits_today is given. There is a limit of 5 credits per day for credits_today when the credits event is active. \r\nWhen the player first logs in, the current month and day values are compared to that in the database. If that current month value and/or day value does not match the month and day values in the database then a new month and/or day value(s) will be written to the database and the credits_today value set back to zero.', 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 3),
(54, 'Double XP', 'On the day of this event, you will receive double the experience points after your game has ended. A game win gives the full experience points value for that game, while a game loss gives half experience point value for that game. You will receive no experience points for a draw.\r\nDifferent games give different experience points. A game that gives higher experience points is a game that can take longer to finish. Chess can end in three moves but can also take a very long time to finish. Checkers and chess both have a 50 move rules. Therefore, checkers and chess give the same amount of experience points.\r\nAt the website, click the \'Experience Points\' at the main menu. There is a table containing all 2000 experience point level and the experience points needed to advance to a level. So, if you have 110 experience points then you are a level 2 player and depending on your level, a board game feature could be unlocked.', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 4),
(55, 'House Coins', 'House is a side game where you can make isometric rooms by purchasing furniture and then placing that furniture anywhere in the house. You start with an empty room by placing floor tiles on the floor. You can add walls, doors and windows. The room is large. You are able to scroll the scene by hovering the mouse cursor from near the edge of the scene to the edge of the scene.\r\nYou can arrange the furniture anyway you like. You can place a furniture item behind a wall or place it in front of a wall. You can stack a furniture item on top of another furniture item or underneath it.\r\nYou can only receive a house coin when this event is active. Use house coins to purchase furniture. You will be given 1 house coin when you lose a board game and 2 house coins when you win a board game.', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 5);

-- --------------------------------------------------------

--
-- Table structure for table `house`
--

CREATE TABLE `house` (
  `id` bigint(20) NOT NULL,
  `user` varchar(12) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `sprite_number` text CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `sprite_name` text CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `items_x` text CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `items_y` text CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `map_x` text CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `map_y` text CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `is_item_purchased` text CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `item_direction_facing` text CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `map_offset_x` text CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `map_offset_y` text CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `item_is_hidden` text CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `item_order` text CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `item_behind_walls` text CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `floor` text CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `floor_is_hidden` text CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `wall_left` text CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `wall_left_is_hidden` text CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `wall_up_behind` text CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `wall_up_in_front` text CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `wall_up_behind_is_hidden` text CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `wall_up_in_front_is_hidden` text CHARACTER SET utf8 COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `kicked`
--

CREATE TABLE `kicked` (
  `id` bigint(20) NOT NULL,
  `user` varchar(12) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `message` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `timestamp` varchar(15) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `minutes_total` smallint(2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `logged_in_hostname`
--

CREATE TABLE `logged_in_hostname` (
  `id` bigint(20) NOT NULL,
  `hostname` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `logged_in_users`
--

CREATE TABLE `logged_in_users` (
  `id` bigint(20) NOT NULL,
  `user` varchar(12) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `ip` varchar(16) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `host` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `timestamp` varchar(12) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `room_state` varchar(2) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `move_history`
--

CREATE TABLE `move_history` (
  `id` bigint(20) NOT NULL,
  `user` varchar(12) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `gid` varchar(20) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `point_value` varchar(254) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `unique_value` varchar(254) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `piece_location_old1` text CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `piece_location_new1` text CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `piece_location_old2` text CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `piece_location_new2` text CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `piece_value_old1` text CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `piece_value_new1` text CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `piece_value_old2` text CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `piece_value_new2` text CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `piece_value_old3` text CHARACTER SET utf8 COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `online_users`
--

CREATE TABLE `online_users` (
  `session` char(100) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '',
  `time` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `room_data`
--

CREATE TABLE `room_data` (
  `id` bigint(20) NOT NULL,
  `user` varchar(12) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `user_id` varchar(254) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `move_number_dynamic` smallint(2) NOT NULL DEFAULT '0',
  `room_state` smallint(2) NOT NULL DEFAULT '0',
  `user_location` smallint(3) NOT NULL DEFAULT '0',
  `room` smallint(3) NOT NULL DEFAULT '0',
  `player_limit` smallint(2) NOT NULL DEFAULT '0',
  `game_id` smallint(3) NOT NULL DEFAULT '-1',
  `vs_computer` smallint(2) NOT NULL DEFAULT '0',
  `allow_spectators` smallint(2) NOT NULL DEFAULT '0',
  `is_game_finished` tinyint(1) NOT NULL DEFAULT '1',
  `spectator_playing` tinyint(1) NOT NULL DEFAULT '0',
  `spectator_watching` tinyint(1) NOT NULL DEFAULT '0',
  `game_players_values` smallint(2) NOT NULL DEFAULT '0',
  `timestamp` varchar(12) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `room_lock`
--

CREATE TABLE `room_lock` (
  `id` bigint(20) NOT NULL,
  `user` varchar(12) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `room` int(2) NOT NULL,
  `is_locked` int(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `servers_status`
--

CREATE TABLE `servers_status` (
  `id` int(11) NOT NULL,
  `servers_online` int(3) NOT NULL DEFAULT '1',
  `connected_1` tinyint(1) NOT NULL DEFAULT '0',
  `connected_2` tinyint(1) NOT NULL DEFAULT '0',
  `connected_3` tinyint(1) NOT NULL DEFAULT '0',
  `connected_4` tinyint(1) NOT NULL DEFAULT '0',
  `connected_5` tinyint(1) NOT NULL DEFAULT '0',
  `connected_6` tinyint(1) NOT NULL DEFAULT '0',
  `connected_7` tinyint(1) NOT NULL DEFAULT '0',
  `connected_8` tinyint(1) NOT NULL DEFAULT '0',
  `connected_9` tinyint(1) NOT NULL DEFAULT '0',
  `connected_10` tinyint(1) NOT NULL DEFAULT '0',
  `connected_11` tinyint(1) NOT NULL DEFAULT '0',
  `connected_12` tinyint(1) NOT NULL DEFAULT '0',
  `connected_13` tinyint(1) NOT NULL DEFAULT '0',
  `connected_14` tinyint(1) NOT NULL DEFAULT '0',
  `connected_15` tinyint(1) NOT NULL DEFAULT '0',
  `connected_16` tinyint(1) NOT NULL DEFAULT '0',
  `connected_17` tinyint(1) NOT NULL DEFAULT '0',
  `connected_18` tinyint(1) NOT NULL DEFAULT '0',
  `connected_19` tinyint(1) NOT NULL DEFAULT '0',
  `connected_20` tinyint(1) NOT NULL DEFAULT '0',
  `disconnect_1` tinyint(1) NOT NULL DEFAULT '0',
  `disconnect_2` tinyint(1) NOT NULL DEFAULT '0',
  `disconnect_3` tinyint(1) NOT NULL DEFAULT '0',
  `disconnect_4` tinyint(1) NOT NULL DEFAULT '0',
  `disconnect_5` tinyint(1) NOT NULL DEFAULT '0',
  `disconnect_6` tinyint(1) NOT NULL DEFAULT '0',
  `disconnect_7` tinyint(1) NOT NULL DEFAULT '0',
  `disconnect_8` tinyint(1) NOT NULL DEFAULT '0',
  `disconnect_9` tinyint(1) NOT NULL DEFAULT '0',
  `disconnect_10` tinyint(1) NOT NULL DEFAULT '0',
  `disconnect_11` tinyint(1) NOT NULL DEFAULT '0',
  `disconnect_12` tinyint(1) NOT NULL DEFAULT '0',
  `disconnect_13` tinyint(1) DEFAULT '0',
  `disconnect_14` tinyint(1) NOT NULL DEFAULT '0',
  `disconnect_15` tinyint(1) NOT NULL DEFAULT '0',
  `disconnect_16` tinyint(1) NOT NULL DEFAULT '0',
  `disconnect_17` tinyint(1) NOT NULL DEFAULT '0',
  `disconnect_18` tinyint(1) NOT NULL DEFAULT '0',
  `disconnect_19` tinyint(1) NOT NULL DEFAULT '0',
  `disconnect_20` tinyint(1) NOT NULL DEFAULT '0',
  `timestamp_1` varchar(15) COLLATE utf8_bin NOT NULL DEFAULT '0',
  `timestamp_2` varchar(15) COLLATE utf8_bin NOT NULL DEFAULT '0',
  `timestamp_3` varchar(15) COLLATE utf8_bin NOT NULL DEFAULT '0',
  `timestamp_4` varchar(15) COLLATE utf8_bin NOT NULL DEFAULT '0',
  `timestamp_5` varchar(15) COLLATE utf8_bin NOT NULL DEFAULT '0',
  `timestamp_6` varchar(15) COLLATE utf8_bin NOT NULL DEFAULT '0',
  `timestamp_7` varchar(15) COLLATE utf8_bin NOT NULL DEFAULT '0',
  `timestamp_8` varchar(15) COLLATE utf8_bin NOT NULL DEFAULT '0',
  `timestamp_9` varchar(15) COLLATE utf8_bin NOT NULL DEFAULT '0',
  `timestamp_10` varchar(15) COLLATE utf8_bin NOT NULL DEFAULT '0',
  `timestamp_11` varchar(15) COLLATE utf8_bin NOT NULL DEFAULT '0',
  `timestamp_12` varchar(15) COLLATE utf8_bin NOT NULL DEFAULT '0',
  `timestamp_13` varchar(15) COLLATE utf8_bin NOT NULL DEFAULT '0',
  `timestamp_14` varchar(15) COLLATE utf8_bin NOT NULL DEFAULT '0',
  `timestamp_15` varchar(15) COLLATE utf8_bin NOT NULL DEFAULT '0',
  `timestamp_16` varchar(15) COLLATE utf8_bin NOT NULL DEFAULT '0',
  `timestamp_17` varchar(15) COLLATE utf8_bin NOT NULL DEFAULT '0',
  `timestamp_18` varchar(15) COLLATE utf8_bin NOT NULL DEFAULT '0',
  `timestamp_19` varchar(15) COLLATE utf8_bin NOT NULL DEFAULT '0',
  `timestamp_20` varchar(15) COLLATE utf8_bin NOT NULL DEFAULT '0',
  `message_offline` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT '',
  `message_online` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT '',
  `do_once_1` tinyint(1) NOT NULL DEFAULT '0',
  `do_once_2` tinyint(1) NOT NULL DEFAULT '0',
  `do_once_3` tinyint(1) NOT NULL DEFAULT '0',
  `do_once_4` tinyint(1) NOT NULL DEFAULT '0',
  `do_once_5` tinyint(1) NOT NULL DEFAULT '0',
  `do_once_6` tinyint(1) NOT NULL DEFAULT '0',
  `do_once_7` tinyint(1) NOT NULL DEFAULT '0',
  `do_once_8` tinyint(1) NOT NULL DEFAULT '0',
  `do_once_9` tinyint(1) NOT NULL DEFAULT '0',
  `do_once_10` tinyint(1) NOT NULL DEFAULT '0',
  `do_once_11` tinyint(1) NOT NULL DEFAULT '0',
  `do_once_12` tinyint(1) NOT NULL DEFAULT '0',
  `do_once_13` tinyint(1) NOT NULL DEFAULT '0',
  `do_once_14` tinyint(1) NOT NULL DEFAULT '0',
  `do_once_15` tinyint(1) NOT NULL DEFAULT '0',
  `do_once_16` tinyint(1) NOT NULL DEFAULT '0',
  `do_once_17` tinyint(1) NOT NULL DEFAULT '0',
  `do_once_18` tinyint(1) NOT NULL DEFAULT '0',
  `do_once_19` tinyint(1) NOT NULL DEFAULT '0',
  `do_once_20` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Dumping data for table `servers_status`
--

INSERT INTO `servers_status` (`id`, `servers_online`, `connected_1`, `connected_2`, `connected_3`, `connected_4`, `connected_5`, `connected_6`, `connected_7`, `connected_8`, `connected_9`, `connected_10`, `connected_11`, `connected_12`, `connected_13`, `connected_14`, `connected_15`, `connected_16`, `connected_17`, `connected_18`, `connected_19`, `connected_20`, `disconnect_1`, `disconnect_2`, `disconnect_3`, `disconnect_4`, `disconnect_5`, `disconnect_6`, `disconnect_7`, `disconnect_8`, `disconnect_9`, `disconnect_10`, `disconnect_11`, `disconnect_12`, `disconnect_13`, `disconnect_14`, `disconnect_15`, `disconnect_16`, `disconnect_17`, `disconnect_18`, `disconnect_19`, `disconnect_20`, `timestamp_1`, `timestamp_2`, `timestamp_3`, `timestamp_4`, `timestamp_5`, `timestamp_6`, `timestamp_7`, `timestamp_8`, `timestamp_9`, `timestamp_10`, `timestamp_11`, `timestamp_12`, `timestamp_13`, `timestamp_14`, `timestamp_15`, `timestamp_16`, `timestamp_17`, `timestamp_18`, `timestamp_19`, `timestamp_20`, `message_offline`, `message_online`, `do_once_1`, `do_once_2`, `do_once_3`, `do_once_4`, `do_once_5`, `do_once_6`, `do_once_7`, `do_once_8`, `do_once_9`, `do_once_10`, `do_once_11`, `do_once_12`, `do_once_13`, `do_once_14`, `do_once_15`, `do_once_16`, `do_once_17`, `do_once_18`, `do_once_19`, `do_once_20`) VALUES
(0, 13, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', 'This server will shutdown after 30 minutes expires because of server and/or client maintenance.', 'The admin cancelled the server from going offline. The server does not need to shutdown. Everything seems to be OK.', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `statistics`
--

CREATE TABLE `statistics` (
  `id` bigint(20) NOT NULL,
  `user` varchar(12) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `ip` varchar(15) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `user_avatar` varchar(10) NOT NULL DEFAULT '0.png',
  `timestamp` int(15) NOT NULL,
  `is_kicked` tinyint(1) NOT NULL DEFAULT '0',
  `is_banned` tinyint(1) NOT NULL DEFAULT '0',
  `world_flag` smallint(6) NOT NULL DEFAULT '0',
  `experience_points` float NOT NULL DEFAULT '0',
  `event_month` int(2) NOT NULL,
  `event_day` int(2) NOT NULL,
  `chess_elo_rating` float NOT NULL DEFAULT '0',
  `credits_today` int(11) NOT NULL DEFAULT '0',
  `credits_total` int(11) NOT NULL DEFAULT '0',
  `house_coins` int(11) NOT NULL DEFAULT '100',
  `tournament_points` int(11) NOT NULL DEFAULT '0',
  `total_games_played` int(11) NOT NULL DEFAULT '0',
  `highest_experience_points` int(11) NOT NULL DEFAULT '0',
  `highest_credits` int(11) NOT NULL DEFAULT '0',
  `highest_house_coins` int(11) NOT NULL DEFAULT '0',
  `shortest_time_game_played` int(11) NOT NULL DEFAULT '999999999',
  `longest_time_game_played` int(11) NOT NULL DEFAULT '0',
  `longest_current_winning_streak` int(11) NOT NULL DEFAULT '0',
  `highest_winning_streak` int(11) NOT NULL DEFAULT '0',
  `longest_current_losing_streak` int(11) NOT NULL DEFAULT '0',
  `highest_losing_streak` int(11) NOT NULL DEFAULT '0',
  `longest_current_draw_streak` int(11) NOT NULL DEFAULT '0',
  `highest_draw_streak` int(11) NOT NULL DEFAULT '0',
  `games_all_total_wins` int(11) NOT NULL DEFAULT '0',
  `games_all_total_losses` int(11) NOT NULL DEFAULT '0',
  `games_all_total_draws` int(11) NOT NULL DEFAULT '0',
  `checkers_wins` int(11) NOT NULL DEFAULT '0',
  `checkers_losses` int(11) NOT NULL DEFAULT '0',
  `checkers_draws` int(11) NOT NULL DEFAULT '0',
  `chess_wins` int(11) NOT NULL DEFAULT '0',
  `chess_losses` int(11) NOT NULL DEFAULT '0',
  `chess_draws` int(11) NOT NULL DEFAULT '0',
  `reversi_wins` int(11) NOT NULL DEFAULT '0',
  `reversi_losses` int(11) NOT NULL DEFAULT '0',
  `reversi_draws` int(11) NOT NULL DEFAULT '0',
  `snakes_and_ladders_wins` int(11) NOT NULL DEFAULT '0',
  `snakes_and_ladders_losses` int(11) NOT NULL DEFAULT '0',
  `snakes_and_ladders_draws` int(11) NOT NULL DEFAULT '0',
  `signature_game_wins` int(11) NOT NULL DEFAULT '0',
  `signature_game_losses` int(11) NOT NULL DEFAULT '0',
  `signature_game_draws` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `tournament_chess_standard_8`
--

CREATE TABLE `tournament_chess_standard_8` (
  `id` int(11) NOT NULL,
  `player1` varchar(12) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `player2` varchar(12) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `gid` varchar(20) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `uid` bigint(20) NOT NULL,
  `players` tinyint(4) NOT NULL DEFAULT '7',
  `move_total` tinyint(4) NOT NULL DEFAULT '0',
  `round_current` tinyint(4) NOT NULL DEFAULT '1',
  `rounds_total` tinyint(4) NOT NULL DEFAULT '4',
  `email_address` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `tournament_started` tinyint(4) NOT NULL DEFAULT '0',
  `reminder_by_mail` tinyint(4) NOT NULL DEFAULT '0',
  `reminder_mail_sent` tinyint(4) NOT NULL DEFAULT '0',
  `move_piece` tinyint(4) DEFAULT '0',
  `move_number_current` tinyint(4) NOT NULL,
  `time_remaining_player1` varchar(5) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '600',
  `time_remaining_player2` varchar(5) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '600',
  `game_over` tinyint(4) NOT NULL DEFAULT '1',
  `won_game` tinyint(4) NOT NULL DEFAULT '0',
  `timestamp` varchar(12) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `tournament_data`
--

CREATE TABLE `tournament_data` (
  `id` int(11) NOT NULL,
  `piece_move_time_limit` tinyint(4) NOT NULL DEFAULT '24',
  `players` tinyint(4) NOT NULL DEFAULT '2',
  `games_rated` tinyint(4) NOT NULL DEFAULT '1' COMMENT '0:no. 1:yes',
  `maximum_elo` tinyint(4) NOT NULL DEFAULT '1' COMMENT '1:beginner. 2:intermediate. 3:advanced',
  `points_available` smallint(6) NOT NULL DEFAULT '100',
  `round_current` tinyint(4) NOT NULL DEFAULT '0',
  `rounds_total` tinyint(4) NOT NULL DEFAULT '1',
  `games_simultaneous` smallint(6) NOT NULL DEFAULT '0',
  `games_completed` smallint(6) NOT NULL DEFAULT '0',
  `tie_break` tinyint(4) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='this table holds all data for every tournament type such as chess_tourny_normal or pyramid';

--
-- Dumping data for table `tournament_data`
--

INSERT INTO `tournament_data` (`id`, `piece_move_time_limit`, `players`, `games_rated`, `maximum_elo`, `points_available`, `round_current`, `rounds_total`, `games_simultaneous`, `games_completed`, `tie_break`) VALUES
(1, 24, 8, 1, 1, 100, 1, 4, 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `tournament_winners`
--

CREATE TABLE `tournament_winners` (
  `id` bigint(20) NOT NULL,
  `name` varchar(100) COLLATE utf8_bin NOT NULL,
  `player1` varchar(12) COLLATE utf8_bin NOT NULL,
  `player2` varchar(12) COLLATE utf8_bin NOT NULL,
  `player3` varchar(12) COLLATE utf8_bin NOT NULL,
  `player4` varchar(12) COLLATE utf8_bin NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Dumping data for table `tournament_winners`
--

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) NOT NULL,
  `user` varchar(12) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `password_hash` text CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `email_address` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `ip` varchar(15) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `hostname` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `timestamp` int(15) NOT NULL,
  `is_kicked` tinyint(1) NOT NULL DEFAULT '0',
  `is_banned` tinyint(1) NOT NULL DEFAULT '0',
  `server_domain` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `is_paid_member` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `user_actions`
--

CREATE TABLE `user_actions` (
  `id` int(11) NOT NULL,
  `user` varchar(12) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `action_who` varchar(12) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `action_number` smallint(2) NOT NULL DEFAULT '0',
  `timestamp` bigint(15) NOT NULL,
  `minutes_total` smallint(2) NOT NULL DEFAULT '15'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `who_is_host`
--

CREATE TABLE `who_is_host` (
  `id` int(11) NOT NULL,
  `user` varchar(12) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `gid` varchar(20) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `room` int(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `banned`
--
ALTER TABLE `banned`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user` (`user`);

--
-- Indexes for table `daily_quests`
--
ALTER TABLE `daily_quests`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user` (`user`);

--
-- Indexes for table `events`
--
ALTER TABLE `events`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `house`
--
ALTER TABLE `house`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user` (`user`) USING BTREE;

--
-- Indexes for table `kicked`
--
ALTER TABLE `kicked`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user` (`user`);

--
-- Indexes for table `logged_in_hostname`
--
ALTER TABLE `logged_in_hostname`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `host` (`hostname`);

--
-- Indexes for table `logged_in_users`
--
ALTER TABLE `logged_in_users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user` (`user`);

--
-- Indexes for table `move_history`
--
ALTER TABLE `move_history`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `room_data`
--
ALTER TABLE `room_data`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user` (`user`);

--
-- Indexes for table `room_lock`
--
ALTER TABLE `room_lock`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `servers_status`
--
ALTER TABLE `servers_status`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `statistics`
--
ALTER TABLE `statistics`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user` (`user`);

--
-- Indexes for table `tournament_chess_standard_8`
--
ALTER TABLE `tournament_chess_standard_8`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tournament_data`
--
ALTER TABLE `tournament_data`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tournament_winners`
--
ALTER TABLE `tournament_winners`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user` (`user`);

--
-- Indexes for table `user_actions`
--
ALTER TABLE `user_actions`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `who_is_host`
--
ALTER TABLE `who_is_host`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `banned`
--
ALTER TABLE `banned`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `daily_quests`
--
ALTER TABLE `daily_quests`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=163;

--
-- AUTO_INCREMENT for table `events`
--
ALTER TABLE `events`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=56;

--
-- AUTO_INCREMENT for table `house`
--
ALTER TABLE `house`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3673;

--
-- AUTO_INCREMENT for table `kicked`
--
ALTER TABLE `kicked`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `logged_in_hostname`
--
ALTER TABLE `logged_in_hostname`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `logged_in_users`
--
ALTER TABLE `logged_in_users`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `move_history`
--
ALTER TABLE `move_history`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=503;

--
-- AUTO_INCREMENT for table `room_data`
--
ALTER TABLE `room_data`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `room_lock`
--
ALTER TABLE `room_lock`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `statistics`
--
ALTER TABLE `statistics`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2095;

--
-- AUTO_INCREMENT for table `tournament_chess_standard_8`
--
ALTER TABLE `tournament_chess_standard_8`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `tournament_data`
--
ALTER TABLE `tournament_data`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `tournament_winners`
--
ALTER TABLE `tournament_winners`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1652;

--
-- AUTO_INCREMENT for table `user_actions`
--
ALTER TABLE `user_actions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `who_is_host`
--
ALTER TABLE `who_is_host`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
