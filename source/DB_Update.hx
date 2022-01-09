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

package;

/**
 *
 * @author kboardgames.com
 */
class DB_Update extends DB_Parent
{

	/******************************
	 * the total amount of servers online. id = the server online. the second server has an id of 2.
	 */
	public function server_now_online_at_servers_status(id:Int):Int
	{
		tryMysqlConnectDatabase();
		
		if (id == 1) cnx.request("UPDATE servers_status set connected_1 = 1");
		if (id == 2) cnx.request("UPDATE servers_status set connected_2 = 1");
		if (id == 3) cnx.request("UPDATE servers_status set connected_3 = 1");
		if (id == 4) cnx.request("UPDATE servers_status set connected_4 = 1");
		if (id == 5) cnx.request("UPDATE servers_status set connected_5 = 1");
		if (id == 6) cnx.request("UPDATE servers_status set connected_6 = 1");
		if (id == 7) cnx.request("UPDATE servers_status set connected_7 = 1");
		if (id == 8) cnx.request("UPDATE servers_status set connected_8 = 1");
		if (id == 9) cnx.request("UPDATE servers_status set connected_9 = 1");
		if (id == 10) cnx.request("UPDATE servers_status set connected_10 = 1");
		if (id == 11) cnx.request("UPDATE servers_status set connected_11 = 1");
		if (id == 12) cnx.request("UPDATE servers_status set connected_12 = 1");
		if (id == 13) cnx.request("UPDATE servers_status set connected_13 = 1");
		if (id == 14) cnx.request("UPDATE servers_status set connected_14 = 1");
		if (id == 15) cnx.request("UPDATE servers_status set connected_15 = 1");
		if (id == 16) cnx.request("UPDATE servers_status set connected_16 = 1");
		if (id == 17) cnx.request("UPDATE servers_status set connected_17 = 1");
		if (id == 18) cnx.request("UPDATE servers_status set connected_18 = 1");
		if (id == 19) cnx.request("UPDATE servers_status set connected_19 = 1");
		if (id == 20) cnx.request("UPDATE servers_status set connected_20 = 1");
		
		
		cnx.close();
		return id;
	}
	
	/******************************
	 * update the temp data of the user.
	 */
	public function user_at_logged_in_users(_user:String, _roomState:Int):Void
	{
		tryMysqlConnectDatabase();
		
		var rset = cnx.request("UPDATE logged_in_users SET 
		timestamp = UNIX_TIMESTAMP(), 
		room_state = " + _roomState + " WHERE user = " + cnx.quote(_user) );
		
		cnx.close();
	}

	/******************************
	 * update the move history.
	 */
	public function gid_at_move_history(_gid:String, _user:String, _point_value:String, _unique_value:String, _pieceLocationOld1:String, _pieceLocationNew1:String, _pieceLocationOld2:String, _pieceLocationNew2:String, _pieceValueOld1:String, _pieceValueNew1:String, _pieceValueOld2:String, _pieceValueNew2:String, _pieceValueOld3:String):Void
	{
		tryMysqlConnectDatabase();
		
		_pieceLocationOld1 += ",";
		_pieceLocationNew1 += ",";
		_pieceLocationOld2 += ",";
		_pieceLocationNew2 += ",";
		_pieceValueOld1 += ",";
		_pieceValueNew1 += ",";
		_pieceValueOld2 += ",";
		_pieceValueNew2 += ",";
		_pieceValueOld3 += ",";
		
		try {
			
			var rset = cnx.request("SELECT COUNT(*) FROM move_history WHERE gid = " + cnx.quote(_gid));
				
			if (rset.getIntResult(0) == 0) 
			{
				var rset2 = cnx.request("INSERT IGNORE INTO move_history 
				(user,
				gid,
				point_value,
				unique_value,
				piece_location_old1, 
				piece_location_new1, 
				piece_location_old2, 
				piece_location_new2,
				piece_value_old1, 
				piece_value_new1, 
				piece_value_old2,
				piece_value_new2,
				piece_value_old3)
				VALUES 
				(" + cnx.quote(_user) + ", 
				 " + cnx.quote(_gid) + ", 
				 " + cnx.quote(_point_value) + ",
				 " + cnx.quote(_unique_value) + ",
				 " + cnx.quote(_pieceLocationOld1) + ",
				 " + cnx.quote(_pieceLocationNew1) + ",
				 " + cnx.quote(_pieceLocationOld2) + ",
				 " + cnx.quote(_pieceLocationNew2) + ",
				 " + cnx.quote(_pieceValueOld1) + ",
				 " + cnx.quote(_pieceValueNew1) + ",
				 " + cnx.quote(_pieceValueOld2) + ",
				 " + cnx.quote(_pieceValueNew2) + ",
				 " + cnx.quote(_pieceValueOld3) + "
				 )");
			}
		
			else
			{
				var rset2 = cnx.request("UPDATE move_history SET
				point_value = " + cnx.quote(_point_value) + ",
				unique_value = " + cnx.quote(_unique_value) + ",
				piece_location_old1 = CONCAT(IFNULL(piece_location_old1,''), " + cnx.quote(_pieceLocationOld1) + "),
				piece_location_new1 = CONCAT(IFNULL(piece_location_new1, ''), " + cnx.quote(_pieceLocationNew1) + "),
				piece_location_old2 = CONCAT(IFNULL(piece_location_old2, ''), " + cnx.quote(_pieceLocationOld2) + "),
				piece_location_new2 = CONCAT(IFNULL(piece_location_new2, ''), " + cnx.quote(_pieceLocationNew2) + "),
				piece_value_old1 = CONCAT(IFNULL(piece_value_old1, ''), " + cnx.quote(_pieceValueOld1) + "),
				piece_value_new1 = CONCAT(IFNULL(piece_value_new1, ''), " + cnx.quote(_pieceValueNew1) + "),
				piece_value_old2 = CONCAT(IFNULL(piece_value_old2, ''), " + cnx.quote(_pieceValueOld2) + "),
				piece_value_new2 = CONCAT(IFNULL(piece_value_new2, ''), " + cnx.quote(_pieceValueNew2) + "), 
				piece_value_old3 = CONCAT(IFNULL(piece_value_old3, ''), " + cnx.quote(_pieceValueOld3) + ") 
				WHERE gid = " + cnx.quote(_gid));
			}

		}
		catch (e:Dynamic)
		{
			trace("MySql error.");		
		}
		
		cnx.close();
		
	}
	
	public function server_online_at_servers_status(id:Int):Void
	{
		tryMysqlConnectDatabase();
		
		var rset = cnx.request("UPDATE servers_status set servers_online = " + id);
		
		cnx.close();
	}
	
	public function hostname_at_users(_user:String, _hostname:String):Void
	{
		tryMysqlConnectDatabase();
		
		try
		{
			var rset3 = cnx.request("UPDATE users set hostname = " + cnx.quote(_hostname) + " WHERE user = " + cnx.quote(_user) );
		}
		catch (e:Dynamic)
		{
			trace("MySql error.");		
		}
		
		cnx.close(); 
	}
	
	/******************************
	 * reset server data because we do not want a message saying this server is has been cancelled when we did not receive a message about server going offline.
	 */
	public function server_id_at_servers_status(id:Int):Void
	{
		tryMysqlConnectDatabase();
		
		if (id == 1)
		{
			cnx.request("UPDATE servers_status set 
			disconnect_1 = 0,
			timestamp_1 = 0,
			do_once_1 = 0");			
		}
		
		if (id == 2)
		{
			cnx.request("UPDATE servers_status set 
			disconnect_2 = 0,
			timestamp_2 = 0,
			do_once_2 = 0");			
		}
		
		if (id == 3)
		{
			cnx.request("UPDATE servers_status set 
			disconnect_3 = 0,
			timestamp_3 = 0,
			do_once_3 = 0");			
		}
		
		if (id == 4)
		{
			cnx.request("UPDATE servers_status set 
			disconnect_4 = 0,
			timestamp_4 = 0,
			do_once_4 = 0");			
		}
		
		if (id == 5)
		{
			cnx.request("UPDATE servers_status set 
			disconnect_5 = 0,
			timestamp_5 = 0,
			do_once_5 = 0");			
		}
		
		if (id == 6)
		{
			cnx.request("UPDATE servers_status set 
			disconnect_6 = 0,
			timestamp_6 = 0,
			do_once_6 = 0");			
		}
		
		if (id == 7)
		{
			cnx.request("UPDATE servers_status set 
			disconnect_7 = 0,
			timestamp_7 = 0,
			do_once_7 = 0");			
		}
		
		if (id == 8)
		{
			cnx.request("UPDATE servers_status set 
			disconnect_8 = 0,
			timestamp_8 = 0,
			do_once_8 = 0");			
		}
		
		if (id == 9)
		{
			cnx.request("UPDATE servers_status set 
			disconnect_9 = 0,
			timestamp_9 = 0,
			do_once_9 = 0");			
		}
		
		if (id == 10)
		{
			cnx.request("UPDATE servers_status set 
			disconnect_10 = 0,
			timestamp_10 = 0,
			do_once_10 = 0");			
		}
				
		if (id == 11)
		{
			cnx.request("UPDATE servers_status set 
			disconnect_11 = 0,
			timestamp_11 = 0,
			do_once_11 = 0");			
		}
		
		if (id == 12)
		{
			cnx.request("UPDATE servers_status set 
			disconnect_12 = 0,
			timestamp_12 = 0,
			do_once_12 = 0");			
		}
		
		if (id == 13)
		{
			cnx.request("UPDATE servers_status set 
			disconnect_13 = 0,
			timestamp_13 = 0,
			do_once_13 = 0");			
		}
		
		if (id == 14)
		{
			cnx.request("UPDATE servers_status set 
			disconnect_14 = 0,
			timestamp_14 = 0,
			do_once_14 = 0");			
		}
		
		if (id == 15)
		{
			cnx.request("UPDATE servers_status set 
			disconnect_15 = 0,
			timestamp_15 = 0,
			do_once_15 = 0");			
		}
		
		if (id == 16)
		{
			cnx.request("UPDATE servers_status set 
			disconnect_16 = 0,
			timestamp_16 = 0,
			do_once_16 = 0");			
		}
		
		if (id == 17)
		{
			cnx.request("UPDATE servers_status set 
			disconnect_17 = 0,
			timestamp_17 = 0,
			do_once_17 = 0");			
		}
		
		if (id == 18)
		{
			cnx.request("UPDATE servers_status set 
			disconnect_18 = 0,
			timestamp_18 = 0,
			do_once_18 = 0");			
		}
		
		if (id == 19)
		{
			cnx.request("UPDATE servers_status set 
			disconnect_19 = 0,
			timestamp_19 = 0,
			do_once_19 = 0");			
		}
		
		if (id == 20)
		{
			cnx.request("UPDATE servers_status set 
			disconnect_20 = 0,
			timestamp_20 = 0,
			do_once_20 = 0");			
		}
		
		cnx.close();
	}
	
	// the total amount of servers online.
	public function do_once_at_servers_status():Void
	{
		tryMysqlConnectDatabase();
		
		var rset = cnx.request("UPDATE servers_status set 
		do_once_1 = 0,
		do_once_2 = 0,
		do_once_3 = 0,
		do_once_4 = 0,
		do_once_5 = 0,
		do_once_6 = 0,
		do_once_7 = 0,
		do_once_8 = 0,
		do_once_9 = 0,
		do_once_10 = 0,
		do_once_11 = 0,
		do_once_12 = 0,
		do_once_13 = 0,
		do_once_14 = 0,
		do_once_15 = 0,
		do_once_16 = 0,
		do_once_17 = 0,
		do_once_18 = 0,
		do_once_19 = 0,
		do_once_20 = 0
		");
		
		cnx.close();
	}
	
	public function chess_elo_rating_statistics(_user:String, _rating:Float):Void
	{
		tryMysqlConnectDatabase();

		try 
		{
			var rset = cnx.request("UPDATE statistics SET 
			chess_elo_rating = " + _rating + "
			WHERE user = " + cnx.quote(_user) );
		}
		
		catch (e:Dynamic)
		{
			trace("MySql error.");		
		}
		
		cnx.close();
	}
	
	/******************************
	 * if event month and day in reg file is different than month and day found in table then write new month and day value to table and also write credits_today value to 0 since this is a new day.
	 */
	public function credits_for_user_at_statistics(_user:String, _eventMonth:Int, _eventDay:Int):Void
	{
		tryMysqlConnectDatabase();
		
		var rset = cnx.request("UPDATE statistics SET 
		event_month = " + _eventMonth + ", 
		event_day = " + _eventDay + ",
		credits_today = 1 
		WHERE user = " + cnx.quote(_user) );
		
		cnx.close();
	}
	
	public function credits_date_for_user_at_statistics(_user:String):Void
	{
		tryMysqlConnectDatabase();
		
		var rset = cnx.request("UPDATE statistics SET 
		credits_today = credits_today + 1, 
		credits_total = credits_total + 1 
		WHERE user = " + cnx.quote(_user) );
		
		cnx.close();
	}
	
	/******************************
	 *	give experience points to user after the game ends. exp points for a game lost is about half that of a win.
	 * _exp		the experience points to give to user.
	 */
	public function exp_points_for_user_at_statistics(_user:String, _exp:Int):Void
	{
		tryMysqlConnectDatabase();
		
		try
		{
			var rset = cnx.request("UPDATE statistics SET 
			experience_points = experience_points + " + _exp + " WHERE user = " + cnx.quote(_user) );
		}
		
		catch (e:Dynamic)
		{
			trace("MySql error.");		
		}
		
		cnx.close();
	}
	
	/******************************
	 *	give house coins to user after the game ends. house coins for a game lost is half that of a win.
	 * _coins		the house coins to give to user.
	 */
	public function house_coins_for_user_at_statistics(_user:String, _coins:Int):Void
	{
		tryMysqlConnectDatabase();
		
		try
		{
			var rset = cnx.request("UPDATE statistics SET 
			house_coins = house_coins + " + _coins + " WHERE user = " + cnx.quote(_user) );
		}
		
		catch (e:Dynamic)
		{
			trace("MySql error.");		
		}
		
		cnx.close();
	}
	
	// at tournament a player's piece was moved. update the time and anything else needed to continue the tournament play.
	public function tournament_chess_standard_8(_player1:String, _player2:String, _time_remaining_player1:String, _time_remaining_player2:String, _move_number_current):Void
	{
		tryMysqlConnectDatabase();		
		
		try
		{
			if (_move_number_current == 0)
			{
				var _var = cnx.request("UPDATE tournament_chess_standard_8 SET 
				time_remaining_player1 = " + cnx.quote(_time_remaining_player1) + ",
				move_piece = 0,
				timestamp = UNIX_TIMESTAMP(),
				reminder_mail_sent = 1,
				move_total = move_total + 1
				WHERE player1 = " + cnx.quote(_player1) );
				
				// the other player is now able to move piece so update these.
				var _var = cnx.request("UPDATE tournament_chess_standard_8 SET 
				time_remaining_player1 = " + cnx.quote(_time_remaining_player1) + ",
				move_piece = 1,
				timestamp = UNIX_TIMESTAMP(),
				reminder_mail_sent = 0
				WHERE player1 = " + cnx.quote(_player2) );
			}
			
			else
			{
				var _var = cnx.request("UPDATE tournament_chess_standard_8 SET 
				time_remaining_player2 = " + cnx.quote(_time_remaining_player2) + ",
				move_piece = 0,
				timestamp = UNIX_TIMESTAMP(),
				reminder_mail_sent = 1,
				move_total = move_total + 1
				WHERE player1 = " + cnx.quote(_player1) );
				
				var _var = cnx.request("UPDATE tournament_chess_standard_8 SET 
				time_remaining_player2 = " + cnx.quote(_time_remaining_player2) + ",
				move_piece = 1,
				timestamp = UNIX_TIMESTAMP(),
				reminder_mail_sent = 0
				WHERE player1 = " + cnx.quote(_player2) );
			}
		}
		catch (e:Dynamic)
		{
			trace("MySql error.");		
		}
		
		cnx.close();
	
	}
	
	// if game over, from a checkmate or something, end game for both players.
	public function tournament_chess_standard_8_game_over(_player1:String, _player2:String, _won_game1:Int, _won_game2:Int):Void
	{
		tryMysqlConnectDatabase();		
		
		try
		{
			var _var = cnx.request("UPDATE tournament_chess_standard_8 SET 
			move_piece = 0,
			game_over = 1,
			won_game = " + _won_game1 + ",
			players = players - " + _won_game1 + "			
			WHERE player1 = " + cnx.quote(_player1) );
				
			var _var = cnx.request("UPDATE tournament_chess_standard_8 SET 
			move_piece = 0,
			game_over = 1,
			won_game = " + _won_game2 + ",
			players = players - " + _won_game2 + "
			WHERE player1 = " + cnx.quote(_player2) );
			
		}
		catch (e:Dynamic)
		{
			trace("MySql error.");		
		}
		
		cnx.close();
	
	}
	
	public function tournament_chess_standard_8_reminder_by_mail(_player1:String, _reminder:Int):Void
	{
		tryMysqlConnectDatabase();		
		
		try
		{
			var _var = cnx.request("UPDATE tournament_chess_standard_8 SET 
			reminder_by_mail = " + _reminder + "			
			WHERE player1 = " + cnx.quote(_player1) );
		}
		catch (e:Dynamic)
		{
			trace("MySql error.");		
		}
		
		cnx.close();
	
	}
	// win three in a row.
	public function daily_quests_3_in_a_row_win(_user:String):Void
	{
		tryMysqlConnectDatabase();		
		
		try
		{
			var _var = cnx.request("UPDATE daily_quests SET 
			three_in_a_row = three_in_a_row + 1 WHERE three_in_a_row < 3 AND user = " + cnx.quote(_user) );
		}
		catch (e:Dynamic)
		{
			trace("MySql error.");		
		}
		
		cnx.close();
	
	}
	
	// lose a game and the win "three in a row" will be set back to zero.
	public function daily_quests_3_in_a_row_lose(_user:String):Void
	{
		tryMysqlConnectDatabase();		
		
		try
		{
			var _var = cnx.request("UPDATE daily_quests SET 
			three_in_a_row = 0 WHERE user = " + cnx.quote(_user) );
		}
		catch (e:Dynamic)
		{
			trace("MySql error.");		
		}
		
		cnx.close();
	
	}
	
	public function daily_quests_chess_5_moves_under(_user:String):Void
	{
		tryMysqlConnectDatabase();		
		
		try
		{
			var _var = cnx.request("UPDATE daily_quests SET 
			chess_5_moves_under = 1 WHERE user = " + cnx.quote(_user) );
		}
		catch (e:Dynamic)
		{
			trace("MySql error.");		
		}
		
		cnx.close();
	
	}
	
	public function daily_quests_snakes_under_4_moves(_user:String):Void
	{
		tryMysqlConnectDatabase();		
		
		try
		{
			var _var = cnx.request("UPDATE daily_quests SET 
			snakes_under_4_moves = 1 WHERE user = " + cnx.quote(_user) );
		}
		catch (e:Dynamic)
		{
			trace("MySql error.");		
		}
		
		cnx.close();
	
	}
	
	public function daily_quests_win_5_minute_game(_user:String):Void
	{
		tryMysqlConnectDatabase();		
		
		try
		{
			var _var = cnx.request("UPDATE daily_quests SET 
			win_5_minute_game = 1 WHERE user = " + cnx.quote(_user) );
		}
		catch (e:Dynamic)
		{
			trace("MySql error.");		
		}
		
		cnx.close();
	
	}
	
	public function daily_quests_buy_four_house_items(_user:String):Void
	{
		tryMysqlConnectDatabase();		
		
		try
		{
			var _var = cnx.request("UPDATE daily_quests SET 
			buy_four_house_items = buy_four_house_items + 1 WHERE buy_four_house_items < 4 AND user = " + cnx.quote(_user) );
		}
		catch (e:Dynamic)
		{
			trace("MySql error.");		
		}
		
		cnx.close();
	
	}
	
	public function daily_quests_finish_signature_game(_user:String):Void
	{
		tryMysqlConnectDatabase();		
		
		try
		{
			var _var = cnx.request("UPDATE daily_quests SET 
			finish_signature_game = 1 WHERE user = " + cnx.quote(_user) );
		}
		catch (e:Dynamic)
		{
			trace("MySql error.");		
		}
		
		cnx.close();
	
	}
	
	public function daily_quests_reversi_occupy_50_units(_user:String):Void
	{
		tryMysqlConnectDatabase();		
		
		try
		{
			var _var = cnx.request("UPDATE daily_quests SET 
			reversi_occupy_50_units = 1 WHERE user = " + cnx.quote(_user) );
		}
		catch (e:Dynamic)
		{
			trace("MySql error.");		
		}
		
		cnx.close();
	
	}
	
	public function daily_quests_checkers_get_6_kings(_user:String):Void
	{
		tryMysqlConnectDatabase();		
		
		try
		{
			var _var = cnx.request("UPDATE daily_quests SET 
			checkers_get_6_kings = 1 WHERE user = " + cnx.quote(_user) );
		}
		catch (e:Dynamic)
		{
			trace("MySql error.");		
		}
		
		cnx.close();
	
	}
	
	public function daily_quests_play_all_5_board_games(_user:String):Void
	{
		tryMysqlConnectDatabase();		
		
		try
		{
			var _var = cnx.request("UPDATE daily_quests SET 
			play_all_5_board_games = play_all_5_board_games + 1 WHERE play_all_5_board_games < 5 AND user = " + cnx.quote(_user) );
		}
		catch (e:Dynamic)
		{
			trace("MySql error.");		
		}
		
		cnx.close();
	
	}
	
	public function daily_quests_rewards(_user:String, _rewards:String):Void
	{
		tryMysqlConnectDatabase();		
		
		try
		{
			var rset = cnx.request("UPDATE daily_quests SET 
			rewards = " + cnx.quote(_rewards) + " WHERE user = " + cnx.quote(_user) );
		}
		catch (e:Dynamic)
		{
			trace("MySql error.");		
		}
		
		cnx.close();
	
	}
		
	public function daily_reward_at_statistics(_user:String, _experiencePoints:Int, _houseCoins:Int, _creditsTotal:Int):Void
	{
		tryMysqlConnectDatabase();		
		
		try
		{
			var rset = cnx.request("UPDATE statistics SET 
			experience_points = " + _experiencePoints + ",
			house_coins = " + _houseCoins + ",
			credits_total = " + _creditsTotal + "
			WHERE user = " + cnx.quote(_user) );
		}
		catch (e:Dynamic)
		{
			trace("MySql error.");
		}
		
		cnx.close();
	
	}
	
	public function most_to_zero_for_room_at_room_data(_room:Int, _roomState:Int, _userLocation:Int, _roomPlayerLimit:Int):Void
	{
		tryMysqlConnectDatabase();		

		var _var = cnx.request("UPDATE room_data SET 
		room_state = 0,
		user_location = 0,
		room = 0,
		player_limit = 0
		WHERE room = " + _room);
					
		cnx.close();
	
	}	
	
	public function user_all_to_zero_at_room_data(_user:String):Void
	{
		tryMysqlConnectDatabase();		
		
		var _var = cnx.request("UPDATE room_data SET 
		room_state = 0,
		user_location = 0,
		room = 0,
		player_limit = 0,
		allow_spectators = 0,
		spectator_watching = 0, 
		spectator_playing = 0
		WHERE user = " + cnx.quote(_user));	
					
		cnx.close();
	
	}
	
	public function avatar_at_login(_user:String, _avatar:String):Void
	{
		tryMysqlConnectDatabase();		
		
		try {
			var rset = cnx.request("UPDATE statistics SET user_avatar = " + cnx.quote(_avatar) + " WHERE user = " + cnx.quote(_user));				
		}
		catch (e:Dynamic)
		{
			trace("MySql error.");		
		}
		
		cnx.close();
	
	}
	
	public function user_set_is_kicked_at_users(_user:String):Void
	{
		tryMysqlConnectDatabase();		
		
		try {
			var rset = cnx.request("UPDATE users SET is_kicked = 0 WHERE user = " + cnx.quote(_user));				
		}
		catch (e:Dynamic)
		{
			trace("MySql error.");		
		}
		
		cnx.close();
	
	}
	
	/******************************
	 * player is no longer using a guest account. change names.
	 */
	public function rename_user_from_guest_at_users(_user:String, _old_username:String, _password_hash:String, _hostname:String):Void
	{
		tryMysqlConnectDatabase();
		
		try {
			var rset = cnx.request("UPDATE users SET user = " + cnx.quote(_user) + ", password_hash = " + cnx.quote(_password_hash) + "  WHERE user like 'Guest%' AND user = " + cnx.quote(_old_username) + " AND hostname = " + cnx.quote(_hostname));
			
			var rset2 = cnx.request("UPDATE house SET user = " + cnx.quote(_user) + " WHERE user like 'Guest%' AND user = " + cnx.quote(_old_username));
			
			var rset3 = cnx.request("UPDATE statistics SET user = " + cnx.quote(_user) + " WHERE user like 'Guest%' AND user = " + cnx.quote(_old_username));
		}
		
		catch (e:Dynamic)
		{
			trace("MySql error.");		
		}
		
		cnx.close();
	
	}
	
	/******************************
	 * save room data for users in room.
	 */
	public function data_for_room_at_room_data(_room:Int, _roomState:Int, _userLocation:Int, _roomPlayerLimit:Int):Void
	{
		tryMysqlConnectDatabase();		
	
		try {
			var _var = cnx.request("UPDATE room_data SET 
			user_location = " + _userLocation + ", 
			player_limit = " + _roomPlayerLimit + ", 	
			game_players_values = '0',
			room_state = " + _roomState + " WHERE room = " + _room );
					
		}
		catch (e:Dynamic)
		{
			trace("MySql error.");		
		}
		
		cnx.close();
	
	}
	
	public function move_number_dynamic_at_room_data(_user:String, _moveNumberDynamic:Int):Void
	{
		tryMysqlConnectDatabase();		
	
		try {
			var _var = cnx.request("UPDATE room_data SET 
			move_number_dynamic = " + _moveNumberDynamic + " WHERE user = " + cnx.quote(_user));	
		}
		catch (e:Dynamic)
		{
			trace("MySql error.");		
		}
		
		cnx.close();
	
	}
	
	public function player_limit_at_room_data(_user:String, _room:Int, _roomPlayerLimit:Int):Void
	{
		tryMysqlConnectDatabase();		
	
		try {
			var _var = cnx.request("UPDATE room_data SET 
			player_limit = " + _roomPlayerLimit + " WHERE room = " + _room );
			
			var _var = cnx.request("UPDATE room_data SET 
			spectator_playing = 0, game_id = -1 WHERE user = " + cnx.quote(_user));
		}
		catch (e:Dynamic)
		{
			trace("MySql error.");		
		}
		
		cnx.close();
	
	}
	
	/**
	 * @param	_user					name of user that entered the event.
	 * @param	_isGameFinished			is the current game finished?
	 * @param	_spectatorWatching		did the user enter game room by clicking the watch button from lobby?
	 */
	public function is_game_finished_for_user_at_room_data(_user:String, _isGameFinished:Bool, _spectatorWatching:Bool):Void
	{
		tryMysqlConnectDatabase();		
		
		try {
			var _var = cnx.request("UPDATE room_data SET 
			is_game_finished = " + _isGameFinished + " WHERE user = " + cnx.quote(_user));
			
			if (_isGameFinished == false && _spectatorWatching == false)
			{
				var _var = cnx.request("UPDATE room_data SET 
			spectator_playing = 1 WHERE user = " + cnx.quote(_user));
			}
					
		}
		catch (e:Dynamic)
		{
			trace("MySql error.");		
		}
		
		cnx.close();
	
	}
	
	// _dataMisc
	public function game_players_values_at_room_data(_user:String, _gamePlayersValues:Int):Void
	{
		tryMysqlConnectDatabase();		
		
		try {
			var _var = cnx.request("UPDATE room_data SET 
			game_players_values = " + _gamePlayersValues + " WHERE user = " + cnx.quote(_user));
					
		}
		catch (e:Dynamic)
		{
			trace("MySql error.");		
		}
		
		cnx.close();
	
	}
	
	public function spectator_playing_at_room_data(_user:String, _spectatorPlaying:Int):Void
	{
		tryMysqlConnectDatabase();		
		
		try {
			var _var = cnx.request("UPDATE room_data SET 
			spectator_playing = " + _spectatorPlaying + " WHERE user = " + cnx.quote(_user));
					
		}
		catch (e:Dynamic)
		{
			trace("MySql error.");		
		}
		
		cnx.close();
	
	}
	
	// save room state for users in room.
	public function is_game_finished_for_room_at_room_data(_room:Int, _isGameFinished:Bool, _is_spectator_watching:Bool):Void
	{
		tryMysqlConnectDatabase();		
	
		try {
			var _var = cnx.request("UPDATE room_data SET 
			is_game_finished = " + _isGameFinished + " WHERE room = " + _room );
			
			if (_isGameFinished == false)
			{
				if (_is_spectator_watching == false)
				{
					var _var = cnx.request("UPDATE room_data SET 
			spectator_playing = 1 WHERE room = " + _room );
				}
			}
		}
		catch (e:Dynamic)
		{
			trace("MySql error.");		
		}
		
		cnx.close();
	
	}
	
	public function all_for_user_at_room_data(_user:String, _roomState:Int, _userlocation:Int, _room:Int, _roomPlayerLimit:Int, _gameId:Int, _vsComputer:Int, _allowSpectators:Int):Void
	{
		tryMysqlConnectDatabase();		
		
		var _var = cnx.request("UPDATE room_data SET 
		room_state = " + _roomState + ", 
		user_location = " + _userlocation + ", 
		game_id = " + _gameId + ",
		room = " + _room + ",
		vs_computer = " + _vsComputer + ",
		allow_spectators = " + _allowSpectators + ",
		timestamp = UNIX_TIMESTAMP(),
		player_limit = " + _roomPlayerLimit + " WHERE user = " + cnx.quote(_user) );
		
		cnx.close();
	
	}
	
	public function user_at_room_data(_user:String, _roomState:Int, _userlocation:Int, _room:Int, _roomPlayerLimit:Int, _gameId:Int, _vsComputer:Int, _allowSpectators:Int):Void
	{
		tryMysqlConnectDatabase();		
		
		var _var = cnx.request("UPDATE room_data SET 
		room_state = " + _roomState + ", 
		user_location = " + _userlocation + ", 
		game_id = " + _gameId + ",
		room = " + _room + ",
		vs_computer = " + _vsComputer + ",
		allow_spectators = " + _allowSpectators + ",
		timestamp = UNIX_TIMESTAMP(),
		player_limit = " + _roomPlayerLimit + ",
		spectator_watching = 1,
		game_players_values = 0 WHERE user = " + cnx.quote(_user) );
		
		cnx.close();
	
	}
	
	public function room_with_room_state_at_room_data(_roomState:Int, _room:Int):Void
	{
		tryMysqlConnectDatabase();		
		
		
		try {
			var _var = cnx.request("UPDATE room_data SET 
			room_state = " + _roomState + "
			WHERE user_location = 2 AND room = " + _room );
		
		}
		catch (e:Dynamic)
		{
			trace("MySql error.");		
		}
		
		cnx.close();
	
	}
	
	public function user_email_address_at_all_tables(_user:String, _email_address:String):Void
	{
		tryMysqlConnectDatabase();		
		
		
		try {
			var _var = cnx.request("UPDATE users SET 
			email_address = " + _email_address + "
			WHERE user = " + cnx.quote(_user) );
			
			var _var = cnx.request("UPDATE tournament_chess_standard_8 SET 
			email_address = " + _email_address + "
			WHERE user = " + cnx.quote(_user) );		
		}
		catch (e:Dynamic)
		{
			trace("MySql error.");		
		}
		
		cnx.close();
	
	}
	
	public function user_password_hash_at_users(_user:String, _password_hash:String):Void
	{
		tryMysqlConnectDatabase();		
		
		try {
			var _var = cnx.request("UPDATE users SET 
			password_hash = " + cnx.quote(_password_hash) + "
			WHERE user = " + cnx.quote(_user));
		
		}
		catch (e:Dynamic)
		{
			trace("MySql error.");		
		}
		
		cnx.close();
	
	}
	
	public function user_house_data_at_house(_user:String, _sprite_number:String, _sprite_name:String, _items_x:String, _items_y:String, _map_x:String, _map_y:String, _is_item_purchased:String, _item_direction_facing:String, _map_offset_x:String, _map_offset_y:String, _item_is_hidden:String, _item_order:String, _item_behind_walls:String, _floor:String, _wall_left:String, _wall_up_behind:String, _wall_up_in_front:String, _floor_is_hidden:String, _wall_left_is_hidden:String, _wall_up_behind_is_hidden:String, _wall_up_in_front_is_hidden:String):DB_Parent.MysqlData
	{
		tryMysqlConnectDatabase();
		
		try {
			var _var = cnx.request("UPDATE house SET 
			sprite_number = " + cnx.quote(_sprite_number) + ",
			sprite_name = " + cnx.quote(_sprite_name) + ",
			items_x = " + cnx.quote(_items_x) + ",
			items_y = " + cnx.quote(_items_y) + ",
			map_x = " + cnx.quote(_map_x) + ",
			map_y = " + cnx.quote(_map_y) + ",
			is_item_purchased = " + cnx.quote(_is_item_purchased) + ",
			item_direction_facing = " + cnx.quote(_item_direction_facing) + ",
			map_offset_x = " + cnx.quote(_map_offset_x) + ",
			map_offset_y = " + cnx.quote(_map_offset_y) + ",
			item_is_hidden = " + cnx.quote(_item_is_hidden) + ",
			item_order = " + cnx.quote(_item_order) + ",
			item_behind_walls = " + cnx.quote(_item_behind_walls) + ",		
			floor = " + cnx.quote(_floor) + ",
			wall_left = " + cnx.quote(_wall_left) + ",
			wall_up_behind = " + cnx.quote(_wall_up_behind) + ",
			wall_up_in_front = " + cnx.quote(_wall_up_in_front) + ",
			floor_is_hidden = " + cnx.quote(_floor_is_hidden) + ",
			wall_left_is_hidden = " + cnx.quote(_wall_left_is_hidden) + ",
			wall_up_behind_is_hidden = " + cnx.quote(_wall_up_behind_is_hidden) + ",
			wall_up_in_front_is_hidden = " + cnx.quote(_wall_up_in_front_is_hidden) + "
			WHERE user = " + cnx.quote(_user));

		}
		catch (e:Dynamic)
		{
			trace("MySql error.");		
		}
		
		cnx.close();
		
		return _mysqlData;
	}
	
	public function win_at_statistics(_gameId:Int, _user:String, _gameTimePlayedInSeconds:Int = 0):Void
	{
		tryMysqlConnectDatabase();		
		
		try
		{
			if (_gameTimePlayedInSeconds != 0)
			{
				var _var = cnx.request("UPDATE statistics SET shortest_time_game_played = " + _gameTimePlayedInSeconds + " WHERE shortest_time_game_played > " + _gameTimePlayedInSeconds + " AND user = " + cnx.quote(_user) );
				
				var _var = cnx.request("UPDATE statistics SET longest_time_game_played = " + _gameTimePlayedInSeconds + " WHERE longest_time_game_played < " + _gameTimePlayedInSeconds + " AND user = " + cnx.quote(_user) );
			}
			
			// update the win streak and set the lose and draw streak to 0 since those game streaks have ended.
			var _var = cnx.request("UPDATE statistics SET longest_current_winning_streak = longest_current_winning_streak + 1, longest_current_losing_streak = 0, longest_current_draw_streak = 0 WHERE user = " + cnx.quote(_user) );
			
		}
		
		catch (e:Dynamic)
		{	
			trace("MySql error.");		
		}
		
		// save a stat to the game that was just played.
		if (_gameId == 0)
		{
			var _var = cnx.request("UPDATE statistics SET total_games_played = total_games_played + 1, games_all_total_wins = games_all_total_wins + 1, checkers_wins = checkers_wins + 1 WHERE user = " + cnx.quote(_user) );
		}
		
		if (_gameId == 1)
		{
			var _var = cnx.request("UPDATE statistics SET total_games_played = total_games_played + 1, games_all_total_wins = games_all_total_wins + 1, chess_wins = chess_wins + 1 WHERE user = " + cnx.quote(_user) );
		}
			
		if (_gameId == 2)
		{
			var _var = cnx.request("UPDATE statistics SET total_games_played = total_games_played + 1, games_all_total_wins = games_all_total_wins + 1, reversi_wins = reversi_wins + 1 WHERE user = " + cnx.quote(_user) );
		}
			
		if (_gameId == 3)
		{
			var _var = cnx.request("UPDATE statistics SET total_games_played = total_games_played + 1, games_all_total_wins = games_all_total_wins + 1, snakes_and_ladders_wins = snakes_and_ladders_wins + 1 WHERE user = " + cnx.quote(_user) );
		}
			
		if (_gameId == 4)
		{
			var _var = cnx.request("UPDATE statistics SET total_games_played = total_games_played + 1, games_all_total_wins = games_all_total_wins + 1, signature_game_wins = signature_game_wins + 1 WHERE user = " + cnx.quote(_user) );
		}
			
		var _var = cnx.request("UPDATE room_data SET spectator_playing = 0 WHERE user = " + cnx.quote(_user) );
		
		cnx.close();
	
	}
	
	public function lose_at_statistics(_gameId:Int, _user:String, _gameTimePlayedInSeconds:Int = 0):Void
	{
		tryMysqlConnectDatabase();		
		
		try
		{
			if (_gameTimePlayedInSeconds != 0)
			{
				var _var = cnx.request("UPDATE statistics SET shortest_time_game_played = " + _gameTimePlayedInSeconds + " WHERE shortest_time_game_played > " + _gameTimePlayedInSeconds + " AND user = " + cnx.quote(_user) );
				
				var _var = cnx.request("UPDATE statistics SET longest_time_game_played = " + _gameTimePlayedInSeconds + " WHERE longest_time_game_played < " + _gameTimePlayedInSeconds + " AND user = " + cnx.quote(_user) );
			}
			
			// update the lose streak and set the win and draw streak to 0 since those game streaks have ended.
			var _var = cnx.request("UPDATE statistics SET longest_current_losing_streak = longest_current_losing_streak + 1, longest_current_winning_streak = 0, longest_current_draw_streak = 0 WHERE user = " + cnx.quote(_user) );
		}
		
		catch (e:Dynamic)
		{	
			trace("MySql error.");		
		}
		
		if (_gameId == 0)
		{
			var _var = cnx.request("UPDATE statistics SET total_games_played = total_games_played + 1,  games_all_total_losses = games_all_total_losses + 1, checkers_losses = checkers_losses + 1 WHERE user = " + cnx.quote(_user) );
		}
		
		if (_gameId == 1)
		{
			var _var = cnx.request("UPDATE statistics SET total_games_played = total_games_played + 1, games_all_total_losses = games_all_total_losses + 1, chess_losses = chess_losses + 1 WHERE user = " + cnx.quote(_user) );
		}
			
		if (_gameId == 2)
		{
			var _var = cnx.request("UPDATE statistics SET total_games_played = total_games_played + 1, games_all_total_losses = games_all_total_losses + 1, reversi_losses = reversi_losses + 1 WHERE user = " + cnx.quote(_user) );
		}
			
		if (_gameId == 3)
		{
			var _var = cnx.request("UPDATE statistics SET total_games_played = total_games_played + 1, games_all_total_losses = games_all_total_losses + 1, snakes_and_ladders_losses = snakes_and_ladders_losses + 1 WHERE user = " + cnx.quote(_user) );
		}
			
		if (_gameId == 4)
		{
			var _var = cnx.request("UPDATE statistics SET total_games_played = total_games_played + 1, games_all_total_losses = games_all_total_losses + 1, signature_game_losses = signature_game_losses + 1 WHERE user = " + cnx.quote(_user) );
		}
		
		var _var = cnx.request("UPDATE room_data SET spectator_playing = 0 WHERE user = " + cnx.quote(_user) );
		
		cnx.close();
	
	}
	
	public function draw_at_statistics(_gameId:Int, _user:String):Void
	{
		tryMysqlConnectDatabase();		
		
		try
		{
			// update the draw streak and set the win and lose streak to 0 since those game streaks have ended.
			var _var = cnx.request("UPDATE statistics SET longest_current_draw_streak = longest_current_draw_streak + 1, longest_current_winning_streak = 0, longest_current_losing_streak = 0 WHERE user = " + cnx.quote(_user) );
		}
		
		
		if (_gameId == 0)
		{
			var _var = cnx.request("UPDATE statistics SET total_games_played = total_games_played + 1, games_all_total_draws = games_all_total_draws + 1, checkers_draws = checkers_draws + 1 WHERE user = " + cnx.quote(_user) );
		}
		
		if (_gameId == 1)
		{
			var _var = cnx.request("UPDATE statistics SET total_games_played = total_games_played + 1, games_all_total_draws = games_all_total_draws + 1, chess_draws = chess_draws + 1 WHERE user = " + cnx.quote(_user) );
		}
			
		if (_gameId == 2)
		{
			var _var = cnx.request("UPDATE statistics SET total_games_played = total_games_played + 1, games_all_total_draws = games_all_total_draws + 1, reversi_draws = reversi_draws + 1 WHERE user = " + cnx.quote(_user) );
		}
			
		if (_gameId == 3)
		{
			var _var = cnx.request("UPDATE statistics SET total_games_played = total_games_played + 1, games_all_total_draws = games_all_total_draws + 1, snakes_and_ladders_draws = snakes_and_ladders_draws + 1 WHERE user = " + cnx.quote(_user) );
		}
			
		if (_gameId == 4)
		{
			var _var = cnx.request("UPDATE statistics SET total_games_played = total_games_played + 1, games_all_total_draws = games_all_total_draws + 1, signature_game_draws = signature_game_draws + 1 WHERE user = " + cnx.quote(_user) );
		}
		
		var _var = cnx.request("UPDATE room_data SET spectator_playing = 0 WHERE user = " + cnx.quote(_user) );
		
		cnx.close();
	
	}
	
	public function user_validation_code_at_users(_user:String, _email_address_needing_validation:String, _email_address_validation_code:String):Void
	{
		tryMysqlConnectDatabase();		
		
		try {
			var _var = cnx.request("UPDATE users SET 
			email_address_needing_validation = " + cnx.quote(_email_address_needing_validation) + ",
			email_address_validation_code = " + cnx.quote(_email_address_validation_code) + "
			WHERE user = " + cnx.quote(_user));
		
		}
		catch (e:Dynamic)
		{
			trace("MySql error.");		
		}
		
		cnx.close();
	
	}
}