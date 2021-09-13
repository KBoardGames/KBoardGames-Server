/*
    Copyright (c) 2021 KBoardGames.com
    This program is part of KBoardGames server software.

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published
    by the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

<?php

class MysqlDB
{ 
	public function insertKickedUser($dbh, $user, $message, $minutes_total, $timestamp)
	{		
		try {						
			$stmt = $dbh->prepare("INSERT IGNORE INTO kicked (user, message, timestamp, minutes_total) VALUES(:user, :message, :timestamp, :minutes_total)" . "ON DUPLICATE KEY UPDATE user=VALUES(user), message=VALUES(message), timestamp=VALUES(timestamp), minutes_total=VALUES(minutes_total)");
			$stmt->bindParam(':user', $user);
			$stmt->bindParam(':message', $message);
			$stmt->bindParam(':timestamp', $timestamp);
			$stmt->bindParam(':minutes_total', $minutes_total);
			$stmt->execute();
			
			return $stmt;
		} catch (PDOException $e) {
			echo $e->getMessage().' in '.$e->getFile().' on line '.$e->getLine();
			exit;
		}		
	}
	 
	public function insertBannedUser($dbh, $user, $message, $ip)
	{		
		try {
			$stmt = $dbh->prepare("INSERT IGNORE INTO banned (user, message, ip) VALUES(:user, :message, :ip)" . "ON DUPLICATE KEY UPDATE user=VALUES(user), message=VALUES(message), ip=VALUES(ip)");
			$stmt->bindParam(':user', $user);
			$stmt->bindParam(':message', $message);
			$stmt->bindParam(':ip', $ip);
			$stmt->execute();
			
			return $stmt;
		} catch (PDOException $e) {
			echo $e->getMessage().' in '.$e->getFile().' on line '.$e->getLine();
			exit;
		}		
	}
	
	public function mostRecentUsers($dbh)
	{			
		try {
			$stmt = $dbh->prepare("SELECT * FROM users");
			$stmt->execute();
			
			return $stmt;
		} catch (PDOException $e) {
			echo $e->getMessage().' in '.$e->getFile().' on line '.$e->getLine();
			exit;
		}
	}
	
	public function mostRecentKickedUsers($dbh)
	{			
		try {
			$stmt = $dbh->prepare("SELECT * FROM kicked");
			$stmt->execute();
			
			return $stmt;
		} catch (PDOException $e) {
			echo $e->getMessage().' in '.$e->getFile().' on line '.$e->getLine();
			exit;
		}
	}
	
	public function mostRecentBannedUsers($dbh)
	{			
		try {
			$stmt = $dbh->prepare("SELECT * FROM banned");
			$stmt->execute();
			
			return $stmt;
		} catch (PDOException $e) {
			echo $e->getMessage().' in '.$e->getFile().' on line '.$e->getLine();
			exit;
		}
	}
	
	public function selectKickedUser($dbh, $user)
	{			
		try {
			$stmt = $dbh->prepare("SELECT * FROM kicked WHERE user=:user");
			$stmt->bindParam(':user', $user);
			$stmt->execute();
			
			return $stmt;
		} catch (PDOException $e) {
			echo $e->getMessage().' in '.$e->getFile().' on line '.$e->getLine();
			exit;
		}
	}

	public function selectTopPlayer($dbh)
	{			
		try {
			$stmt = $dbh->prepare("SELECT * FROM statistics ORDER BY experience_points DESC LIMIT 1");
			$stmt->execute();
			
			return $stmt;
		} catch (PDOException $e) {
			echo $e->getMessage().' in '.$e->getFile().' on line '.$e->getLine();
			exit;
		}
	}

	
	public function selectUserAvatar($dbh, $username)
	{			
		try {
			$stmt = $dbh->prepare("SELECT * FROM xyz_users WHERE username=:username");
			$stmt->bindParam(':username', $username);
			$stmt->execute();
			
			return $stmt;
		} catch (PDOException $e) {
			echo $e->getMessage().' in '.$e->getFile().' on line '.$e->getLine();
			exit;
		}
	}


	public function selectBannedUser($dbh, $user)
	{			
		try {
			$stmt = $dbh->prepare("SELECT * FROM banned WHERE user=:user");
			$stmt->bindParam(':user', $user);
			$stmt->execute();
			
			return $stmt;
		} catch (PDOException $e) {
			echo $e->getMessage().' in '.$e->getFile().' on line '.$e->getLine();
			exit;
		}
	}


	public function selectServerDomain($dbh, $serverDomain)
	{			
		try {
			$stmt = $dbh->prepare("SELECT * FROM users WHERE server_domain=:server_domain");
			$stmt->bindParam(':server_domain', $serverDomain);
			$stmt->execute();
			
			return $stmt;
		} catch (PDOException $e) {
			echo $e->getMessage().' in '.$e->getFile().' on line '.$e->getLine();
			exit;
		}
	}

		
	public function get10MostWins($dbh)
	{
		try {
			$stmt = $dbh->prepare("SELECT * FROM statistics ORDER BY games_all_total_wins DESC LIMIT 10");
			$stmt->execute();

			return $stmt;
		} catch (PDOException $e) {
			echo $e->getMessage().' in '.$e->getFile().' on line '.$e->getLine();
			exit;
		}
	}
	
	public function get10MostLosses($dbh)
	{
		try {
			$stmt = $dbh->prepare("SELECT * FROM statistics ORDER BY games_all_total_losses DESC LIMIT 10");
			$stmt->execute();

			return $stmt;
		} catch (PDOException $e) {
			echo $e->getMessage().' in '.$e->getFile().' on line '.$e->getLine();
			exit;
		}
	}
	
	public function get10MostDraws($dbh)
	{
		try {
			$stmt = $dbh->prepare("SELECT * FROM statistics ORDER BY games_all_total_draws DESC LIMIT 10");
			$stmt->execute();

			return $stmt;
		} catch (PDOException $e) {
			echo $e->getMessage().' in '.$e->getFile().' on line '.$e->getLine();
			exit;
		}
	}
	
	
	public function get10CheckersWins($dbh)
	{
		try {
			$stmt = $dbh->prepare("SELECT * FROM statistics ORDER BY checkers_wins DESC LIMIT 10");
			$stmt->execute();

			return $stmt;
		} catch (PDOException $e) {
			echo $e->getMessage().' in '.$e->getFile().' on line '.$e->getLine();
			exit;
		}
	}
	
	
	public function get10ChessWins($dbh)
	{
		try {
			$stmt = $dbh->prepare("SELECT * FROM statistics ORDER BY chess_wins DESC LIMIT 10");
			$stmt->execute();

			return $stmt;
		} catch (PDOException $e) {
			echo $e->getMessage().' in '.$e->getFile().' on line '.$e->getLine();
			exit;
		}
	}
	
	
	public function get10ReversiWins($dbh)
	{
		try {
			$stmt = $dbh->prepare("SELECT * FROM statistics ORDER BY reversi_wins DESC LIMIT 10");
			$stmt->execute();

			return $stmt;
		} catch (PDOException $e) {
			echo $e->getMessage().' in '.$e->getFile().' on line '.$e->getLine();
			exit;
		}
	}
	
	
	public function get10SnakesAndLaddersWins($dbh)
	{
		try {
			$stmt = $dbh->prepare("SELECT * FROM statistics ORDER BY snakes_and_ladders_wins DESC LIMIT 10");
			$stmt->execute();

			return $stmt;
		} catch (PDOException $e) {
			echo $e->getMessage().' in '.$e->getFile().' on line '.$e->getLine();
			exit;
		}
	}
	
	
	public function get10SignatureGameWins($dbh)
	{
		try {
			$stmt = $dbh->prepare("SELECT * FROM statistics ORDER BY signature_game_wins DESC LIMIT 10");
			$stmt->execute();

			return $stmt;
		} catch (PDOException $e) {
			echo $e->getMessage().' in '.$e->getFile().' on line '.$e->getLine();
			exit;
		}
	}


	public function get10TotalGamesPlayed($dbh)
	{
		try {
			$stmt = $dbh->prepare("SELECT * FROM statistics ORDER BY total_games_played DESC LIMIT 10");
			$stmt->execute();

			return $stmt;
		} catch (PDOException $e) {
			echo $e->getMessage().' in '.$e->getFile().' on line '.$e->getLine();
			exit;
		}
	}
	
	public function get10HighestExperiencePoints($dbh)
	{
		try {
			$stmt = $dbh->prepare("SELECT * FROM statistics ORDER BY experience_points DESC LIMIT 10");
			$stmt->execute();

			return $stmt;
		} catch (PDOException $e) {
			echo $e->getMessage().' in '.$e->getFile().' on line '.$e->getLine();
			exit;
		}
	}


	public function get10HighestCredits($dbh)
	{
		try {
			$stmt = $dbh->prepare("SELECT * FROM statistics ORDER BY credits_total DESC LIMIT 10");
			$stmt->execute();

			return $stmt;
		} catch (PDOException $e) {
			echo $e->getMessage().' in '.$e->getFile().' on line '.$e->getLine();
			exit;
		}
	}

	public function get10HighestHouseCoins($dbh)
	{
		try {
			$stmt = $dbh->prepare("SELECT * FROM statistics ORDER BY house_coins DESC LIMIT 10");
			$stmt->execute();

			return $stmt;
		} catch (PDOException $e) {
			echo $e->getMessage().' in '.$e->getFile().' on line '.$e->getLine();
			exit;
		}
	}

	public function get10ShortestTimeGamePlayed($dbh)
	{
		try {
			$stmt = $dbh->prepare("SELECT * FROM statistics ORDER BY shortest_time_game_played ASC LIMIT 10");
			$stmt->execute();

			return $stmt;
		} catch (PDOException $e) {
			echo $e->getMessage().' in '.$e->getFile().' on line '.$e->getLine();
			exit;
		}
	}

	public function get10LongestTimeGamePlayed($dbh)
	{
		try {
			$stmt = $dbh->prepare("SELECT * FROM statistics ORDER BY longest_time_game_played DESC LIMIT 10");
			$stmt->execute();

			return $stmt;
		} catch (PDOException $e) {
			echo $e->getMessage().' in '.$e->getFile().' on line '.$e->getLine();
			exit;
		}
	}

	public function get10LongestCurrentWinningStreak($dbh)
	{
		try {
			$stmt = $dbh->prepare("SELECT * FROM statistics ORDER BY longest_current_winning_streak DESC LIMIT 10");
			$stmt->execute();

			return $stmt;
		} catch (PDOException $e) {
			echo $e->getMessage().' in '.$e->getFile().' on line '.$e->getLine();
			exit;
		}
	}

	public function get10LongestCurrentLosingStreak($dbh)
	{
		try {
			$stmt = $dbh->prepare("SELECT * FROM statistics ORDER BY longest_current_losing_streak DESC LIMIT 10");
			$stmt->execute();

			return $stmt;
		} catch (PDOException $e) {
			echo $e->getMessage().' in '.$e->getFile().' on line '.$e->getLine();
			exit;
		}
	}

	public function get10LongestCurrentDrawStreak($dbh)
	{
		try {
			$stmt = $dbh->prepare("SELECT * FROM statistics ORDER BY longest_current_draw_streak DESC LIMIT 10");
			$stmt->execute();

			return $stmt;
		} catch (PDOException $e) {
			echo $e->getMessage().' in '.$e->getFile().' on line '.$e->getLine();
			exit;
		}
	}

	public function getStatisticsELO($dbh, $user)
	{
		try {
			$stmt = $dbh->prepare("SELECT * FROM statistics WHERE user=:user");
			$stmt->bindParam(':user', $user);
			$stmt->execute();

			return $stmt;
		} catch (PDOException $e) {
			echo $e->getMessage().' in '.$e->getFile().' on line '.$e->getLine();
			exit;
		}
	}

	public function getUsersAvatar($dbh, $username)
	{
		try {
			$stmt = $dbh->prepare("SELECT user_avatar FROM xyz_users WHERE username=:username");
			$stmt->bindParam(':username', $username);
			$stmt->execute();

			return $stmt;
		} catch (PDOException $e) {
			echo $e->getMessage().' in '.$e->getFile().' on line '.$e->getLine();
			exit;
		}
	}


	public function getUser($dbh, $user)
	{			
		try {
			$stmt = $dbh->prepare("SELECT * FROM users WHERE user=:user");
			$stmt->bindParam(':user', $user);
			$stmt->execute();
			
			return $stmt;
		} catch (PDOException $e) {
			echo $e->getMessage().' in '.$e->getFile().' on line '.$e->getLine();
			exit;
		}
	}

	public function getServersOnline($dbh)
	{			
		try {
			$stmt = $dbh->prepare("SELECT * FROM servers_status");
			$stmt->execute();
			
			return $stmt;
		} catch (PDOException $e) {
			echo $e->getMessage().' in '.$e->getFile().' on line '.$e->getLine();
			exit;
		}
	}

	public function getClientsOnline($dbh)
	{			
		try {
			$stmt = $dbh->prepare("SELECT COUNT(user) FROM room_data");
			$stmt->execute();
			
			return $stmt;
		} catch (PDOException $e) {
			echo $e->getMessage().' in '.$e->getFile().' on line '.$e->getLine();
			exit;
		}
	}

	public function removeKickedUser($dbh, $user)
	{			
		try {
			$stmt = $dbh->prepare("DELETE FROM kicked WHERE user=:user");
			$stmt->bindParam(':user', $user);
			$stmt->execute();
			
			return $stmt;
		} catch (PDOException $e) {
			echo $e->getMessage().' in '.$e->getFile().' on line '.$e->getLine();
			exit;
		}
	}
	
	public function removeBannedUser($dbh, $user)
	{			
		try {
			$stmt = $dbh->prepare("DELETE FROM banned WHERE user=:user");
			$stmt->bindParam(':user', $user);
			$stmt->execute();
			
			return $stmt;
		} catch (PDOException $e) {
			echo $e->getMessage().' in '.$e->getFile().' on line '.$e->getLine();
			exit;
		}
	}
	
	public function selectMaintenanceMode($dbh)
	{
		try {
			$stmt = $dbh->prepare("SELECT * FROM servers_status");
			$stmt->execute();

			return $stmt;
		} catch (PDOException $e) {
			echo $e->getMessage().' in '.$e->getFile().' on line '.$e->getLine();
			exit;
		}
	}
	
	public function eventDelete($dbh, $listCheck)
	{
		try {
			$stmt = $dbh->prepare("DELETE FROM events WHERE `name` IN ($listCheck)");
			$stmt->execute();
		} catch (PDOException $e) {
			echo $e->getMessage().' in '.$e->getFile().' on line '.$e->getLine();
			exit;
		}
	}
	
	public function selectEvent($dbh, $name)
	{
		try {
			$stmt = $dbh->prepare("SELECT * FROM events WHERE name=:name");
			$stmt->bindParam(':name', $name);
			$stmt->execute();

			return $stmt;
		} catch (PDOException $e) {
			echo $e->getMessage().' in '.$e->getFile().' on line '.$e->getLine();
			exit;
		}
	}
	
	public function getAllEvents($dbh)
	{			
		try {
			$stmt = $dbh->prepare("SELECT * FROM events");
			$stmt->execute();
			
			return $stmt;
		} catch (PDOException $e) {
			echo $e->getMessage().' in '.$e->getFile().' on line '.$e->getLine();
			exit;
		}
	}
	
	public function getTournamentData($id, $dbh)
	{			
		try {
			$stmt = $dbh->prepare("SELECT * FROM tournament_data WHERE id=:id");
			$stmt->bindParam(':id', $id);
			$stmt->execute();
			
			return $stmt;
		} catch (PDOException $e) {
			echo $e->getMessage().' in '.$e->getFile().' on line '.$e->getLine();
			exit;
		}
	}

	public function getTournament8ChessStandardWinners($dbh)
	{			
		try {
			$stmt = $dbh->prepare("SELECT * FROM tournament_chess_standard_8 ORDER BY players ASC LIMIT 4");
			$stmt->execute();
			
			return $stmt;
		} catch (PDOException $e) {
			echo $e->getMessage().' in '.$e->getFile().' on line '.$e->getLine();
			exit;
		}
	}

	public function getTournament8ChessStandardWinnersAll($dbh)
	{			
		try {
			$stmt = $dbh->prepare("SELECT * FROM tournament_winners");
			$stmt->execute();
			
			return $stmt;
		} catch (PDOException $e) {
			echo $e->getMessage().' in '.$e->getFile().' on line '.$e->getLine();
			exit;
		}
	}
  
	public function updateTournament8ChessStandardWinners($dbh, $name, $player1, $player2, $player3, $player4)
	{			
		try {
			$stmt = $dbh->prepare("INSERT IGNORE INTO tournament_winners (name, player1, player2, player3, player4) VALUES(:name, :player1, :player2, :player3, :player4)");
			$stmt->bindParam(':name', $name);
			$stmt->bindParam(':player1', $player1);
			$stmt->bindParam(':player2', $player2);
			$stmt->bindParam(':player3', $player3);
			$stmt->bindParam(':player4', $player4);
			$stmt->execute();
			
			return $stmt;
		} catch (PDOException $e) {
			echo $e->getMessage().' in '.$e->getFile().' on line '.$e->getLine();
			exit;
		}
	}

public function updateTournament8ChessStandardPoints($dbh, $user, $tournament_points)
	{
		try {
			$stmt = $dbh->prepare("UPDATE statistics SET tournament_points=tournament_points+:tournament_points WHERE user=:user");
			$stmt->bindParam(':user', $user);
			$stmt->bindParam(':tournament_points', $tournament_points);
			$stmt->execute();
			
			return $stmt;
		} catch (PDOException $e) {
			echo $e->getMessage().' in '.$e->getFile().' on line '.$e->getLine();
			exit;
		}
	}

	public function getTournament8GamesRemainingInRound($dbh, $move_piece)
	{			
		try {
			$stmt = $dbh->prepare("SELECT COUNT(*) FROM tournament_chess_standard_8 WHERE move_piece=:move_piece");
			$stmt->bindParam(':move_piece', $move_piece);
			$stmt->execute();
			$eventCount = $stmt->fetchColumn();
			return $eventCount;
		} catch (PDOException $e) {
			echo $e->getMessage().' in '.$e->getFile().' on line '.$e->getLine();
			exit;
		}
	}

	public function getTournament8ChessGamesWon($dbh, $won_game)
	{			
		try {
			$stmt = $dbh->prepare("SELECT * FROM tournament_chess_standard_8 WHERE won_game=:won_game");
			$stmt->bindParam(':won_game', $won_game);
			$stmt->execute();
			return $stmt;
		} catch (PDOException $e) {
			echo $e->getMessage().' in '.$e->getFile().' on line '.$e->getLine();
			exit;
		}
	}

	public function getTournament8GamesPlayersTotalInRound($dbh)
	{			
		try {
			$stmt = $dbh->prepare("SELECT * FROM tournament_chess_standard_8");
			$stmt->execute();
			return $stmt;
		} catch (PDOException $e) {
			echo $e->getMessage().' in '.$e->getFile().' on line '.$e->getLine();
			exit;
		}
	}

	public function getTournament8Started($dbh, $tournament_started)
	{			
		try {
			$stmt = $dbh->prepare("SELECT COUNT(*) FROM tournament_chess_standard_8 WHERE tournament_started=:tournament_started");
			$stmt->bindParam(':tournament_started', $tournament_started);
			$stmt->execute();
			$eventCount = $stmt->fetchColumn();
			return $eventCount;
		} catch (PDOException $e) {
			echo $e->getMessage().' in '.$e->getFile().' on line '.$e->getLine();
			exit;
		}
	}

	public function getTournament8ChessStandard($player1, $dbh)
	{			
		try {
			$stmt = $dbh->prepare("SELECT * FROM tournament_chess_standard_8 WHERE player1=:player1");
			$stmt->bindParam(':player1', $player1);
			$stmt->execute();
			
			return $stmt;
		} catch (PDOException $e) {
			echo $e->getMessage().' in '.$e->getFile().' on line '.$e->getLine();
			exit;
		}
	}

	public function getTournament8ChessStandardUid($dbh, $uid)
	{			
		try {
			$stmt = $dbh->prepare("SELECT * FROM tournament_chess_standard_8 WHERE uid=:uid");
			$stmt->bindParam(':uid', $uid);
			$stmt->execute();
			
			return $stmt;
		} catch (PDOException $e) {
			echo $e->getMessage().' in '.$e->getFile().' on line '.$e->getLine();
			exit;
		}
	}

	public function getTournament8ChessStandardAll($dbh)
	{			
		try {
			$stmt = $dbh->prepare("SELECT * FROM tournament_chess_standard_8");
			$stmt->execute();			
			return $stmt;
		} catch (PDOException $e) {
			echo $e->getMessage().' in '.$e->getFile().' on line '.$e->getLine();
			exit;
		}
	}

	public function insertTournament8ChessStandard($dbh, $player1, $reminder_by_mail, $user_email, $uid)
	{		
		try {
			$stmt = $dbh->prepare("INSERT IGNORE INTO tournament_chess_standard_8 (player1, reminder_by_mail, user_email, uid) VALUES(:player1, :reminder_by_mail, :user_email, :uid)");
			$stmt->bindParam(':player1', $player1);
			$stmt->bindParam(':reminder_by_mail', $reminder_by_mail);
			$stmt->bindParam(':user_email', $user_email);
			$stmt->bindParam(':uid', $uid);
			$stmt->execute();
			
			return $stmt;
		} catch (PDOException $e) {
			echo $e->getMessage().' in '.$e->getFile().' on line '.$e->getLine();
			exit;
		}		
	}

	public function updateTournament8ChessStandardMail($dbh, $player1, $reminder_by_mail)
	{
		try {
			$stmt = $dbh->prepare("UPDATE tournament_chess_standard_8 SET reminder_by_mail=:reminder_by_mail WHERE player1=:player1");
			$stmt->bindParam(':player1', $player1);
			$stmt->bindParam(':reminder_by_mail', $reminder_by_mail);
			$stmt->execute();
		} catch (PDOException $e) {
			echo $e->getMessage().' in '.$e->getFile().' on line '.$e->getLine();
			exit;
		}
	}

	public function updateTournament8ChessStandardStart($dbh, $tournament_started)
	{
		try {
			$stmt = $dbh->prepare("UPDATE tournament_chess_standard_8 SET tournament_started=:tournament_started");
			$stmt->bindParam(':tournament_started', $tournament_started);
			$stmt->execute();
		} catch (PDOException $e) {
			echo $e->getMessage().' in '.$e->getFile().' on line '.$e->getLine();
			exit;
		}
	}

	public function updateTournament8ChessStandardPlayer2($dbh, $player1, $player2, $gid, $move_piece, $move_number_current, $round_current, $timestamp, $game_over, $won_game)
	{
		try {
			$stmt = $dbh->prepare("UPDATE tournament_chess_standard_8 SET player2=:player2, gid=:gid, move_piece=:move_piece, move_number_current=:move_number_current, round_current=:round_current, timestamp=:timestamp, game_over=:game_over, won_game=:won_game WHERE player1=:player1");
			$stmt->bindParam(':player1', $player1);
			$stmt->bindParam(':player2', $player2);
			$stmt->bindParam(':gid', $gid);
			$stmt->bindParam(':move_piece', $move_piece);
			$stmt->bindParam(':move_number_current', $move_number_current);
			$stmt->bindParam(':round_current', $round_current);
			$stmt->bindParam(':timestamp', $timestamp);
			$stmt->bindParam(':game_over', $game_over);
			$stmt->bindParam(':won_game', $won_game);
			$stmt->execute();
		} catch (PDOException $e) {
			echo $e->getMessage().' in '.$e->getFile().' on line '.$e->getLine();
			exit;
		}

		// tournament data table.
		try {
			$stmt = $dbh->prepare("UPDATE tournament_data SET round_current=:round_current WHERE id=1");
			$stmt->bindParam(':round_current', $round_current);
			$stmt->execute();
		} catch (PDOException $e) {
			echo $e->getMessage().' in '.$e->getFile().' on line '.$e->getLine();
			exit;
		}
	}

	// tournament data table.
	public function updateTournament8ChessStandardCurrentRound($dbh, $round_current, $move_piece)
	{
		try {
			$stmt = $dbh->prepare("UPDATE tournament_chess_standard_8 SET round_current=:round_current, move_piece=:move_piece");
			$stmt->bindParam(':round_current', $round_current);
			$stmt->bindParam(':move_piece', $move_piece);
			$stmt->execute();
		} catch (PDOException $e) {
			echo $e->getMessage().' in '.$e->getFile().' on line '.$e->getLine();
			exit;
		}
	}

	public function updateTournament8ChessStandardMailReminded($dbh, $player1)
	{
		$reminder_mail_sent = 1;

		try {
			$stmt = $dbh->prepare("UPDATE tournament_chess_standard_8 SET reminder_mail_sent=:reminder_mail_sent WHERE player1=:player1");
			$stmt->bindParam(':player1', $player1);
			$stmt->bindParam(':reminder_mail_sent', $reminder_mail_sent);
			$stmt->execute();
		} catch (PDOException $e) {
			echo $e->getMessage().' in '.$e->getFile().' on line '.$e->getLine();
			exit;
		}
	}

	public function updateTournament8ChessStandardTimeExpired($dbh, $player1, $player2)
	{
		$move_piece = 0;
		$game_over = 1; 
		$won_game = 0;

		try {
			$stmt = $dbh->prepare("UPDATE tournament_chess_standard_8 SET move_piece=:move_piece, game_over=:game_over, won_game=:won_game WHERE player1=:player1");
			$stmt->bindParam(':player1', $player1);
			$stmt->bindParam(':move_piece', $move_piece);
			$stmt->bindParam(':game_over', $game_over);
			$stmt->bindParam(':won_game', $won_game);
			$stmt->execute();
		} catch (PDOException $e) {
			echo $e->getMessage().' in '.$e->getFile().' on line '.$e->getLine();
			exit;
		}

		$player1 = $player2; // a fix because we cannot use player2 field or else the player whos time expired will be given a win. for example, player2 is zak so ben whos time expired gets the win because zak is his player2 field.
		$move_piece = 0;
		$game_over = 1; 
		$won_game = 1;

		try {
			$stmt = $dbh->prepare("UPDATE tournament_chess_standard_8 SET players=players-1, move_piece=:move_piece, game_over=:game_over, won_game=:won_game WHERE player1=:player1");
			$stmt->bindParam(':player1', $player1);
			$stmt->bindParam(':move_piece', $move_piece);
			$stmt->bindParam(':game_over', $game_over);
			$stmt->bindParam(':won_game', $won_game);
			$stmt->execute();
		} catch (PDOException $e) {
			echo $e->getMessage().' in '.$e->getFile().' on line '.$e->getLine();
			exit;
		}
	}

	public function deleteTournament8ChessStandard($dbh, $player1)
	{			
		try {
			$stmt = $dbh->prepare("DELETE FROM tournament_chess_standard_8 WHERE player1=:player1");
			$stmt->bindParam(':player1', $player1);
			$stmt->execute();
			
			return $stmt;
		} catch (PDOException $e) {
			echo $e->getMessage().' in '.$e->getFile().' on line '.$e->getLine();
			exit;
		}
	}

	public function deleteTournament8ChessStandardAll($dbh)
	{			
		try {
			$stmt = $dbh->prepare("DELETE FROM tournament_chess_standard_8");
			$stmt->execute();
			
			return $stmt;
		} catch (PDOException $e) {
			echo $e->getMessage().' in '.$e->getFile().' on line '.$e->getLine();
			exit;
		}
	}

	public function getUsernameFromCookie($user_id, $dbh)
	{			
		try {
			$stmt = $dbh->prepare("SELECT * FROM xyz_users WHERE user_id=:user_id");
			$stmt->bindParam(':user_id', $user_id);
			$stmt->execute();
			
			return $stmt;
		} catch (PDOException $e) {
			echo $e->getMessage().' in '.$e->getFile().' on line '.$e->getLine();
			exit;
		}
	}

	public function getSessionID($session_user_id, $dbh)
	{			
		try {
			$stmt = $dbh->prepare("SELECT * FROM xyz_sessions WHERE session_user_id=:session_user_id");
			$stmt->bindParam(':session_user_id', $session_user_id);
			$stmt->execute();
			
			return $stmt;
		} catch (PDOException $e) {
			echo $e->getMessage().' in '.$e->getFile().' on line '.$e->getLine();
			exit;
		}
	}

	public function getConf($dbh)
	{			
		try {
			$stmt = $dbh->prepare("SELECT config_value FROM xyz_config WHERE config_name='smtp_password'");
			$stmt->execute();
			
			return $stmt;
		} catch (PDOException $e) {
			echo $e->getMessage().' in '.$e->getFile().' on line '.$e->getLine();
			exit;
		}
	}

	// if count is greator than 0 then event creator data will be updated in the database else inserted into the database.
	public function doesEventExist($dbh, $name)
	{
		try {
			$stmt = $dbh->prepare("SELECT COUNT(*) FROM events WHERE name=:name");
			$stmt->bindParam(':name', $name);
			$stmt->execute();
			$eventCount = $stmt->fetchColumn();
			return $eventCount;
		} catch (PDOException $e) {
			echo $e->getMessage().' in '.$e->getFile().' on line '.$e->getLine();
			exit;
		}
	}
	
	public function insertEvent($dbh, $name, $description, $month_0, $month_1, $month_2, $month_3, $month_4, $month_5, $month_6, $month_7, $month_8, $month_9, $month_10, $month_11, $day_1, $day_2, $day_3, $day_4, $day_5, $day_6, $day_7, $day_8, $day_9, $day_10, $day_11, $day_12, $day_13, $day_14, $day_15, $day_16, $day_17, $day_18, $day_19, $day_20, $day_21, $day_22, $day_23, $day_24, $day_25, $day_26, $day_27, $day_28, $background_colour)
	{		
		try {						
			$stmt = $dbh->prepare("INSERT IGNORE INTO events (name, description, month_0, month_1, month_2, month_3, month_4, month_5, month_6, month_7, month_8, month_9, month_10, month_11, day_1, day_2, day_3, day_4, day_5, day_6, day_7, day_8, day_9, day_10, day_11, day_12, day_13, day_14, day_15, day_16, day_17, day_18, day_19, day_20, day_21, day_22, day_23, day_24, day_25, day_26, day_27, day_28, background_colour) VALUES(:name, :description, :month_0, :month_1, :month_2, :month_3, :month_4, :month_5, :month_6, :month_7, :month_8, :month_9, :month_10, :month_11, :day_1, :day_2, :day_3, :day_4, :day_5, :day_6, :day_7, :day_8, :day_9, :day_10, :day_11, :day_12, :day_13, :day_14, :day_15, :day_16, :day_17, :day_18, :day_19, :day_20, :day_21, :day_22, :day_23, :day_24, :day_25, :day_26, :day_27, :day_28, :background_colour)");
			$stmt->bindParam(':name', $name);
			$stmt->bindParam(':description', $description);
			$stmt->bindParam(':month_0', $month_0);
			$stmt->bindParam(':month_1', $month_1);
			$stmt->bindParam(':month_2', $month_2);
			$stmt->bindParam(':month_3', $month_3);
			$stmt->bindParam(':month_4', $month_4);
			$stmt->bindParam(':month_5', $month_5);
			$stmt->bindParam(':month_6', $month_6);
			$stmt->bindParam(':month_7', $month_7);
			$stmt->bindParam(':month_8', $month_8);
			$stmt->bindParam(':month_9', $month_9);
			$stmt->bindParam(':month_10', $month_10);
			$stmt->bindParam(':month_11', $month_11);
			$stmt->bindParam(':day_1', $day_1);
			$stmt->bindParam(':day_2', $day_2);
			$stmt->bindParam(':day_3', $day_3);
			$stmt->bindParam(':day_4', $day_4);
			$stmt->bindParam(':day_5', $day_5);
			$stmt->bindParam(':day_6', $day_6);
			$stmt->bindParam(':day_7', $day_7);
			$stmt->bindParam(':day_8', $day_8);
			$stmt->bindParam(':day_9', $day_9);
			$stmt->bindParam(':day_10', $day_10);
			$stmt->bindParam(':day_11', $day_11);
			$stmt->bindParam(':day_12', $day_12);
			$stmt->bindParam(':day_13', $day_13);
			$stmt->bindParam(':day_14', $day_14);
			$stmt->bindParam(':day_15', $day_15);
			$stmt->bindParam(':day_16', $day_16);
			$stmt->bindParam(':day_17', $day_17);
			$stmt->bindParam(':day_18', $day_18);
			$stmt->bindParam(':day_19', $day_19);
			$stmt->bindParam(':day_20', $day_20);
			$stmt->bindParam(':day_21', $day_21);
			$stmt->bindParam(':day_22', $day_22);
			$stmt->bindParam(':day_23', $day_23);
			$stmt->bindParam(':day_24', $day_24);
			$stmt->bindParam(':day_25', $day_25);
			$stmt->bindParam(':day_26', $day_26);
			$stmt->bindParam(':day_27', $day_27);
			$stmt->bindParam(':day_28', $day_28);
			$stmt->bindParam(':background_colour', $background_colour);
			$stmt->execute();
			
			return $stmt;
		} catch (PDOException $e) {
			echo $e->getMessage().' in '.$e->getFile().' on line '.$e->getLine();
			exit;
		}		
	}

	
	
	public function updateEvent($dbh, $name, $description, $month_0, $month_1, $month_2, $month_3, $month_4, $month_5, $month_6, $month_7, $month_8, $month_9, $month_10, $month_11, $day_1, $day_2, $day_3, $day_4, $day_5, $day_6, $day_7, $day_8, $day_9, $day_10, $day_11, $day_12, $day_13, $day_14, $day_15, $day_16, $day_17, $day_18, $day_19, $day_20, $day_21, $day_22, $day_23, $day_24, $day_25, $day_26, $day_27, $day_28, $background_colour)
	{
		try {
			$stmt = $dbh->prepare("UPDATE events SET
			description=:description,
			month_0=:month_0,
			month_1=:month_1,
			month_2=:month_2,
			month_3=:month_3,
			month_4=:month_4,
			month_5=:month_5,
			month_6=:month_6,
			month_7=:month_7,
			month_8=:month_8,
			month_9=:month_9,
			month_10=:month_10,
			month_11=:month_11,
			day_1=:day_1,
			day_2=:day_2,
			day_3=:day_3,
			day_4=:day_4,
			day_5=:day_5,
			day_6=:day_6,
			day_7=:day_7,
			day_8=:day_8,
			day_9=:day_9,
			day_10=:day_10,
			day_11=:day_11,
			day_12=:day_12,
			day_13=:day_13,
			day_14=:day_14,
			day_15=:day_15,
			day_16=:day_16,
			day_17=:day_17,
			day_18=:day_18,
			day_19=:day_19,
			day_20=:day_20,
			day_21=:day_21,
			day_22=:day_22,
			day_23=:day_23,
			day_24=:day_24,
			day_25=:day_25,
			day_26=:day_26,
			day_27=:day_27,
			day_28=:day_28,
			background_colour=:background_colour where name=:name
			");
			$stmt->bindParam(':name', $name);
			$stmt->bindParam(':description', $description);
			$stmt->bindParam(':month_0', $month_0);
			$stmt->bindParam(':month_1', $month_1);
			$stmt->bindParam(':month_2', $month_2);
			$stmt->bindParam(':month_3', $month_3);
			$stmt->bindParam(':month_4', $month_4);
			$stmt->bindParam(':month_5', $month_5);
			$stmt->bindParam(':month_6', $month_6);
			$stmt->bindParam(':month_7', $month_7);
			$stmt->bindParam(':month_8', $month_8);
			$stmt->bindParam(':month_9', $month_9);
			$stmt->bindParam(':month_10', $month_10);
			$stmt->bindParam(':month_11', $month_11);
			$stmt->bindParam(':day_1', $day_1);
			$stmt->bindParam(':day_2', $day_2);
			$stmt->bindParam(':day_3', $day_3);
			$stmt->bindParam(':day_4', $day_4);
			$stmt->bindParam(':day_5', $day_5);
			$stmt->bindParam(':day_6', $day_6);
			$stmt->bindParam(':day_7', $day_7);
			$stmt->bindParam(':day_8', $day_8);
			$stmt->bindParam(':day_9', $day_9);
			$stmt->bindParam(':day_10', $day_10);
			$stmt->bindParam(':day_11', $day_11);
			$stmt->bindParam(':day_12', $day_12);
			$stmt->bindParam(':day_13', $day_13);
			$stmt->bindParam(':day_14', $day_14);
			$stmt->bindParam(':day_15', $day_15);
			$stmt->bindParam(':day_16', $day_16);
			$stmt->bindParam(':day_17', $day_17);
			$stmt->bindParam(':day_18', $day_18);
			$stmt->bindParam(':day_19', $day_19);
			$stmt->bindParam(':day_20', $day_20);
			$stmt->bindParam(':day_21', $day_21);
			$stmt->bindParam(':day_22', $day_22);
			$stmt->bindParam(':day_23', $day_23);
			$stmt->bindParam(':day_24', $day_24);
			$stmt->bindParam(':day_25', $day_25);
			$stmt->bindParam(':day_26', $day_26);
			$stmt->bindParam(':day_27', $day_27);
			$stmt->bindParam(':day_28', $day_28);
			$stmt->bindParam(':background_colour', $background_colour);
			$stmt->execute();
		} catch (PDOException $e) {
			echo $e->getMessage().' in '.$e->getFile().' on line '.$e->getLine();
			exit;
		}
	}
		
	public function updateMaintenanceModeOffline($dbh, $disconnect1, $disconnect2, $disconnect3, $disconnect4, $disconnect5, $disconnect6, $disconnect7, $disconnect8, $disconnect9, $disconnect10, $disconnect11, $disconnect12, $disconnect13, $disconnect14, $disconnect15, $disconnect16, $disconnect17, $disconnect18, $disconnect19, $disconnect20, $messageOffline, $timestamp1, $timestamp2, $timestamp3, $timestamp4, $timestamp5, $timestamp6, $timestamp7, $timestamp8, $timestamp9, $timestamp10, $timestamp11, $timestamp12, $timestamp13, $timestamp14, $timestamp15, $timestamp16, $timestamp17, $timestamp18, $timestamp19, $timestamp20, $doOnce1, $doOnce2, $doOnce3, $doOnce4, $doOnce5, $doOnce6, $doOnce7, $doOnce8, $doOnce9, $doOnce10, $doOnce11, $doOnce12, $doOnce13, $doOnce14, $doOnce15, $doOnce16, $doOnce17, $doOnce18, $doOnce19, $doOnce20)
	{
		try {
			$stmt = $dbh->prepare("UPDATE servers_status SET
			disconnect_1=:disconnect_1,
			disconnect_2=:disconnect_2,
			disconnect_3=:disconnect_3,
			disconnect_4=:disconnect_4,
			disconnect_5=:disconnect_5,
			disconnect_6=:disconnect_6,
			disconnect_7=:disconnect_7,
			disconnect_8=:disconnect_8,
			disconnect_9=:disconnect_9,
			disconnect_10=:disconnect_10,
			disconnect_11=:disconnect_11,
			disconnect_12=:disconnect_12,
			disconnect_13=:disconnect_13,
			disconnect_14=:disconnect_14,
			disconnect_15=:disconnect_15,
			disconnect_16=:disconnect_16,
			disconnect_17=:disconnect_17,
			disconnect_18=:disconnect_18,
			disconnect_19=:disconnect_19,
			disconnect_20=:disconnect_20,
			message_offline=:message_offline,
			timestamp_1=:timestamp_1,
			timestamp_2=:timestamp_2,
			timestamp_3=:timestamp_3,
			timestamp_4=:timestamp_4,
			timestamp_5=:timestamp_5,
			timestamp_6=:timestamp_6,
			timestamp_7=:timestamp_7,
			timestamp_8=:timestamp_8,
			timestamp_9=:timestamp_9,
			timestamp_10=:timestamp_10,
			timestamp_11=:timestamp_11,
			timestamp_12=:timestamp_12,
			timestamp_13=:timestamp_13,
			timestamp_14=:timestamp_14,
			timestamp_15=:timestamp_15,
			timestamp_16=:timestamp_16,
			timestamp_17=:timestamp_17,
			timestamp_18=:timestamp_18,
			timestamp_19=:timestamp_19,
			timestamp_20=:timestamp_20,
			do_once_1=:do_once_1,
			do_once_2=:do_once_2,
			do_once_3=:do_once_3,
			do_once_4=:do_once_4,
			do_once_5=:do_once_5,
			do_once_6=:do_once_6,
			do_once_7=:do_once_7,
			do_once_8=:do_once_8,
			do_once_9=:do_once_9,
			do_once_10=:do_once_10,
			do_once_11=:do_once_11,
			do_once_12=:do_once_12,
			do_once_13=:do_once_13,
			do_once_14=:do_once_14,
			do_once_15=:do_once_15,
			do_once_16=:do_once_16,
			do_once_17=:do_once_17,
			do_once_18=:do_once_18,
			do_once_19=:do_once_19,
			do_once_20=:do_once_20");
			$stmt->bindParam(':disconnect_1', $disconnect1);
			$stmt->bindParam(':disconnect_2', $disconnect2);
			$stmt->bindParam(':disconnect_3', $disconnect3);
			$stmt->bindParam(':disconnect_4', $disconnect4);
			$stmt->bindParam(':disconnect_5', $disconnect5);
			$stmt->bindParam(':disconnect_6', $disconnect6);
			$stmt->bindParam(':disconnect_7', $disconnect7);
			$stmt->bindParam(':disconnect_8', $disconnect8);
			$stmt->bindParam(':disconnect_9', $disconnect9);
			$stmt->bindParam(':disconnect_10', $disconnect10);
			$stmt->bindParam(':disconnect_11', $disconnect11);
			$stmt->bindParam(':disconnect_12', $disconnect12);
			$stmt->bindParam(':disconnect_13', $disconnect13);
			$stmt->bindParam(':disconnect_14', $disconnect14);
			$stmt->bindParam(':disconnect_15', $disconnect15);
			$stmt->bindParam(':disconnect_16', $disconnect16);
			$stmt->bindParam(':disconnect_17', $disconnect17);
			$stmt->bindParam(':disconnect_18', $disconnect18);
			$stmt->bindParam(':disconnect_19', $disconnect19);
			$stmt->bindParam(':disconnect_20', $disconnect20);
			$stmt->bindParam(':message_offline', $messageOffline);
			$stmt->bindParam(':timestamp_1', $timestamp1);
			$stmt->bindParam(':timestamp_2', $timestamp2);
			$stmt->bindParam(':timestamp_3', $timestamp3);
			$stmt->bindParam(':timestamp_4', $timestamp4);
			$stmt->bindParam(':timestamp_5', $timestamp5);
			$stmt->bindParam(':timestamp_6', $timestamp6);
			$stmt->bindParam(':timestamp_7', $timestamp7);
			$stmt->bindParam(':timestamp_8', $timestamp8);
			$stmt->bindParam(':timestamp_9', $timestamp9);
			$stmt->bindParam(':timestamp_10', $timestamp10);
			$stmt->bindParam(':timestamp_11', $timestamp11);
			$stmt->bindParam(':timestamp_12', $timestamp12);
			$stmt->bindParam(':timestamp_13', $timestamp13);
			$stmt->bindParam(':timestamp_14', $timestamp14);
			$stmt->bindParam(':timestamp_15', $timestamp15);
			$stmt->bindParam(':timestamp_16', $timestamp16);
			$stmt->bindParam(':timestamp_17', $timestamp17);
			$stmt->bindParam(':timestamp_18', $timestamp18);
			$stmt->bindParam(':timestamp_19', $timestamp19);
			$stmt->bindParam(':timestamp_20', $timestamp20);
			$stmt->bindParam(':do_once_1', $doOnce1);
			$stmt->bindParam(':do_once_2', $doOnce2);
			$stmt->bindParam(':do_once_3', $doOnce3);
			$stmt->bindParam(':do_once_4', $doOnce4);
			$stmt->bindParam(':do_once_5', $doOnce5);
			$stmt->bindParam(':do_once_6', $doOnce6);
			$stmt->bindParam(':do_once_7', $doOnce7);
			$stmt->bindParam(':do_once_8', $doOnce8);
			$stmt->bindParam(':do_once_9', $doOnce9);
			$stmt->bindParam(':do_once_10', $doOnce10);
			$stmt->bindParam(':do_once_11', $doOnce11);
			$stmt->bindParam(':do_once_12', $doOnce12);
			$stmt->bindParam(':do_once_13', $doOnce13);
			$stmt->bindParam(':do_once_14', $doOnce14);
			$stmt->bindParam(':do_once_15', $doOnce15);
			$stmt->bindParam(':do_once_16', $doOnce16);
			$stmt->bindParam(':do_once_17', $doOnce17);
			$stmt->bindParam(':do_once_18', $doOnce18);
			$stmt->bindParam(':do_once_19', $doOnce19);
			$stmt->bindParam(':do_once_20', $doOnce20);
			$stmt->execute();
		} catch (PDOException $e) {
			echo $e->getMessage().' in '.$e->getFile().' on line '.$e->getLine();
			exit;
		}
	}
	
	public function updateMaintenanceModeOnline($dbh, $disconnect1, $disconnect2, $disconnect3, $disconnect4, $disconnect5, $disconnect6, $disconnect7, $disconnect8, $disconnect9, $disconnect10, $disconnect11, $disconnect12, $disconnect13, $disconnect14, $disconnect15, $disconnect16, $disconnect17, $disconnect18, $disconnect19, $disconnect20, $messageOnline, $timestamp1, $timestamp2, $timestamp3, $timestamp4, $timestamp5, $timestamp6, $timestamp7, $timestamp8, $timestamp9, $timestamp10, $timestamp11, $timestamp12, $timestamp13, $timestamp14, $timestamp15, $timestamp16, $timestamp17, $timestamp18, $timestamp19, $timestamp20, $doOnce1, $doOnce2, $doOnce3, $doOnce4, $doOnce5, $doOnce6, $doOnce7, $doOnce8, $doOnce9, $doOnce10, $doOnce11, $doOnce12, $doOnce13, $doOnce14, $doOnce15, $doOnce16, $doOnce17, $doOnce18, $doOnce19, $doOnce20)
	{
		try {
			$stmt = $dbh->prepare("UPDATE servers_status SET
			disconnect_1=:disconnect_1,
			disconnect_2=:disconnect_2,
			disconnect_3=:disconnect_3,
			disconnect_4=:disconnect_4,
			disconnect_5=:disconnect_5,
			disconnect_6=:disconnect_6,
			disconnect_7=:disconnect_7,
			disconnect_8=:disconnect_8,
			disconnect_9=:disconnect_9,
			disconnect_10=:disconnect_10,
			disconnect_11=:disconnect_11,
			disconnect_12=:disconnect_12,
			disconnect_13=:disconnect_13,
			disconnect_14=:disconnect_14,
			disconnect_15=:disconnect_15,
			disconnect_16=:disconnect_16,
			disconnect_17=:disconnect_17,
			disconnect_18=:disconnect_18,
			disconnect_19=:disconnect_19,
			disconnect_20=:disconnect_20,
			message_online=:message_online,
			timestamp_1=:timestamp_1,
			timestamp_2=:timestamp_2,
			timestamp_3=:timestamp_3,
			timestamp_4=:timestamp_4,
			timestamp_5=:timestamp_5,
			timestamp_6=:timestamp_6,
			timestamp_7=:timestamp_7,
			timestamp_8=:timestamp_8,
			timestamp_9=:timestamp_9,
			timestamp_10=:timestamp_10,
			timestamp_11=:timestamp_11,
			timestamp_12=:timestamp_12,
			timestamp_13=:timestamp_13,
			timestamp_14=:timestamp_14,
			timestamp_15=:timestamp_15,
			timestamp_16=:timestamp_16,
			timestamp_17=:timestamp_17,
			timestamp_18=:timestamp_18,
			timestamp_19=:timestamp_19,
			timestamp_20=:timestamp_20,
			do_once_1=:do_once_1,
			do_once_2=:do_once_2,
			do_once_3=:do_once_3,
			do_once_4=:do_once_4,
			do_once_5=:do_once_5,
			do_once_6=:do_once_6,
			do_once_7=:do_once_7,
			do_once_8=:do_once_8,
			do_once_9=:do_once_9,
			do_once_10=:do_once_10,
			do_once_11=:do_once_11,
			do_once_12=:do_once_12,
			do_once_13=:do_once_13,
			do_once_14=:do_once_14,
			do_once_15=:do_once_15,
			do_once_16=:do_once_16,
			do_once_17=:do_once_17,
			do_once_18=:do_once_18,
			do_once_19=:do_once_19,
			do_once_20=:do_once_20");
			$stmt->bindParam(':disconnect_1', $disconnect1);
			$stmt->bindParam(':disconnect_2', $disconnect2);
			$stmt->bindParam(':disconnect_3', $disconnect3);
			$stmt->bindParam(':disconnect_4', $disconnect4);
			$stmt->bindParam(':disconnect_5', $disconnect5);
			$stmt->bindParam(':disconnect_6', $disconnect6);
			$stmt->bindParam(':disconnect_7', $disconnect7);
			$stmt->bindParam(':disconnect_8', $disconnect8);
			$stmt->bindParam(':disconnect_9', $disconnect9);
			$stmt->bindParam(':disconnect_10', $disconnect10);
			$stmt->bindParam(':disconnect_11', $disconnect11);
			$stmt->bindParam(':disconnect_12', $disconnect12);
			$stmt->bindParam(':disconnect_13', $disconnect13);
			$stmt->bindParam(':disconnect_14', $disconnect14);
			$stmt->bindParam(':disconnect_15', $disconnect15);
			$stmt->bindParam(':disconnect_16', $disconnect16);
			$stmt->bindParam(':disconnect_17', $disconnect17);
			$stmt->bindParam(':disconnect_18', $disconnect18);
			$stmt->bindParam(':disconnect_19', $disconnect19);
			$stmt->bindParam(':disconnect_20', $disconnect20);
			$stmt->bindParam(':message_online', $messageOnline);
			$stmt->bindParam(':timestamp_1', $timestamp1);
			$stmt->bindParam(':timestamp_2', $timestamp2);
			$stmt->bindParam(':timestamp_3', $timestamp3);
			$stmt->bindParam(':timestamp_4', $timestamp4);
			$stmt->bindParam(':timestamp_5', $timestamp5);
			$stmt->bindParam(':timestamp_6', $timestamp6);
			$stmt->bindParam(':timestamp_7', $timestamp7);
			$stmt->bindParam(':timestamp_8', $timestamp8);
			$stmt->bindParam(':timestamp_9', $timestamp9);
			$stmt->bindParam(':timestamp_10', $timestamp10);
			$stmt->bindParam(':timestamp_11', $timestamp11);
			$stmt->bindParam(':timestamp_12', $timestamp12);
			$stmt->bindParam(':timestamp_13', $timestamp13);
			$stmt->bindParam(':timestamp_14', $timestamp14);
			$stmt->bindParam(':timestamp_15', $timestamp15);
			$stmt->bindParam(':timestamp_16', $timestamp16);
			$stmt->bindParam(':timestamp_17', $timestamp17);
			$stmt->bindParam(':timestamp_18', $timestamp18);
			$stmt->bindParam(':timestamp_19', $timestamp19);
			$stmt->bindParam(':timestamp_20', $timestamp20);
			$stmt->bindParam(':do_once_1', $doOnce1);
			$stmt->bindParam(':do_once_2', $doOnce2);
			$stmt->bindParam(':do_once_3', $doOnce3);
			$stmt->bindParam(':do_once_4', $doOnce4);
			$stmt->bindParam(':do_once_5', $doOnce5);
			$stmt->bindParam(':do_once_6', $doOnce6);
			$stmt->bindParam(':do_once_7', $doOnce7);
			$stmt->bindParam(':do_once_8', $doOnce8);
			$stmt->bindParam(':do_once_9', $doOnce9);
			$stmt->bindParam(':do_once_10', $doOnce10);
			$stmt->bindParam(':do_once_11', $doOnce11);
			$stmt->bindParam(':do_once_12', $doOnce12);
			$stmt->bindParam(':do_once_13', $doOnce13);
			$stmt->bindParam(':do_once_14', $doOnce14);
			$stmt->bindParam(':do_once_15', $doOnce15);
			$stmt->bindParam(':do_once_16', $doOnce16);
			$stmt->bindParam(':do_once_17', $doOnce17);
			$stmt->bindParam(':do_once_18', $doOnce18);
			$stmt->bindParam(':do_once_19', $doOnce19);
			$stmt->bindParam(':do_once_20', $doOnce20);
			$stmt->execute();
		} catch (PDOException $e) {
			echo $e->getMessage().' in '.$e->getFile().' on line '.$e->getLine();
			exit;
		}
	}
	
	public function eventRename($dbh, $name, $rename)
	{
		try {
			$stmt = $dbh->prepare("UPDATE events SET
			name=:rename WHERE name=:name");
			$stmt->bindParam(':name', $name);
			$stmt->bindParam(':rename', $rename);
			$stmt->execute();
		} catch (PDOException $e) {
			echo $e->getMessage().' in '.$e->getFile().' on line '.$e->getLine();
			exit;
		}
	}
	
	public function updateServerOnlineTotal($dbh)
	{
		try {
			$stmt = $dbh->prepare("UPDATE servers_status SET
			servers_online=0");
			$stmt->execute();
		} catch (PDOException $e) {
			echo $e->getMessage().' in '.$e->getFile().' on line '.$e->getLine();
			exit;
		}
	}
	
	public function deleteClientOnlineTotal($dbh)
	{
		try {
			$stmt = $dbh->prepare("DELETE FROM room_data");
			$stmt->execute();
		} catch (PDOException $e) {
			echo $e->getMessage().' in '.$e->getFile().' on line '.$e->getLine();
			exit;
		}
	}
	
	public function updateKicked($dbh, $user, $kicked)
	{	
		try {
			$stmt = $dbh->prepare("UPDATE users SET is_kicked=:is_kicked WHERE user=:user");
			$stmt->bindParam(':is_kicked', $kicked);
			$stmt->bindParam(':user', $user);
			$stmt->execute();
		} catch (PDOException $e) {
			echo $e->getMessage().' in '.$e->getFile().' on line '.$e->getLine();
			exit;
		}
	}
	
	public function updateBanned($dbh, $user, $banned)
	{	
		try {
			$stmt = $dbh->prepare("UPDATE users SET is_banned=:is_banned WHERE user=:user");
			$stmt->bindParam(':is_banned', $banned);
			$stmt->bindParam(':user', $user);
			$stmt->execute();
		} catch (PDOException $e) {
			echo $e->getMessage().' in '.$e->getFile().' on line '.$e->getLine();
			exit;
		}
	}

	
}

?>
