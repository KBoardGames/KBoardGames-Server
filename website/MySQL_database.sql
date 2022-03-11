-- phpMyAdmin SQL Dump
-- version 4.8.3
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Feb 21, 2022 at 11:21 PM
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
-- Table structure for table `client_messages`
--

CREATE TABLE `client_messages` (
  `online` varchar(2000) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT 'The admin cancelled the server from going offline.',
  `offline` varchar(2000) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT 'This server will shutdown after 30 minutes expire because of server and/or client maintenance.'
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
(55, 'House Coins', 'House is a side game where you can make isometric rooms by purchasing furniture and then placing that furniture anywhere in the house. You start with an empty room by placing floor tiles on the floor. You can add walls, doors and windows. The room is large. You are able to scroll the scene by hovering the mouse cursor from near the edge of the scene to the edge of the scene.\r\nYou can arrange the furniture anyway you like. You can place a furniture item behind a wall or place it in front of a wall. You can stack a furniture item on top of another furniture item or underneath it.\r\nYou can only receive a house coin when this event is active. Use house coins to purchase furniture. You will be given 1 house coin when you lose a board game and 2 house coins when you win a board game.', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 5),
(56, 'Motivation', 'Everyone is encouraged to play board games online on the day of this event. If the lobby is without players then create a room and wait for someone to join. You do not need to stay near the computer. You will be paged when someone enters the waiting room. A buzzer sound will continue every 1 second until you either press a key on the keyboard or press any mouse button. The pager feature can be toggled on/off at the configuration scene.', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `front_door_queue`
--

CREATE TABLE `front_door_queue` (
  `id` bigint(20) NOT NULL,
  `user` varchar(12) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `ping` int(15) NOT NULL,
  `timestamp` bigint(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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
  `user` varchar(12) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `hostname` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `timestamp` int(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `logged_in_users`
--

CREATE TABLE `logged_in_users` (
  `id` bigint(20) NOT NULL,
  `user` varchar(12) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `ip` varchar(16) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `hostname` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
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
  `game_id` smallint(3) NOT NULL DEFAULT '1',
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
  `connected` tinyint(1) NOT NULL DEFAULT '0',
  `disconnect` tinyint(1) NOT NULL DEFAULT '0',
  `timestamp` int(11) NOT NULL DEFAULT '0',
  `do_once` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Dumping data for table `servers_status`
--

INSERT INTO `servers_status` (`id`, `connected`, `disconnect`, `timestamp`, `do_once`) VALUES
(1, 0, 0, 0, 0),
(2, 0, 0, 0, 0),
(3, 0, 0, 0, 0),
(4, 0, 0, 0, 0),
(5, 0, 0, 0, 0),
(6, 0, 0, 0, 0),
(7, 0, 0, 0, 0),
(8, 0, 0, 0, 0),
(9, 0, 0, 0, 0),
(10, 0, 0, 0, 0),
(11, 0, 0, 0, 0),
(12, 0, 0, 0, 0),
(13, 0, 0, 0, 0),
(14, 0, 0, 0, 0),
(15, 0, 0, 0, 0),
(16, 0, 0, 0, 0),
(17, 0, 0, 0, 0),
(18, 0, 0, 0, 0),
(19, 0, 0, 0, 0),
(20, 0, 0, 0, 0),
(21, 0, 0, 0, 0),
(22, 0, 0, 0, 0),
(23, 0, 0, 0, 0),
(24, 0, 0, 0, 0),
(25, 0, 0, 0, 0),
(26, 0, 0, 0, 0),
(27, 0, 0, 0, 0),
(28, 0, 0, 0, 0),
(29, 0, 0, 0, 0),
(30, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `statistics`
--

CREATE TABLE `statistics` (
  `id` bigint(20) NOT NULL,
  `user` varchar(12) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `is_bot` tinyint(1) NOT NULL DEFAULT '0',
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
  `shortest_time_game_played` int(11) NOT NULL DEFAULT '0',
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
  `uid` varchar(20) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
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

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) NOT NULL,
  `user` varchar(12) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `password_hash` varchar(200) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `email_address` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `email_address_needing_validation` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `email_address_validation_code` varchar(33) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
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
  `timestamp` int(11) NOT NULL,
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
-- Indexes for table `front_door_queue`
--
ALTER TABLE `front_door_queue`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user` (`user`);

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
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=192;

--
-- AUTO_INCREMENT for table `events`
--
ALTER TABLE `events`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=57;

--
-- AUTO_INCREMENT for table `front_door_queue`
--
ALTER TABLE `front_door_queue`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=60;

--
-- AUTO_INCREMENT for table `house`
--
ALTER TABLE `house`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4246;

--
-- AUTO_INCREMENT for table `kicked`
--
ALTER TABLE `kicked`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `logged_in_hostname`
--
ALTER TABLE `logged_in_hostname`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=53;

--
-- AUTO_INCREMENT for table `logged_in_users`
--
ALTER TABLE `logged_in_users`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=45;

--
-- AUTO_INCREMENT for table `move_history`
--
ALTER TABLE `move_history`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=562;

--
-- AUTO_INCREMENT for table `room_data`
--
ALTER TABLE `room_data`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=45;

--
-- AUTO_INCREMENT for table `room_lock`
--
ALTER TABLE `room_lock`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

--
-- AUTO_INCREMENT for table `statistics`
--
ALTER TABLE `statistics`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2828;

--
-- AUTO_INCREMENT for table `tournament_chess_standard_8`
--
ALTER TABLE `tournament_chess_standard_8`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

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
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1530;

--
-- AUTO_INCREMENT for table `user_actions`
--
ALTER TABLE `user_actions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `who_is_host`
--
ALTER TABLE `who_is_host`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
