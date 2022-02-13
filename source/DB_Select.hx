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
class DB_Select extends DB_Parent
{
	
	public function count_user_at_user_actions(_user:String, _actionWho:String):Bool
	{
		tryMysqlConnectDatabase();
		
		var rset = cnx.request("SELECT COUNT(*) FROM user_actions WHERE user = " + cnx.quote(_user) + " AND action_who = " + cnx.quote(_actionWho));
				
		cnx.close();
		
		if (rset.getIntResult(0) == 0) return false;
		else return true;
	}
	
	public function count_room_for_room_state_at_room_data(_room:Int):Int
	{
		tryMysqlConnectDatabase();
		
		var rset = cnx.request("SELECT COUNT(*) FROM room_data WHERE room_state = '8' AND room = " + _room);
				
		cnx.close();
		
		return rset.getIntResult(0);
	
	}
	
	public function count_room_at_room_data(_room:Int):Int
	{
		tryMysqlConnectDatabase();
		
		var rset = cnx.request("SELECT COUNT(*) FROM room_data WHERE room_state > '0' AND room = " + _room);
				
		cnx.close();
		
		return rset.getIntResult(0);
	
	}
	
	public function count_for_room_at_who_is_host(_room:Int):Bool
	{
		tryMysqlConnectDatabase();
		
		var rset = cnx.request("SELECT COUNT(*) FROM who_is_host WHERE room = " + _room);
				
		cnx.close();
		
		if (rset.getIntResult(0) == 0) return false;
		else return true;
	}
	
	public function all_at_who_is_host():DB_Parent.MysqlData
	{
		tryMysqlConnectDatabase();		
	
		try {
			var rset = cnx.request("SELECT * FROM who_is_host");
			
			for ( row in rset )
			{			
				_mysqlData._user.push(row.user);
				_mysqlData._room.push(row.room);
				_mysqlData._gid.push(row.gid);
			}
					
		}
		catch (e:Dynamic)
		{
			trace("MySql error.");		
		}
		
		cnx.close();
	
		return _mysqlData;
	}
		
	public function user_all_from_user_location_at_room_data(_user:String):DB_Parent.MysqlData
	{
		tryMysqlConnectDatabase();	
		_user = Std.string(_user);
		
		try {
			
			var rset = cnx.request("SELECT * FROM room_data WHERE user_location = '3' AND user = " + cnx.quote(_user));
		
			for ( row in rset )
			{
				_mysqlData._user.push(row.user);
				_mysqlData._gamePlayersValues.push(row.game_players_values);
				_mysqlData._spectatorPlaying.push(row.spectator_playing);
			}
					
		}
		catch (e:Dynamic)
		{
			trace("MySql error.");		
		}
		
		cnx.close();
		
		return _mysqlData;
	}
	
	// get players stats, such as win or draws.
	public function user_all_at_statistics(_user:String):DB_Parent.MysqlData
	{
		tryMysqlConnectDatabase();
		
		try {
			var rset = cnx.request("SELECT * FROM statistics WHERE user = " + cnx.quote(_user));
			
			for ( row in rset )
			{			
				_mysqlData._user.push(row.user);
				_mysqlData._gamesAllTotalWins.push(row.games_all_total_wins);
				_mysqlData._gamesAllTotalLosses.push(row.games_all_total_losses);
				_mysqlData._gamesAllTotalDraws.push(row.games_all_total_draws);
				_mysqlData._chess_elo_rating.push(row.chess_elo_rating);
				_mysqlData._gamesAllTotalWins.push(row.games_all_total_wins);
				_mysqlData._gamesAllTotalLosses.push(row.games_all_total_losses);
				_mysqlData._gamesAllTotalDraws.push(row.games_all_total_draws);
				_mysqlData._creditsTotal.push(row.credits_total);
				_mysqlData._experiencePoints.push(row.experience_points);
				_mysqlData._houseCoins.push(row.house_coins);
				
				_mysqlData._checkersWins.push(row.checkers_wins);
				_mysqlData._checkersLosses.push(row.checkers_losses);
				_mysqlData._checkersDraws.push(row.checkers_draws);
				_mysqlData._chessWins.push(row.chess_wins);
				_mysqlData._chessLosses.push(row.chess_losses);
				_mysqlData._chessDraws.push(row.chess_draws);
				_mysqlData._reversiWins.push(row.reversi_wins);
				_mysqlData._reversiLosses.push(row.reversi_losses);
				_mysqlData._reversiDraws.push(row.reversi_draws);
				_mysqlData._snakesAndLaddersWins.push(row.snakes_and_ladders_wins);
				_mysqlData._snakesAndLaddersLosses.push(row.snakes_and_ladders_losses);
				_mysqlData._snakesAndLaddersDraws.push(row.snakes_and_ladders_draws);
				_mysqlData._signatureGameWins.push(row.signature_game_wins);
				_mysqlData._signatureGameLosses.push(row.signature_game_losses);
				_mysqlData._signatureGameDraws.push(row.signature_game_draws);
			}

		}
		catch (e:Dynamic)
		{
			trace("MySql error.");		
		}
				
		cnx.close();
		
		return _mysqlData;
	}
		
	/******************************
	* get top 50 leaderboard xp list.
	*/
	public function top_50_statistics():DB_Parent.MysqlData
	{
		tryMysqlConnectDatabase();
				
		try {
			var rset = cnx.request("SELECT * FROM statistics WHERE world_flag != 0 ORDER BY experience_points DESC LIMIT 50");
			
			for ( row in rset )
			{			
				_mysqlData._user.push(row.user);
				_mysqlData._experiencePoints.push(row.experience_points);
				_mysqlData._houseCoins.push(row.house_coins);
				_mysqlData._worldFlag.push(row.world_flag);
			}

		}
		catch (e:Dynamic)
		{
			trace("MySql error.");		
		}
		
		cnx.close();
		
		return _mysqlData;
	}
	
	public function user_all_at_house(_user:String):DB_Parent.MysqlData
	{
		tryMysqlConnectDatabase();
		
		try {
			var rset = cnx.request("SELECT * FROM house WHERE user = " + cnx.quote(_user));
					
			for ( row in rset )
			{
				_mysqlData._user.push(row.user);
				
				_mysqlData._spriteNumber.push(row.sprite_number);
				_mysqlData._spriteName.push(row.sprite_name);
				_mysqlData._itemsX.push(row.items_x);
				_mysqlData._itemsY.push(row.items_y);
				_mysqlData._mapX.push(row.map_x);
				_mysqlData._mapY.push(row.map_y);
				_mysqlData._isItemPurchased.push(row.is_item_purchased);
				
				_mysqlData._itemDirectionFacing.push(row.item_direction_facing);
				_mysqlData._mapOffsetX.push(row.map_offset_x);
				_mysqlData._mapOffsetY.push(row.map_offset_y);
				_mysqlData._itemIsHidden.push(row.item_is_hidden);
				_mysqlData._itemOrder.push(row.item_order);
				_mysqlData._itemBehindWalls.push(row.item_behind_walls);
				_mysqlData._floor.push(row.floor);
				
				_mysqlData._wallLeft.push(row.wall_left);
				_mysqlData._wallUpBehind.push(row.wall_up_behind);
				_mysqlData._wallUpInFront.push(row.wall_up_in_front);
				_mysqlData._floorIsHidden.push(row.floor_is_hidden);
				_mysqlData._wallLeftIsHidden.push(row.wall_left_is_hidden);
				_mysqlData._wallUpBehindIsHidden.push(row.wall_up_behind_is_hidden);
				_mysqlData._wallUpInFrontIsHidden.push(row.wall_up_in_front_is_hidden);
			}

		}
		catch (e:Dynamic)
		{
			trace("MySql error.");		
		}
		
		cnx.close();
		
		return _mysqlData;
	}
		
	/******************************
	 * room data changes every time player calls "Greater" or "Lesser" room data events.
	 */
	public function user_all_by_timestamp_at_room_data(_room:Int):DB_Parent.MysqlData
	{
		tryMysqlConnectDatabase();		
	
		var rset = cnx.request("SELECT * FROM room_data WHERE room = " + _room + " 
		ORDER BY timestamp ASC");
		
		for ( row in rset )
		{			
			_mysqlData._user.push(row.user);
			_mysqlData._userLocation.push(row.user_location);
			_mysqlData._room.push(row.room);
			_mysqlData._roomState.push(row.room_state);
			_mysqlData._playerLimit.push(row.player_limit);
			_mysqlData._timestamp.push(row.timestamp);
		}

		return _mysqlData;
	}
	
	
	public function room_not_spectator_watching_at_room_data(_room:Int):DB_Parent.MysqlData
	{
		tryMysqlConnectDatabase();		
	
		var rset = cnx.request("SELECT * FROM room_data WHERE spectator_watching = 0 AND user_location = 3 AND room = " + _room + " 
		ORDER BY timestamp ASC");
		
		for ( row in rset )
		{			
			_mysqlData._user.push(row.user);
			_mysqlData._userLocation.push(row.user_location);
			_mysqlData._room.push(row.room);
			_mysqlData._roomState.push(row.room_state);
			_mysqlData._playerLimit.push(row.player_limit);
			_mysqlData._timestamp.push(row.timestamp);
			_mysqlData._gamePlayersValues.push(row.game_players_values);
			_mysqlData._spectatorPlaying.push(row.spectator_playing);
			_mysqlData._spectatorWatching.push(row.spectator_watching);
			_mysqlData._moveNumberDynamic.push(row.move_number_dynamic);
		}

		return _mysqlData;
	}
	
	public function is_game_finished_at_room_data():DB_Parent.MysqlData
	{
		tryMysqlConnectDatabase();		
	
		var rset = cnx.request("SELECT * FROM room_data WHERE is_game_finished = 1 AND user_location = '0' ORDER BY timestamp ASC");
		
		for ( row in rset )
		{			
			_mysqlData._user.push(row.user);
			_mysqlData._userLocation.push(row.user_location);
			_mysqlData._room.push(row.room);
			_mysqlData._roomState.push(row.room_state);
			_mysqlData._playerLimit.push(row.player_limit);
			_mysqlData._timestamp.push(row.timestamp);
		}

		return _mysqlData;
	}
		
	/******************************
	 * get all data for room_data table.
	 */
	public function all_by_desc_at_room_data():DB_Parent.MysqlData
	{
		tryMysqlConnectDatabase();		
	
		var rset = cnx.request("SELECT * FROM room_data
		ORDER BY room ASC");
		
		for ( row in rset )
		{			
			_mysqlData._user.push(row.user);
			_mysqlData._userId.push(row.user_id);
			_mysqlData._roomState.push(row.room_state);
			_mysqlData._userLocation.push(row.user_location);
			_mysqlData._room.push(row.room);
			_mysqlData._playerLimit.push(row.player_limit);
			_mysqlData._allowSpectators.push(row.allow_spectators);
			_mysqlData._gameId.push(row.game_id);
			_mysqlData._timestamp.push(row.timestamp);
		}

		cnx.close();

		return _mysqlData;
	}
	
	
	/******************************
	 * get all data for user at this room_data table.
	 */
	public function user_all_at_room_data(_user:String):DB_Parent.MysqlData
	{
		tryMysqlConnectDatabase();		
		
		try {
			var rset = cnx.request("SELECT * FROM room_data WHERE user = " + cnx.quote(_user));
		
			for ( row in rset )
			{			
				_mysqlData._user.push(row.user);
				_mysqlData._userId.push(row.user_id);
				_mysqlData._roomState.push(row.room_state);
				_mysqlData._userLocation.push(row.user_location);
				_mysqlData._room.push(row.room);
				_mysqlData._playerLimit.push(row.player_limit);
				_mysqlData._isGameFinished.push(row.is_game_finished);
				_mysqlData._timestamp.push(row.timestamp);
				_mysqlData._gamePlayersValues.push(row.game_players_values);
				_mysqlData._spectatorPlaying.push(row.spectator_playing);
				_mysqlData._spectatorWatching.push(row.spectator_watching);
				_mysqlData._gameId.push(row.game_id);
			}
		}
		
		catch (e:Dynamic)
		{
			trace("MySql error.");		
		}
		
		cnx.close();
		
		return _mysqlData;
	}
	
	/******************************
	 * used to populate the .usernameOther to display the user's name and stats correctly at waiting room.
	 */
	public function room_by_timestamp_asc_at_room_data(_room:Int):DB_Parent.MysqlData
	{
		tryMysqlConnectDatabase();		
	
		var rset = cnx.request("SELECT * FROM room_data WHERE 
		user_location > '1' AND spectator_watching = '0' AND room = " + _room + " 
		ORDER BY timestamp ASC");
		
		for ( row in rset )
		{			
			_mysqlData._user.push(row.user);
			_mysqlData._userLocation.push(row.user_location);
			_mysqlData._room.push(row.room);
			_mysqlData._playerLimit.push(row.player_limit);
			_mysqlData._timestamp.push(row.timestamp);
			_mysqlData._gamePlayersValues.push(row.game_players_values);
			_mysqlData._spectatorPlaying.push(row.spectator_playing);
			_mysqlData._spectatorWatching.push(row.spectator_watching);
		}

		cnx.close();

		return _mysqlData;
	}
	
	/******************************
	 * used to populate the .usernameOther to display the user's name and stats correctly at game room.
	 */
	public function user_location_by_timestamp_asc_at_room_data(_room:Int):DB_Parent.MysqlData
	{
		tryMysqlConnectDatabase();		
	
		var rset = cnx.request("SELECT * FROM room_data WHERE 
		room_state = '8' AND user_location = '3' AND room = " + _room + " ORDER BY timestamp ASC");
		
		for ( row in rset )
		{			
			_mysqlData._user.push(row.user);
			_mysqlData._userLocation.push(row.user_location);
			_mysqlData._room.push(row.room);
			_mysqlData._playerLimit.push(row.player_limit);
			_mysqlData._timestamp.push(row.timestamp);
			_mysqlData._gamePlayersValues.push(row.game_players_values);
			_mysqlData._spectatorPlaying.push(row.spectator_playing);
		}

		cnx.close();

		return _mysqlData;
	}
	
	/******************************
	 * get players in all rooms that are not playing a game.
	 */	 
	public function waiting_room_by_timestamp_at_room_data():DB_Parent.MysqlData
	{
		tryMysqlConnectDatabase();
		
		try {
			var rset = cnx.request("SELECT room FROM room_data WHERE 
			user_location = '2' ORDER BY timestamp ASC");
			
			for ( row in rset )
			{	
				_mysqlData._room.push(row.room);
			}

		}
		catch (e:Dynamic)
		{
			trace("MySql error.");		
		}
		
		cnx.close();
		
		return _mysqlData;
	}
	
	/******************************
	 * used to determine if a room is locked.
	 */
	public function room_at_room_lock(_room:Int):DB_Parent.MysqlData
	{
		tryMysqlConnectDatabase();
		
		try 
		{
			var rset = cnx.request("SELECT * FROM room_lock WHERE room = " + _room);
			for ( row in rset )
			{	
				_mysqlData._room.push(row.room);
			}
		}
		catch (e:Dynamic)
		{
			trace("MySql error.");		
		}
		
		cnx.close();
		
		return _mysqlData;
	}
	
	/******************************
	* load daily quest data for player.
	*/
	public function user_daily_quests(_user:String):DB_Parent.MysqlData
	{
	   tryMysqlConnectDatabase();
	   
	   try 
	   {
		   var rset = cnx.request("SELECT * FROM daily_quests WHERE user = " + cnx.quote(_user));
		   for ( row in rset )
		   {	
				_mysqlData._three_in_a_row.push(row.three_in_a_row);
				_mysqlData._chess_5_moves_under.push(row.chess_5_moves_under);
				_mysqlData._snakes_under_4_moves.push(row.snakes_under_4_moves);
				_mysqlData._win_5_minute_game.push(row.win_5_minute_game);
				_mysqlData._buy_four_house_items.push(row.buy_four_house_items);
				_mysqlData._finish_signature_game.push(row.finish_signature_game);
				_mysqlData._reversi_occupy_50_units.push(row.reversi_occupy_50_units);
				_mysqlData._checkers_get_6_kings.push(row.checkers_get_6_kings);
				_mysqlData._play_all_5_board_games.push(row.play_all_5_board_games);
				_mysqlData._day_name.push(row.day_name);
				_mysqlData._rewards.push(row.rewards);
				_mysqlData._timestamp.push(row.timestamp);
		   }
	   }
	   catch (e:Dynamic)
	   {
			trace("MySql error.");		
	   }
	   
	   cnx.close();
	   
	   return _mysqlData;
	   
	}
	
	public function tournament_data():DB_Parent.MysqlData
	{
		tryMysqlConnectDatabase();	
		
		try 
		{
			var rset = cnx.request("SELECT * FROM tournament_data WHERE id = 1");
			for ( row in rset )
			{
				_mysqlData._player_maximum.push(row.players);
			}
		}
		catch (e:Dynamic)
		{
			trace("MySql error.");		
		}
		
		cnx.close();
		
		return _mysqlData;
	}
	
	public function tournament_chess_standard_8_count():Int
	{
		tryMysqlConnectDatabase();	
		
		var rset = cnx.request("SELECT COUNT(*) FROM tournament_chess_standard_8");
		
		cnx.close();
		
		return rset.getIntResult(0);
	}
	
	public function tournament_chess_standard_8(_user:String, _game_id:Int):DB_Parent.MysqlData
	{
		tryMysqlConnectDatabase();			
				
		try 
		{
			var rset = cnx.request("SELECT * FROM tournament_chess_standard_8 WHERE player1 = " + cnx.quote(_user) );
			for ( row in rset )
			{
				_mysqlData._user.push(row.player1);
				_mysqlData._user2.push(row.player2);
				_mysqlData._gid.push(row.gid);
				_mysqlData._tournament_started.push(row.tournament_started);
				_mysqlData._move_total.push(row.move_total);
				_mysqlData._room.push(row.room);
				_mysqlData._round_current.push(row.round_current);
				_mysqlData._rounds_total.push(row.rounds_total);
				_mysqlData._reminder_by_mail.push(row.reminder_by_mail);				
				_mysqlData._won_game.push(row.won_game);
				_mysqlData._move_piece.push(row.move_piece);
				_mysqlData._move_number_current.push(row.move_number_current);
				_mysqlData._time_remaining_player1.push(row.time_remaining_player1);
				_mysqlData._time_remaining_player2.push(row.time_remaining_player2);
				_mysqlData._isGameFinished.push(row.game_over);
				_mysqlData._timestamp.push(row.timestamp);
			}
		}
		catch (e:Dynamic)
		{
			trace("MySql error.");		
		}
		
		cnx.close();
		
		return _mysqlData;
	}
	
	/******************************
	 * count total users. if count is greater then zero the return as true.
	 */
	public function count_from_logged_in_users(_user:String):Bool
	{
		tryMysqlConnectDatabase();
		
		var rset = cnx.request("SELECT COUNT(*) FROM logged_in_users WHERE user = " + cnx.quote(_user));
				
		cnx.close();
		
		if (rset.getIntResult(0) == 0) return false;
		else return true;
	}
	
	public function user_avatar_from_statistics(_user:String):DB_Parent.MysqlData
	{			
		tryMysqlConnectDatabase();
		
		try {
			var rset = cnx.request("SELECT * FROM statistics WHERE user = " + cnx.quote(_user));
			
			for ( row in rset )
			{			
				_mysqlData._user.push(row.username);
				_mysqlData._avatarNumber.push(row.user_avatar);
			}
		
		}
		catch (e:Dynamic)
		{
			trace("MySql error.");		
		}
		
		cnx.close();
		
		return _mysqlData;
	}
	
		
	public function user_data_from_user_action(_user:String, _actionWho:String):DB_Parent.MysqlData
	{			
		tryMysqlConnectDatabase();
		
		try {
			var rset = cnx.request("SELECT * FROM user_actions WHERE user = " + cnx.quote(_user) + "AND action_who = " + cnx.quote(_actionWho));
			
			for ( row in rset )
			{			
				_mysqlData._user.push(row.user);
				_mysqlData._actionWho.push(row.action_who);
				_mysqlData._actionNumber.push(row.action_number);
				_mysqlData._timestamp.push(row.timestamp);
				_mysqlData._minutesTotal.push(row.minutes_total);
			}
		
		}
		catch (e:Dynamic)
		{
			trace("MySql error.");		
		}
		
		cnx.close();
		
		return _mysqlData;
	}
	
	public function user_elo_rating_from_statistics(_user:String):DB_Parent.MysqlData
	{			
		tryMysqlConnectDatabase();
		
		try {
			var rset = cnx.request("SELECT * FROM statistics WHERE user = " + cnx.quote(_user));
			
			for ( row in rset )
			{			
				_mysqlData._user.push(row.user);
				_mysqlData._chess_elo_rating.push(row.chess_elo_rating);
			}
		
		}
		catch (e:Dynamic)
		{
			trace("MySql error.");		
		}
		
		cnx.close();
		
		return _mysqlData;
	}
	
	/******************************
	 * get all data at hostname table row.
	 */
	public function data_from_hostname_at_users(_hostname:String):DB_Parent.MysqlData
	{			
		tryMysqlConnectDatabase();
		
		try {
			var rset = cnx.request("SELECT * FROM users WHERE hostname = " + cnx.quote(_hostname));
			
			for ( row in rset )
			{			
				_mysqlData._user.push(row.user);
				_mysqlData._hostname.push(row.hostname);
				_mysqlData._password_hash.push(row.password_hash);
			}
		
		}
		catch (e:Dynamic)
		{
			trace("MySql error.");		
		}
		
		cnx.close();
		
		return _mysqlData;
	}
	
	public function limit_120_kicked_users():DB_Parent.MysqlData
	{			
		tryMysqlConnectDatabase();
			
		try
		{
			var rset = cnx.request("SELECT * FROM kicked WHERE timestamp > " + Sys.time() + " ORDER BY id ASC LIMIT 120");
			
			for ( row in rset )
			{			
				_mysqlData._user.push(row.user);
				_mysqlData._message.push(row.message);
				_mysqlData._timestamp.push(row.timestamp);
				_mysqlData._minutesTotal.push(row.minutes_total);
			}

		}
		
		catch (e:Dynamic)
		{
			trace("MySql error.");		
		}

		cnx.close();
		
		return _mysqlData;
	}
			
	public function limit_120_banned_users():DB_Parent.MysqlData
	{			
		tryMysqlConnectDatabase();
		
		try
		{
			var rset = cnx.request("SELECT * FROM banned ORDER BY id DESC LIMIT 120");
				
			for ( row in rset )
			{			
				_mysqlData._user.push(row.user);
				_mysqlData._ip.push(row.ip);
				_mysqlData._message.push(row.message);
			}
			
		}
		
		catch (e:Dynamic)
		{
			trace("MySql error.");		
		}

		cnx.close();
		
		return _mysqlData;
	}
	
	public function guests_from_users_table():DB_Parent.MysqlData
	{			
		tryMysqlConnectDatabase();
		
		try
		{
			var rset = cnx.request("SELECT * FROM users WHERE user like 'Guest%' order by user ASC");
				
			for ( row in rset )
			{			
				_mysqlData._user.push(row.user);
				_mysqlData._hostname.push(row.hostname);
			}
			
		} 
		
		catch (e:Dynamic)
		{
			trace("MySql error.");		
		}
		
		cnx.close();
		
		return _mysqlData;
	}
	
	// TODO this function is not in use.
	public function user_all_at_users(_user:String):DB_Parent.MysqlData
	{			
		tryMysqlConnectDatabase();
		
		try
		{
			var rset = cnx.request("SELECT * FROM users WHERE user = " + cnx.quote(_user));
				
			for ( row in rset )
			{			
				_mysqlData._user.push(row.user);
				_mysqlData._ip.push(row.ip);
				_mysqlData._password_hash.push(row.password_hash);
				_mysqlData._hostname.push(row.hostname);
				_mysqlData._isPaidMember.push(row.is_paid_member);
			}
			
		} 
		
		catch (e:Dynamic)
		{
			trace("MySql error.");		
		}

		cnx.close();
		
		return _mysqlData;
	}
	
	public function last_logged_in_guest():DB_Parent.MysqlData
	{			
		tryMysqlConnectDatabase();

		try
		{
			var rset = cnx.request("SELECT * FROM users WHERE user like 'guest%' ORDER BY user ASC LIMIT 1");
			
			for ( row in rset )
			{			
				_mysqlData._user.push(row.user);
			}

		}
		
		catch (e:Dynamic)
		{
			trace("MySql error.");		
		}
		
		cnx.close();
		
		return _mysqlData;
	}
	
	public function all_move_history(_gid:String):DB_Parent.MysqlData
	{			
		tryMysqlConnectDatabase();
		
		try 
		{			
			var rset = cnx.request("SELECT * FROM move_history WHERE gid = " + cnx.quote(_gid));
					
			for ( row in rset )
			{			
				_mysqlData._user.push(row.user);
				_mysqlData._point_value.push(row.point_value);
				_mysqlData._unique_value.push(row.unique_value);
				_mysqlData._moveHistoryPieceLocationOld1.push(row.piece_location_old1);
				_mysqlData._moveHistoryPieceLocationNew1.push(row.piece_location_new1);
				_mysqlData._moveHistoryPieceLocationOld2.push(row.piece_location_old2);
				_mysqlData._moveHistoryPieceLocationNew2.push(row.piece_location_new2);

				_mysqlData._moveHistoryPieceValueOld1.push(row.piece_value_old1);
				_mysqlData._moveHistoryPieceValueNew1.push(row.piece_value_new1);
				_mysqlData._moveHistoryPieceValueOld2.push(row.piece_value_old2);
				_mysqlData._moveHistoryPieceValueNew2.push(row.piece_value_new2);
				_mysqlData._moveHistoryPieceValueOld3.push(row.piece_value_old3);
			}

		}
		
		catch (e:Dynamic)
		{
			trace("MySql error.");		
		}
		
		cnx.close();
		
		return _mysqlData;
	}
	
	// get all credit data for user.
	public function user_get_all_at_statistics(_user:String):DB_Parent.MysqlData
	{			
		tryMysqlConnectDatabase();
		
		try
		{
			var rset = cnx.request("SELECT * FROM statistics WHERE user = " + cnx.quote(_user));
			
			for ( row in rset )
			{			
				_mysqlData._ip.push(row.ip);
				
				_mysqlData._eventMonth.push(row.event_month);
				_mysqlData._eventDay.push(row.event_day);
				_mysqlData._creditsToday.push(row.credits_today);
				_mysqlData._creditsTotal.push(row.credits_total);
			}
		}
		
		catch (e:Dynamic)
		{
			trace("MySql error.");		
		}
		
		cnx.close();
		
		return _mysqlData;
	}
	
	/******************************
	 * used to get the id of the server. every server has a different id. a query is read every so many ticks and when that query has a field such as disconnect_1 that matches lets say server id of 1 then that server will be disconnected or a disconnect cancelled.
	 */
	public function server_data_at_servers_status():DB_Parent.MysqlData
	{
		tryMysqlConnectDatabase();		
	
		try {
			var rset = cnx.request("SELECT * FROM servers_status");
		
			for ( row in rset )
			{
				_mysqlData._serversOnline.push(row.servers_online);
				
				_mysqlData._connected1.push(row.connected_1);
				_mysqlData._connected2.push(row.connected_2);
				_mysqlData._connected3.push(row.connected_3);
				_mysqlData._connected4.push(row.connected_4);
				_mysqlData._connected5.push(row.connected_5);
				_mysqlData._connected6.push(row.connected_6);
				_mysqlData._connected7.push(row.connected_7);
				_mysqlData._connected8.push(row.connected_8);
				_mysqlData._connected9.push(row.connected_9);
				_mysqlData._connected10.push(row.connected_10);
				_mysqlData._connected11.push(row.connected_11);
				_mysqlData._connected12.push(row.connected_12);
				_mysqlData._connected13.push(row.connected_13);
				_mysqlData._connected14.push(row.connected_14);
				_mysqlData._connected15.push(row.connected_15);
				_mysqlData._connected16.push(row.connected_16);
				_mysqlData._connected17.push(row.connected_17);
				_mysqlData._connected18.push(row.connected_18);
				_mysqlData._connected19.push(row.connected_19);
				_mysqlData._connected20.push(row.connected_20);
				
				_mysqlData._disconnect1.push(row.disconnect_1);
				_mysqlData._disconnect2.push(row.disconnect_2);
				_mysqlData._disconnect3.push(row.disconnect_3);
				_mysqlData._disconnect4.push(row.disconnect_4);
				_mysqlData._disconnect5.push(row.disconnect_5);
				_mysqlData._disconnect6.push(row.disconnect_6);
				_mysqlData._disconnect7.push(row.disconnect_7);
				_mysqlData._disconnect8.push(row.disconnect_8);
				_mysqlData._disconnect9.push(row.disconnect_9);
				_mysqlData._disconnect10.push(row.disconnect_10);
				_mysqlData._disconnect11.push(row.disconnect_11);
				_mysqlData._disconnect12.push(row.disconnect_12);
				_mysqlData._disconnect13.push(row.disconnect_13);
				_mysqlData._disconnect14.push(row.disconnect_14);
				_mysqlData._disconnect15.push(row.disconnect_15);
				_mysqlData._disconnect16.push(row.disconnect_16);
				_mysqlData._disconnect17.push(row.disconnect_17);
				_mysqlData._disconnect18.push(row.disconnect_18);
				_mysqlData._disconnect19.push(row.disconnect_19);
				_mysqlData._disconnect20.push(row.disconnect_20);
				
				_mysqlData._doOnce1.push(row.do_once_1);
				_mysqlData._doOnce2.push(row.do_once_2);
				_mysqlData._doOnce3.push(row.do_once_3);
				_mysqlData._doOnce4.push(row.do_once_4);
				_mysqlData._doOnce5.push(row.do_once_5);
				_mysqlData._doOnce6.push(row.do_once_6);
				_mysqlData._doOnce7.push(row.do_once_7);
				_mysqlData._doOnce8.push(row.do_once_8);
				_mysqlData._doOnce9.push(row.do_once_9);
				_mysqlData._doOnce10.push(row.do_once_10);
				_mysqlData._doOnce11.push(row.do_once_11);
				_mysqlData._doOnce12.push(row.do_once_12);
				_mysqlData._doOnce13.push(row.do_once_13);
				_mysqlData._doOnce14.push(row.do_once_14);
				_mysqlData._doOnce15.push(row.do_once_15);
				_mysqlData._doOnce16.push(row.do_once_16);
				_mysqlData._doOnce17.push(row.do_once_17);
				_mysqlData._doOnce18.push(row.do_once_18);
				_mysqlData._doOnce19.push(row.do_once_19);
				_mysqlData._doOnce20.push(row.do_once_20);
				
				_mysqlData._timestamp1.push(row.timestamp_1);
				_mysqlData._timestamp2.push(row.timestamp_2);
				_mysqlData._timestamp3.push(row.timestamp_3);
				_mysqlData._timestamp4.push(row.timestamp_4);
				_mysqlData._timestamp5.push(row.timestamp_5);
				_mysqlData._timestamp6.push(row.timestamp_6);
				_mysqlData._timestamp7.push(row.timestamp_7);
				_mysqlData._timestamp8.push(row.timestamp_8);
				_mysqlData._timestamp9.push(row.timestamp_9);
				_mysqlData._timestamp10.push(row.timestamp_10);
				_mysqlData._timestamp11.push(row.timestamp_11);
				_mysqlData._timestamp12.push(row.timestamp_12);
				_mysqlData._timestamp13.push(row.timestamp_13);
				_mysqlData._timestamp14.push(row.timestamp_14);
				_mysqlData._timestamp15.push(row.timestamp_15);
				_mysqlData._timestamp16.push(row.timestamp_16);
				_mysqlData._timestamp17.push(row.timestamp_17);
				_mysqlData._timestamp18.push(row.timestamp_18);
				_mysqlData._timestamp19.push(row.timestamp_19);
				_mysqlData._timestamp20.push(row.timestamp_20);
				
				_mysqlData._messageOnline.push(row.message_online);
				_mysqlData._messageOffline.push(row.message_offline);
			}
		}
		
		catch (e:Dynamic)
		{
			trace("MySql error.");		
		}
		
		cnx.close();
		
		return _mysqlData;
	}	
	
}