SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";

INSERT INTO `statistics` (`id`, `user`, `is_bot`, `ip`, `user_avatar`, `timestamp`, `is_kicked`, `is_banned`, `world_flag`, `experience_points`, `event_month`, `event_day`, `chess_elo_rating`, `credits_today`, `credits_total`, `house_coins`, `tournament_points`, `total_games_played`, `shortest_time_game_played`, `longest_time_game_played`, `longest_current_winning_streak`, `highest_winning_streak`, `longest_current_losing_streak`, `highest_losing_streak`, `longest_current_draw_streak`, `highest_draw_streak`, `games_all_total_wins`, `games_all_total_losses`, `games_all_total_draws`, `checkers_wins`, `checkers_losses`, `checkers_draws`, `chess_wins`, `chess_losses`, `chess_draws`, `reversi_wins`, `reversi_losses`, `reversi_draws`, `snakes_and_ladders_wins`, `snakes_and_ladders_losses`, `snakes_and_ladders_draws`, `signature_game_wins`, `signature_game_losses`, `signature_game_draws`) VALUES
(null, 'Jeti', 0, '', '24.png', 0, 0, 0, 0, 140, 0, 0, 0, 0, 0, 53, 0, 4, 66, 244, 2, 2, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(null, 'rastarx', 0, '', '35.png', 0, 0, 0, 0, 70, 0, 0, 0, 0, 0, 122, 0, 4, 66, 244, 0, 0, 2, 2, 0, 0, 0, 2, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(null, 'teacup', 0, '', '203.png', 0, 0, 0, 0, 165, 0, 0, 0, 0, 0, 110, 0, 4, 123, 343, 2, 2, 0, 0, 0, 0, 3, 1, 0, 1, 0, 0, 2, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0),
(null, 'EstaXen', 0, '', '59.png', 0, 0, 0, 0, 50, 0, 0, 0, 0, 0, 132, 0, 5, 123, 417, 1, 1, 2, 2, 1, 1, 1, 3, 1, 0, 1, 0, 0, 2, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1),
(null, 'qentroz', 0, '', '287.png', 0, 0, 0, 0, 540, 0, 0, 0, 0, 0, 146, 0, 12, 210, 410, 2, 2, 1, 1, 0, 0, 7, 4, 0, 0, 0, 0, 3, 2, 0, 2, 1, 0, 0, 0, 0, 2, 1, 1),
(null, 'EloBender', 0, '', '249.png', 0, 0, 0, 0, 480, 0, 0, 0, 0, 0, 103, 0, 13, 197, 417, 1, 1, 2, 2, 1, 1, 4, 7, 1, 0, 0, 0, 2, 3, 0, 1, 2, 0, 0, 0, 0, 1, 1, 2),
(null, 'GameGeek', 0, '', '26.png', 0, 0, 0, 0, 50, 0, 0, 0, 0, 0, 102, 0, 1, 652, 652, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0),
(null, 'Udela', 0, '', '108.png', 0, 0, 0, 0, 25, 0, 0, 0, 0, 0, 101, 0, 1, 652, 652, 0, 0, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0),
(null, 'dogbone', 0, '', '294.png', 0, 0, 0, 0, 75, 0, 0, 0, 0, 0, 102, 0, 0, 725, 725, 1, 1, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(null, 'InError', 0, '', '15.png', 0, 0, 0, 0, 37.5, 0, 0, 0, 0, 0, 101, 0, 0, 725, 725, 0, 0, 1, 1, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(null, 'MingmeiCheng', 0, '', '68.png', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(null, 'laceyAnt', 0, '', '156.png', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(null, 'stillwater', 0, '', '84.png', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(null, 'ponyride', 0, '', '63.png', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(null, 'sam', 0, '', '116.png', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(null, 'drumspirit', 0, '', '198.png', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(null, 'blueberry', 0, '', '169.png', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(null, 'margaret', 0, '', '42.png', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(null, 'noob', 0, '', '111.png', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
COMMIT;